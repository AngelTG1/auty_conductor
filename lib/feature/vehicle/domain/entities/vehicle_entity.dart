class VehicleEntity {
  final String uuid;
  final String driverUuid;
  final String type;
  final String brand;
  final String colorName;
  final String colorHex;

  VehicleEntity({
    required this.uuid,
    required this.driverUuid,
    required this.type,
    required this.brand,
    required this.colorName,
    required this.colorHex,
  });
}
