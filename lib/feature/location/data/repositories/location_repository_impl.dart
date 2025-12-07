import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_remote_datasource.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;

  LocationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<LocationEntity>> getAllMechanics() {
    return remoteDataSource.getAllMechanics();
  }

  @override
  Future<Map<String, dynamic>> calculateDistance(
    String origin,
    String destination,
  ) {
    return remoteDataSource.calculateDistance(origin, destination);
  }

  @override
  Future<Map<String, dynamic>> getWorkshopById(String mechanicUuid) {
    return remoteDataSource.getWorkshopById(mechanicUuid);
  }
}
