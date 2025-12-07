import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class GetMessagesUseCase {
  final ChatRepository repo;

  GetMessagesUseCase(this.repo);

  Future<List<ChatMessageEntity>> call(String chatUuid) {
    return repo.getMessages(chatUuid);
  }
}
