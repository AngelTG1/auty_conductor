import '../../domain/entities/request_entity.dart';
import '../../domain/repositories/request_repository.dart';
import '../datasources/request_remote_datasource.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDataSource remote;

  RequestRepositoryImpl(this.remote);

  @override
  Future<RequestEntity> createRequest({
    required String driverUuid,
    required String mechanicUuid,
    required String description,
    required String address,
    required double lat,
    required double lng,
  }) {
    return remote.createRequest({
      'driverUuid': driverUuid,
      'mechanicUuid': mechanicUuid,
      'description': description,
      'address': address,
      'lat': lat,
      'lng': lng,
    });
  }

  @override
  Future<void> acceptRequest(String uuid) {
    return remote.acceptRequest(uuid);
  }
}
