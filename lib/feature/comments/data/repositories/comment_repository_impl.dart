import '../../domain/entities/comment_entity.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/comment_remote_datasource.dart';
import '../models/comment_model.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remote;

  CommentRepositoryImpl(this.remote);

  @override
  Future<void> sendComment(
    String texto,
    String driverUuid,
    String mechanicUuid,
  ) {
    return remote.sendComment(
      texto: texto,
      driverUuid: driverUuid,
      mechanicUuid: mechanicUuid,
    );
  }

  @override
  Future<List<CommentEntity>> getComments(String mechanicUuid) async {
    final result = await remote.getComments(mechanicUuid);

    return result
        .map(
          (c) => CommentEntity(
            id: c.id,
            driverUuid: c.driverUuid,
            driverName: c.driverName,
            driverPhoto: c.driverPhoto,
            mechanicUuid: c.mechanicUuid,
            texto: c.texto,
            sentimiento: c.sentimiento,
            puntuacion: c.puntuacion,
            toxicidad: c.toxicidad,
          ),
        )
        .toList();
  }
}
