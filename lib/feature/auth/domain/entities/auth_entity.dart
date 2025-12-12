class AuthEntity {
  final String uuid;
  final String driverUuid;
  final String licenseNumber;
  final String name;
  final String email;
  final String phone;
  final String token;
  final String profileImage;

  AuthEntity({
    required this.uuid,
    required this.driverUuid,
    required this.licenseNumber,
    required this.name,
    required this.email,
    required this.phone,
    required this.token,
    required this.profileImage, 
  });
}
