// lib/feature/auth/domain/entities/auth_entity.dart
class AuthEntity {
  final String uuid;
  final String driverUuid;
  final String licenseNumber; 
  final String name;
  final String email;
  final String phone;
  final String token;

  AuthEntity({
    required this.uuid,
    required this.driverUuid,
    required this.licenseNumber,
    required this.name,
    required this.email,
    required this.phone,
    required this.token,
  });
}
