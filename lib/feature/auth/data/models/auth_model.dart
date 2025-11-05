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
    // 🔹 Detección flexible: busca datos tanto planos como anidados
    final user = json['user'] ?? {};
    final driver = json['driver'] ?? {};

    return AuthModel(
      uuid: json['uuid'] ?? user['uuid'] ?? '',
      driverUuid:
          json['driverUuid'] ?? json['driver_uuid'] ?? driver['uuid'] ?? '',
      licenseNumber:
          json['licenseNumber'] ??
          json['license_number'] ??
          driver['licenseNumber'] ??
          '',
      name: json['name'] ?? user['name'] ?? '',
      email: json['email'] ?? user['email'] ?? '',
      phone: json['phone'] ?? user['phone'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
