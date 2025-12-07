import '../repositories/request_repository.dart';

class AcceptRequestUseCase {
  final RequestRepository repo;

  AcceptRequestUseCase(this.repo);

  Future<void> call(String uuid) {
    return repo.acceptRequest(uuid);
  }
}
