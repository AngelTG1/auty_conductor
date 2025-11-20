import '../../domain/entities/request_entity.dart';

class RequestModel extends RequestEntity {
  RequestModel({
    required super.uuid,
    required super.driverUuid,
    required super.mechanicUuid,
    required super.description,
    required super.address,
    required super.lat,
    required super.lng,
    required super.vehicle,
    required super.status,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      uuid: json['uuid'],
      driverUuid: json['driverUuid'],
      mechanicUuid: json['mechanicUuid'],
      description: json['description'],
      address: json['address'],
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      vehicle: json['vehicle'] ?? json['vehicle_json'] ?? {},
      status: json['status'],
    );
  }
}
