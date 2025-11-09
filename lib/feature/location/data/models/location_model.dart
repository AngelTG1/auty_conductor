import '../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.uuid,
    required super.name,
    required super.lat,
    required super.lng,
    super.distance,
    super.address,
  });

  factory LocationModel.fromJson(String uuid, Map<String, dynamic> json) {
    return LocationModel(
      uuid: uuid,
      name: json['workshopName'] ?? 'Mecánico $uuid',
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      address: json['address'] ?? 'Ubicación en tiempo real',
    );
  }
}
