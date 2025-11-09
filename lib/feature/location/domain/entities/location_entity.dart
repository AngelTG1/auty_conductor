class LocationEntity {
  final String uuid;
  final String name;
  final double lat;
  final double lng;
  final double? distance;
  final String? address;

  const LocationEntity({
    required this.uuid,
    required this.name,
    required this.lat,
    required this.lng,
    this.distance,
    this.address,
  });
}
