// lib/feature/auth/data/models/auth_model.dart
import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel({
    required super.uuid,
    required super.driverUuid,
    required super.name,
    required super.email,
    required super.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      uuid: json['uuid'] ?? '',
      driverUuid: json['driverUuid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
