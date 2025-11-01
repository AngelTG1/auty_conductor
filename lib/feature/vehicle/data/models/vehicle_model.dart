import '../../domain/entities/vehicle_entity.dart';

class VehicleModel extends VehicleEntity {
  VehicleModel({
    required super.uuid,
    required super.driverUuid,
    required super.type,
    required super.brand,
    required super.colorName,
    required super.colorHex,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      uuid: json['uuid'],
      driverUuid: json['driverUuid'],
      type: json['type'],
      brand: json['brand'],
      colorName: json['color']['name'],
      colorHex: json['color']['hex'],
    );
  }
}
