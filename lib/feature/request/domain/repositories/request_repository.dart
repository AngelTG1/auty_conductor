import '../entities/request_entity.dart';

abstract class RequestRepository {
  Future<RequestEntity> createRequest({
    required String driverUuid,
    required String mechanicUuid,
    required String description,
    required String address,
    required double lat,
    required double lng,
  });

  Future<void> acceptRequest(String uuid);
}
