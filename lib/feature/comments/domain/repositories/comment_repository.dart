import 'package:auty_conductor/feature/comments/domain/entities/comment_entity.dart';

abstract class CommentRepository {
  Future<void> sendComment(
    String texto,
    String driverUuid,
    String mechanicUuid,
  );

  Future<List<CommentEntity>> getComments(String mechanicUuid);
}
