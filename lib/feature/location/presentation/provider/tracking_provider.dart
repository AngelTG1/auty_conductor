import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import '../../../../core/http/api_constants.dart';
import '../../../../core/services/secure_storage_service.dart';

class TrackingProvider extends ChangeNotifier {
  Position? _currentPosition;
  bool _isTracking = false;
  Timer? _timer;
  Map<String, dynamic> _drivers = {};

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('drivers');

  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;
  Map<String, dynamic> get drivers => _drivers;

  /// 🔹 Escucha ubicaciones de otros conductores
  void listenToDrivers() {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        _drivers = Map<String, dynamic>.from(data);
        notifyListeners();
      }
    });
  }

  /// 🔹 Inicia el rastreo del usuario
  Future<void> startTracking() async {
    final hasPermission = await _handlePermissions();
    if (!hasPermission) return;

    _isTracking = true;
    listenToDrivers();
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _updateLocation();
    });
  }

  void stopTracking() {
    _isTracking = false;
    _timer?.cancel();
    notifyListeners();
  }

  Future<bool> _handlePermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  /// 🔹 Envía la ubicación actual al backend + Firebase
  Future<void> _updateLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final driverUuid = await SecureStorageService.read('driverUuid');
      if (driverUuid == null || driverUuid.isEmpty) return;

      final url = Uri.parse('${ApiConstants.location}/save');
      await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'driverUuid': driverUuid,
          'latitude': _currentPosition!.latitude,
          'longitude': _currentPosition!.longitude,
        }),
      );

      await _dbRef.child(driverUuid).set({
        'latitude': _currentPosition!.latitude,
        'longitude': _currentPosition!.longitude,
      });

      debugPrint('📍 Ubicación actualizada y sincronizada.');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error actualizando ubicación: $e');
    }
  }
}
