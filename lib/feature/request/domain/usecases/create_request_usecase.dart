import '../entities/request_entity.dart';
import '../repositories/request_repository.dart';

class CreateRequestUseCase {
  final RequestRepository repo;

  CreateRequestUseCase(this.repo);

  Future<RequestEntity> call({
    required String driverUuid,
    required String mechanicUuid,
    required String description,
    required String address,
    required double lat,
    required double lng,
  }) {
    return repo.createRequest(
      driverUuid: driverUuid,
      mechanicUuid: mechanicUuid,
      description: description,
      address: address,
      lat: lat,
      lng: lng,
    );
  }
}
