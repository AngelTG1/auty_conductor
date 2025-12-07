import 'package:dio/dio.dart';
import 'package:auty_conductor/core/http/api_constants.dart';
import '../../domain/entities/location_entity.dart';
import '../models/location_model.dart';

class LocationRemoteDataSource {
  final Dio _dio = Dio();

  /// 🔹 Obtener todos los mecánicos
  Future<List<LocationEntity>> getAllMechanics() async {
    final response = await _dio.get('${ApiConstants.location}/mechanics/all');
    final data = response.data as Map<String, dynamic>;

    return data.entries.map((entry) {
      return LocationModel.fromJson(entry.key, entry.value);
    }).toList();
  }

  /// 🔹 Calcular distancia entre origen y destino
  Future<Map<String, dynamic>> calculateDistance(
    String origin,
    String destination,
  ) async {
    final response = await _dio.get(
      '${ApiConstants.location}/distance/calc',
      queryParameters: {'origin': origin, 'destination': destination},
    );
    return response.data as Map<String, dynamic>;
  }

  /// 🔹 Obtener información completa de un mecánico
  Future<Map<String, dynamic>> getWorkshopById(String mechanicUuid) async {
    final response = await _dio.get(
      '${ApiConstants.location}/workshops/$mechanicUuid',
    );
    return response.data as Map<String, dynamic>;
  }
}
