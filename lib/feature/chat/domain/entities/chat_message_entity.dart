class ChatMessageEntity {
  final int? id;
  final String chatUuid;
  final String driverUuid;
  final String mechanicUuid;
  final String senderType;
  final String message;
  final DateTime createdAt;

  ChatMessageEntity({
    this.id,
    required this.chatUuid,
    required this.driverUuid,
    required this.mechanicUuid,
    required this.senderType,
    required this.message,
    required this.createdAt,
  });
}
