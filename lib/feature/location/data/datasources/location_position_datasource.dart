import 'package:dio/dio.dart';
import '../../../../core/http/api_constants.dart';

class LocationPositionDataSource {
  final Dio _dio = Dio();

  /// Obtiene la ubicación REAL del mecánico desde Firebase vía Location-service
  Future<Map<String, dynamic>> getMechanicLocation(String mechanicUuid) async {
    final url = '${ApiConstants.location}/$mechanicUuid';

    try {
      final response = await _dio.get(url);
      return response.data;
    } catch (e) {
      throw Exception("Error obteniendo ubicación del mecánico");
    }
  }
}
