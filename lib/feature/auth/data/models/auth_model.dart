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
    // Función para extraer strings desde:
    // - "texto"
    // - { "value": "texto" }
    // - cualquier otro tipo
    String extract(dynamic v) {
      if (v == null) return "";
      if (v is String) return v;
      if (v is Map && v.containsKey('value')) return v["value"].toString();
      return v.toString();
    }

    final user = json['user'] ?? {};
    final driver = json['driver'] ?? {};

    return AuthModel(
      uuid: extract(json['uuid'] ?? user['uuid']),
      driverUuid: extract(
        json['driverUuid'] ?? json['driver_uuid'] ?? driver['uuid'],
      ),
      licenseNumber: extract(
        json['licenseNumber'] ??
            json['license_number'] ??
            driver['licenseNumber'],
      ),
      name: extract(json['name'] ?? user['name']),
      email: extract(json['email'] ?? user['email']),
      phone: extract(json['phone'] ?? user['phone']),
      token: extract(json['token']),
    );
  }
}
