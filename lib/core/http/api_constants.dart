class ApiConstants {
  // 🌐 Base URLs
  static const String baseUrl = 'http://192.168.0.21:3000';

  static const String auth = '$baseUrl/API/v1/u/auth';
  static const String users = '$baseUrl/API/v1/u/users';
  static const String drivers = '$baseUrl/API/v1/u/drivers';
  static const String vehicles = '$baseUrl/API/v1/u/vehicles';
  static const String location = '$baseUrl/API/v1/l/location';

  // ✔ request-service (vía gateway)
  static const String requestService = '$baseUrl/API/v1/r/requests';
}
