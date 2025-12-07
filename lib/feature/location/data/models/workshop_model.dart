class WorkshopModel {
  final String mechanicUuid;
  final String workshopName;
  final double lat;
  final double lng;
  final String timestamp;
  final MechanicInfo mechanic;
  final UserInfo user;

  WorkshopModel({
    required this.mechanicUuid,
    required this.workshopName,
    required this.lat,
    required this.lng,
    required this.timestamp,
    required this.mechanic,
    required this.user,
  });

  factory WorkshopModel.fromJson(Map<String, dynamic> json) {
    return WorkshopModel(
      mechanicUuid: json['mechanicUuid'] ?? '',
      workshopName: json['workshopName'] ?? '',
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      timestamp: json['timestamp'] ?? '',
      mechanic: MechanicInfo.fromJson(json['mechanic'] ?? {}),
      user: UserInfo.fromJson(json['user'] ?? {}),
    );
  }
}

class MechanicInfo {
  final String certificateNumber;

  MechanicInfo({required this.certificateNumber});

  factory MechanicInfo.fromJson(Map<String, dynamic> json) {
    return MechanicInfo(
      certificateNumber: json['certificateNumber'] ?? '',
    );
  }
}

class UserInfo {
  final String name;
  final String phone;
  final String email;

  UserInfo({
    required this.name,
    required this.phone,
    required this.email,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
