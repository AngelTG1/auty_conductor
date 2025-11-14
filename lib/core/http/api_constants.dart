// lib/core/http/api_constants.dart
class ApiConstants {
  // 🌐 Base URLs
  static const String baseUrl = 'https://auty-microservices-production.up.railway.app';
  // static const String baseUrlV2 =
  //     'https://location-server-production-8876.up.railway.app';

  // Endpoints principales (Gateway)
  static const String auth = '$baseUrl/API/v1/u/auth';
  static const String users = '$baseUrl/API/v1/u/users';
  static const String drivers = '$baseUrl/API/v1/u/drivers';
  static const String vehicles = '$baseUrl/API/v1/u/vehicles';

  // Microservicio de ubicación
  static const String location = '$baseUrl/API/v1/l/location';
}
