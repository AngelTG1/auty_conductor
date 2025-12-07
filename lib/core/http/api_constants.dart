class ApiConstants {
  // API Gateway (puerto 3000)
  static const String baseUrl = 'https://auty-microservices-production.up.railway.app';

  static const String auth = '$baseUrl/API/v1/u/auth';
  static const String users = '$baseUrl/API/v1/u/users';
  static const String drivers = '$baseUrl/API/v1/u/drivers';
  static const String vehicles = '$baseUrl/API/v1/u/vehicles';

  static const String location = '$baseUrl/API/v1/l/location';
  static const String requestService = '$baseUrl/API/v1/r/requests';
  static const String comments = '$baseUrl/API/v1/c';

  // DIRECTO AL USER SERVICE (donde están las imágenes)
  static const String userServiceBase =
      'https://fortunate-balance-production-8ac4.up.railway.app';
  static const String imagesBase = '$userServiceBase/uploads/profile';
}
