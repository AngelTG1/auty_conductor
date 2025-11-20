import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class GetAllMechanicsUseCase {
  final LocationRepository repository;

  GetAllMechanicsUseCase(this.repository);

  Future<List<LocationEntity>> call() {
    return repository.getAllMechanics();
  }
}

class GetWorkshopByIdUseCase {
  final LocationRepository repository;
  GetWorkshopByIdUseCase(this.repository);

  Future<Map<String, dynamic>> call(String mechanicUuid) {
    return repository.getWorkshopById(mechanicUuid);
  }
}

class CalculateDistanceUseCase {
  final LocationRepository repository;

  CalculateDistanceUseCase(this.repository);

  Future<Map<String, dynamic>> call(String origin, String destination) {
    return repository.calculateDistance(origin, destination);
  }
}
