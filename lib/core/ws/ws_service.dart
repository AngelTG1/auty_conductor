import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

class WsService extends ChangeNotifier {
  WebSocketChannel? _channel;

  bool connected = false;
  bool manuallyClosed = false;

  String? lastUsedUuid;
  Map<String, dynamic>? lastMessage;

  // ⭐ Último mensaje de chat normalizado
  Map<String, dynamic>? lastChatMessage;

  // =======================================================
  // CONNECT
  // =======================================================
  void connect(String uuid) {
    print("🔵 Conectando WS con uuid: $uuid");

    if (connected) {
      print("⛔ WS ya estaba conectado → evitar duplicado");
      return;
    }

    manuallyClosed = false;
    lastUsedUuid = uuid;

    disconnect();

    try {
      _channel = WebSocketChannel.connect(
        // Uri.parse("ws://auty-microservices-production.up.railway.app"),
        Uri.parse("wss://auty-microservices-production.up.railway.app"),
      );

      _channel!.sink.add(jsonEncode({"type": "register", "uuid": uuid}));

      connected = true;
      notifyListeners();

      print("🟢 WS conectado y registrado");
      _listen();
    } catch (e) {
      print("❌ Error al conectar WS: $e");
      _reconnectLater();
    }
  }

  // =======================================================
  // ESCUCHAR MENSAJES WS
  // =======================================================
  void _listen() {
    _channel!.stream.listen(
      (event) {
        try {
          final msg = jsonDecode(event);
          print("📩 WS → $msg");

          lastMessage = msg;

          // ⭐ Si es un mensaje de chat, normalizarlo
          if (msg["type"] == "chat_message") {
            final data = msg["data"];

            if (data != null) {
              lastChatMessage = {
                "id":
                    data["id"]?.toString() ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                "chatUuid": data["chatUuid"] ?? data["chat_uuid"] ?? "",
                "driverUuid": data["driverUuid"] ?? data["driver_uuid"] ?? "",
                "mechanicUuid":
                    data["mechanicUuid"] ?? data["mechanic_uuid"] ?? "",
                "senderType": data["senderType"] ?? data["sender_type"] ?? "",
                "message": data["message"] ?? "",
                "createdAt":
                    data["createdAt"] ??
                    data["created_at"] ??
                    DateTime.now().toIso8601String(),
              };

              print("✅ Chat normalizado: $lastChatMessage");
            }
          }

          notifyListeners();
        } catch (e) {
          print("❌ Error parseando mensaje WS: $e");
        }
      },

      onError: (err) {
        print("❌ WS error: $err");
        connected = false;
        notifyListeners();
        _reconnectLater();
      },

      onDone: () {
        print("🔴 WS cerrado");
        connected = false;
        notifyListeners();

        if (!manuallyClosed) {
          print("🟡 Reintentando WS...");
          _reconnectLater();
        }
      },
    );
  }

  // =======================================================
  // 🚗 ENVIAR SOLICITUD DE MECÁNICO (ya funcionaba)
  // =======================================================
  void sendCreateRequest(Map<String, dynamic> data) {
    if (_channel == null || !connected) {
      print("❌ No se puede enviar solicitud: WS no conectado");
      return;
    }

    final msg = {"type": "create_request", "data": data};
    print("📤 Enviando solicitud → $msg");

    _channel!.sink.add(jsonEncode(msg));
  }

  // =======================================================
  // 💬 ENVIAR MENSAJE DE CHAT
  // =======================================================
  void sendChatMessage({
    required String chatUuid,
    required String driverUuid,
    required String mechanicUuid,
    required String senderType,
    required String message,
  }) {
    if (_channel == null || !connected) {
      print("❌ No se puede enviar mensaje: WS no conectado");
      return;
    }

    final msg = {
      "type": "chat_message",
      "data": {
        "chatUuid": chatUuid,
        "driverUuid": driverUuid,
        "mechanicUuid": mechanicUuid,
        "senderType": senderType,
        "message": message,
      },
    };

    print("📤 CONDUCTOR envía chat → $msg");

    try {
      _channel!.sink.add(jsonEncode(msg));
      print("✅ Mensaje enviado correctamente");
    } catch (e) {
      print("❌ Error enviando mensaje WS: $e");
    }
  }

  // =======================================================
  // RECONEXIÓN AUTOMÁTICA
  // =======================================================
  void _reconnectLater() {
    if (manuallyClosed) return;

    Future.delayed(const Duration(seconds: 3), () {
      if (!connected && lastUsedUuid != null) {
        print("🔁 Reconectar WS…");
        connect(lastUsedUuid!);
      }
    });
  }

  // =======================================================
  // DESCONECTAR
  // =======================================================
  void disconnect() {
    manuallyClosed = true;

    try {
      _channel?.sink.close(ws_status.normalClosure);
    } catch (_) {}

    _channel = null;
    connected = false;
    notifyListeners();
  }
}
