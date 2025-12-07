import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repo;

  SendMessageUseCase(this.repo);

  Future<ChatMessageEntity> call(Map<String, dynamic> data) {
    return repo.sendMessage(data);
  }
}
