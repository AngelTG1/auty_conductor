class RequestEntity {
  final String uuid;
  final String driverUuid;
  final String mechanicUuid;
  final String description;
  final String address;
  final double lat;
  final double lng;
  final dynamic vehicle;
  final String status;

  RequestEntity({
    required this.uuid,
    required this.driverUuid,
    required this.mechanicUuid,
    required this.description,
    required this.address,
    required this.lat,
    required this.lng,
    required this.vehicle,
    required this.status,
  });
}
