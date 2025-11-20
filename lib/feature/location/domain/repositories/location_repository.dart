import '../entities/location_entity.dart';

abstract class LocationRepository {
  Future<List<LocationEntity>> getAllMechanics();
  Future<Map<String, dynamic>> calculateDistance(String origin, String destination);
  Future<Map<String, dynamic>> getWorkshopById(String mechanicUuid);
}
