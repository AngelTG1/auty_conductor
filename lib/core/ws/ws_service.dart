import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

class WsService extends ChangeNotifier {
  WebSocketChannel? _channel;

  bool connected = false;
  bool manuallyClosed = false;

  String? lastUsedUuid;
  String? lastRequestUuid;

  Map<String, dynamic>? lastMessage;

  // =======================================================
  // CONECTAR WS (con reconexión automática)
  // =======================================================
  void connect(String uuid) {
    print("🔵 Conectando WS con uuid: $uuid");

    manuallyClosed = false;
    lastUsedUuid = uuid;

    disconnect(); // limpiar vieja conexión

    try {
      _channel = WebSocketChannel.connect(Uri.parse("ws://192.168.0.21:3000"));

      // Registrar uuid
      _channel!.sink.add(jsonEncode({"type": "register", "uuid": uuid}));

      connected = true;
      notifyListeners();

      _listen();
    } catch (e) {
      print("❌ Error al conectar WS: $e");
      _reconnectLater();
    }
  }

  // =======================================================
  // ESCUCHAR
  // =======================================================
  void _listen() {
    _channel!.stream.listen(
      (event) {
        final msg = jsonDecode(event);
        print("📩 WS mensaje → $msg");

        // Filtrar duplicados
        final data = msg["data"];
        if (data is Map && data["uuid"] != null) {
          if (data["uuid"] == lastRequestUuid) return;
          lastRequestUuid = data["uuid"];
        }

        lastMessage = msg;
        notifyListeners();
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
  // ENVIAR SOLICITUD
  // =======================================================
  void sendCreateRequest(Map<String, dynamic> data) {
    if (_channel == null) return;

    final msg = {"type": "create_request", "data": data};

    print("📤 WS enviar → $msg");

    _channel!.sink.add(jsonEncode(msg));
  }

  // =======================================================
  // RECONEXIÓN
  // =======================================================
  void _reconnectLater() {
    if (manuallyClosed) return;

    Future.delayed(const Duration(seconds: 3), () {
      if (!connected && lastUsedUuid != null) {
        print("🔁 Reconectar WS...");
        connect(lastUsedUuid!);
      }
    });
  }

  // =======================================================
  // DESCONECTAR (solo logout)
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
