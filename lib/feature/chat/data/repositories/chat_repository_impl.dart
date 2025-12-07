import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;

  ChatRepositoryImpl(this.remote);

  @override
  Future<ChatMessageEntity> sendMessage(Map<String, dynamic> body) {
    return remote.sendMessage(body);
  }

  @override
  Future<List<ChatMessageEntity>> getMessages(String chatUuid) {
    return remote.getMessages(chatUuid);
  }
}
