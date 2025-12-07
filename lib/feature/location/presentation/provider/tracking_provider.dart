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

  /// 🔹 Escuchar ubicación de otros drivers desde Firebase
  void listenToDrivers() {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data != null && data is Map) {
        _drivers = Map<String, dynamic>.from(data);
        notifyListeners();
      }
    });
  }

  /// 🔵 Iniciar tracking cada 5 segundos
  Future<void> startTracking() async {
    final hasPermission = await _handlePermissions();
    if (!hasPermission) return;

    _isTracking = true;
    notifyListeners();

    listenToDrivers();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _updateLocation();
    });
  }

  void stopTracking() {
    _isTracking = false;
    _timer?.cancel();
    notifyListeners();
  }

  /// 🔐 Permisos
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

  /// 🟢 ENVÍA UBICACIÓN A GATEWAY + Firebase
  Future<void> _updateLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final driverUuid = await SecureStorageService.read("driverUuid");

      if (driverUuid == null || driverUuid.isEmpty) return;

      // ⛳ URL CORRECTA (via GATEWAY)
      final url = Uri.parse(ApiConstants.location);

      final token = await SecureStorageService.read("token");

      await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "driverUuid": driverUuid,
          "latitude": _currentPosition!.latitude,
          "longitude": _currentPosition!.longitude,
        }),
      );

      // 🔵 Guardar también en Firebase (opcional)
      await _dbRef.child(driverUuid).set({
        "lat": _currentPosition!.latitude,
        "lng": _currentPosition!.longitude,
        "timestamp": DateTime.now().toIso8601String(),
      });

      debugPrint("📍 Ubicación enviada correctamente.");
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error enviando ubicación: $e");
    }
  }
}
