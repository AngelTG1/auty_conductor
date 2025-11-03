import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel({
    required super.uuid,
    required super.driverUuid,
    required super.licenseNumber, 
    required super.name,
    required super.email,
    required super.phone,
    required super.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      uuid: json['uuid'] ?? '',
      driverUuid: json['driverUuid'] ?? json['driver_uuid'] ?? json['driverID'] ?? '',
      licenseNumber: json['licenseNumber'] ?? json['license_number'] ?? '', 
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      token: json['token'] ?? '',
    );
  }
}

