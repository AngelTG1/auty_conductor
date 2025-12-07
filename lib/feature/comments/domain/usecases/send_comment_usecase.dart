import '../repositories/comment_repository.dart';

class SendCommentUseCase {
  final CommentRepository repo;
  SendCommentUseCase(this.repo);

  Future<void> call(String texto, String driverUuid, String mechanicUuid) {
    return repo.sendComment(texto, driverUuid, mechanicUuid);
  }
}
