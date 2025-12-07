import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  Future<ChatMessageEntity> sendMessage(Map<String, dynamic> body);
  Future<List<ChatMessageEntity>> getMessages(String chatUuid);
}
