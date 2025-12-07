import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    super.id,
    required super.chatUuid,
    required super.driverUuid,
    required super.mechanicUuid,
    required super.senderType,
    required super.message,
    required super.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json["id"],

      // ⭐ SOPORTE DUAL: camelCase Y snake_case
      chatUuid: json["chatUuid"] ?? json["chat_uuid"] ?? "",
      driverUuid: json["driverUuid"] ?? json["driver_uuid"] ?? "",
      mechanicUuid: json["mechanicUuid"] ?? json["mechanic_uuid"] ?? "",
      senderType: json["senderType"] ?? json["sender_type"] ?? "",
      message: json["message"] ?? "",

      // ⭐ Soporte dual para fecha
      createdAt: DateTime.parse(
        json["createdAt"] ??
            json["created_at"] ??
            DateTime.now().toIso8601String(),
      ),
    );
  }
}
