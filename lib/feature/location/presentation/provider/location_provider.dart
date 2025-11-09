import 'dart:math' show cos, sqrt, asin, sin, atan2, pi;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/http/api_constants.dart';
import '../../domain/entities/location_entity.dart';

class LocationProvider extends ChangeNotifier {
  final Dio _dio = Dio();

  // URLs centralizadas
  final String mechanicsUrl = '${ApiConstants.location}/mechanics/all';
  final String distanceUrl = '${ApiConstants.location}/distance/calc';

  List<LocationEntity> _mechanics = [];
  bool _loading = false;

  List<LocationEntity> get mechanics => _mechanics;
  bool get loading => _loading;

  Future<void> fetchNearbyMechanics({
    required double userLat,
    required double userLng,
    double maxDistanceKm = 10,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await _dio.get(mechanicsUrl);
      final data = response.data as Map<String, dynamic>;
      final List<LocationEntity> nearby = [];

      data.forEach((uuid, value) {
        final lat = (value['lat'] as num?)?.toDouble();
        final lng = (value['lng'] as num?)?.toDouble();
        if (lat == null || lng == null) return;

        final distance = _calculateDistance(userLat, userLng, lat, lng);

        if (distance <= maxDistanceKm) {
          nearby.add(
            LocationEntity(
              uuid: uuid,
              name: value['workshopName'] ?? 'Mecánico $uuid',
              lat: lat,
              lng: lng,
              distance: distance,
              address: value['address'] ?? 'Ubicación en tiempo real',
            ),
          );
        }
      });

      nearby.sort((a, b) => a.distance!.compareTo(b.distance!));
      _mechanics = nearby;
    } catch (e) {
      debugPrint("❌ Error cargando talleres: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// 🔹 Calcular ruta/duración usando backend
  Future<Map<String, dynamic>?> calculateDistance(
    String origin,
    String destination,
  ) async {
    try {
      final response = await _dio.get(
        distanceUrl,
        queryParameters: {'origin': origin, 'destination': destination},
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Error calculando distancia: $e');
      return null;
    }
  }

  /// 📏 Calcular distancia localmente (en km)
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double r = 6371; // radio de la tierra en km
    final dLat = (lat2 - lat1) * (pi / 180);
    final dLon = (lon2 - lon1) * (pi / 180);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180)) *
            cos(lat2 * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }
}
