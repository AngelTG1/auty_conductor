// lib/core/http/api_constants.dart
class ApiConstants {
  // 🌐 Base URLs
  static const String baseUrl = 'http://192.168.0.16:3003';  // Gateway principal
  static const String baseUrlV2 = 'http://192.168.0.16:3002'; // Microservicio ubicación

  // 🔹 Endpoints principales (Gateway)
  static const String auth = '$baseUrl/api/v1/auth';
  static const String users = '$baseUrl/api/v1/users';
  static const String drivers = '$baseUrl/api/v1/drivers';
  static const String vehicles = '$baseUrl/api/v1/vehicles';

  // 🌍 Microservicio de ubicación
  static const String location = '$baseUrlV2/api/v1/location';
}
