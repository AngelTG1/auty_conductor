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
    required super.profileImage,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    String extract(dynamic v) {
      if (v == null) return "";
      if (v is String) return v;
      if (v is Map && v.containsKey('value')) return v["value"].toString();
      return v.toString();
    }

    return AuthModel(
      uuid: extract(json['uuid']),
      driverUuid: extract(json['driverUuid']),
      licenseNumber: extract(json['licenseNumber']),
      name: extract(json['name']),
      email: extract(json['email']),
      phone: extract(json['phone']),
      token: extract(json['token']),

      // 🔥 Corrección: toma imageUrl o user.profileImage
      profileImage: extract(
        json['imageUrl'] ??
            json['profileImage'] ??
            json['user']?['profileImage'] ??
            "",
      ),
    );
  }
}
