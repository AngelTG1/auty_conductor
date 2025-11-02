class VehicleEntity {
  final String uuid;
  final String driverUuid;
  final String type;
  final String brand;
  final String colorName;
  final String colorHex;
  final String imageUrl; // 🔹 imagen del tipo de vehículo

  VehicleEntity({
    required this.uuid,
    required this.driverUuid,
    required this.type,
    required this.brand,
    required this.colorName,
    required this.colorHex,
    required this.imageUrl,
  });

  factory VehicleEntity.fromJson(Map<String, dynamic> json) {
    return VehicleEntity(
      uuid: json['uuid'] ?? '',
      driverUuid: json['driverUuid'] ?? '',
      type: json['type'] ?? '',
      brand: json['brand'] ?? '',
      colorName: json['colorName'] ?? '',
      colorHex: json['colorHex'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
