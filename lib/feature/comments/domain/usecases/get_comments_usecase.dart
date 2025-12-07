import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class GetCommentsUseCase {
  final CommentRepository repo;
  GetCommentsUseCase(this.repo);

  Future<List<CommentEntity>> call(String mechanicUuid) {
    return repo.getComments(mechanicUuid);
  }
}
