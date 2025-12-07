import 'package:flutter/material.dart';
import 'package:auty_conductor/core/ws/ws_service.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';

class ChatProvider extends ChangeNotifier {
  final SendMessageUseCase sendUseCase;
  final GetMessagesUseCase getUseCase;
  final WsService ws;

  List<ChatMessageEntity> messages = [];
  bool loading = false;

  ChatProvider({
    required this.sendUseCase,
    required this.getUseCase,
    required this.ws,
  });

  // =====================================================
  // CARGAR HISTORIAL
  // =====================================================
  Future<void> loadMessages(String chatUuid) async {
    loading = true;
    notifyListeners();

    try {
      final raw = await getUseCase.call(chatUuid);

      // Eliminar duplicados por ID
      final unique = <String, ChatMessageEntity>{};
      for (var m in raw) {
        if (m.id != null) {
          unique[m.id.toString()] = m;
        }
      }

      messages = unique.values.toList();
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } catch (e) {
      print("❌ Error cargando mensajes: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // =====================================================
  // ENVIAR CHAT
  // =====================================================
  Future<void> send({
    required String chatUuid,
    required String driverUuid,
    required String mechanicUuid,
    required String senderType,
    required String message,
  }) async {
    // 1️⃣ Crear mensaje local (optimista)
    final localMsg = ChatMessageEntity(
      id: null, // Sin ID porque aún no está en BD
      chatUuid: chatUuid,
      driverUuid: driverUuid,
      mechanicUuid: mechanicUuid,
      senderType: senderType,
      message: message,
      createdAt: DateTime.now(),
    );

    // 2️⃣ Agregar a la UI inmediatamente
    messages.add(localMsg);
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    notifyListeners();

    // 3️⃣ Enviar por WebSocket
    ws.sendChatMessage(
      chatUuid: chatUuid,
      driverUuid: driverUuid,
      mechanicUuid: mechanicUuid,
      senderType: senderType,
      message: message,
    );
  }

  // =====================================================
  // MENSAJE RECIBIDO POR WS EN TIEMPO REAL
  // =====================================================
  void addRealtimeMessage(ChatMessageEntity msg) {
    // Evitar duplicados (por ID o por contenido+timestamp)
    final isDuplicate = messages.any((m) {
      // Si ambos tienen ID, comparar por ID
      if (m.id != null && msg.id != null) {
        return m.id == msg.id;
      }

      // Si no, comparar por contenido y timestamp (similar)
      return m.message == msg.message &&
          m.senderType == msg.senderType &&
          m.createdAt.difference(msg.createdAt).inSeconds.abs() < 2;
    });

    if (!isDuplicate) {
      messages.add(msg);
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      notifyListeners();
      print("✅ Mensaje agregado en tiempo real");
    } else {
      print("⚠️ Mensaje duplicado ignorado");
    }
  }

  // =====================================================
  // LIMPIAR CHAT
  // =====================================================
  void clear() {
    messages.clear();
    notifyListeners();
  }
}