import '../../domain/entities/vehicle_entity.dart';

class VehicleModel extends VehicleEntity {
  VehicleModel({
    required super.uuid,
    required super.driverUuid,
    required super.type,
    required super.brand,
    required super.colorName,
    required super.colorHex,
    required super.imageUrl,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    // Puede que "color" venga como objeto o como propiedades planas
    final color = json['color'];

    return VehicleModel(
      uuid: (json['uuid'] ?? '').toString(),
      driverUuid: (json['driverUuid'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      brand: (json['brand'] ?? '').toString(),
      colorName: color is Map
          ? (color['name'] ?? '').toString()
          : (json['colorName'] ?? '').toString(),
      colorHex: color is Map
          ? (color['hex'] ?? '').toString()
          : (json['colorHex'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? '').toString(),
    );
  }
}
