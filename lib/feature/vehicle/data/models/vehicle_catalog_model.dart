import '../../domain/entities/vehicle_catalog_entity.dart';

class VehicleTypeModel extends VehicleTypeEntity {
  VehicleTypeModel(int id, String name, String imageUrl)
      : super(id, name, imageUrl);

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) =>
      VehicleTypeModel(
        json['id'] ?? 0,
        json['name'] ?? '',
        json['imageUrl'] ?? '', 
      );
}

class VehicleBrandModel extends VehicleBrandEntity {
  VehicleBrandModel(int id, String name) : super(id, name);

  factory VehicleBrandModel.fromJson(Map<String, dynamic> json) =>
      VehicleBrandModel(
        json['id'] ?? 0,
        json['name'] ?? '',
      );
}

class VehicleColorModel extends VehicleColorEntity {
  VehicleColorModel(int id, String name, String hex)
      : super(id, name, hex);

  factory VehicleColorModel.fromJson(Map<String, dynamic> json) =>
      VehicleColorModel(
        json['id'] ?? 0,
        json['name'] ?? '',
        json['hexCode'] ?? '', // 👈 tu API usa camelCase aquí también
      );
}
