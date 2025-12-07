import 'package:flutter/material.dart';

import '../../data/datasources/comment_remote_datasource.dart';
import '../../data/repositories/comment_repository_impl.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/usecases/get_comments_usecase.dart';
import '../../domain/usecases/send_comment_usecase.dart';

class CommentProvider extends ChangeNotifier {
  final repo = CommentRepositoryImpl(CommentRemoteDataSource());

  late final SendCommentUseCase sendCommentUseCase =
      SendCommentUseCase(repo);

  late final GetCommentsUseCase getCommentsUseCase =
      GetCommentsUseCase(repo);

  List<CommentEntity> comments = [];
  bool loading = false;

  Future<void> loadComments(String mechanicUuid) async {
    loading = true;
    notifyListeners();

    comments = await getCommentsUseCase.call(mechanicUuid);

    loading = false;
    notifyListeners();
  }

  Future<void> sendComment(
    String texto,
    String driverUuid,
    String mechanicUuid,
  ) async {
    await sendCommentUseCase.call(texto, driverUuid, mechanicUuid);
    await loadComments(mechanicUuid);
  }
}
