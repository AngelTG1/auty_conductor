import 'dart:convert';
import 'dart:math' show min, max;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:go_router/go_router.dart';

import 'package:auty_conductor/core/services/analytics_service.dart';
import 'package:auty_conductor/feature/location/domain/entities/location_entity.dart';

import '../../../../core/router/app_routes.dart';
import '../provider/location_provider.dart';
import '../provider/tracking_provider.dart';

// ✅ Widgets separados
import '../widget/top_info_bar.dart';
import '../widget/buscar_button.dart';
import '../widget/mechanic_list_sheet.dart';
import '../widget/map_skeleton.dart';
import '../widget/selected_mechanic_card.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  String? _currentAddress;
  bool _buscando = false;

  Map<String, dynamic>? _selectedMechanic;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  final String googleApiKey = "AIzaSyBXv1NijoLfRFR-oWDFVn_6nC1wKI4LQZQ";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    // 🔥 Iniciar tracking
    Future.microtask(() => context.read<TrackingProvider>().startTracking());
  }

  // ======================================================
  // 📍 UBICACIÓN ACTUAL
  // ======================================================

  Future<void> _getCurrentLocation() async {
    final status = await Permission.location.request();

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de ubicación denegado')),
      );
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.first;
      final direccion =
          "${place.street}, ${place.locality}, ${place.subAdministrativeArea}";

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _currentAddress = direccion;
      });

      // ⭐ Buscar mecánicos automáticamente
      await _buscarMecanicosCercanos();
    } catch (e) {
      debugPrint("❌ Error obteniendo ubicación: $e");
    }
  }

  // ======================================================
  // 🔍 BUSCAR MECÁNICOS
  // ======================================================

  Future<void> _buscarMecanicosCercanos() async {
    if (_currentPosition == null) return;

    final provider = context.read<LocationProvider>();
    setState(() => _buscando = true);

    await provider.fetchNearbyMechanics(
      userLat: _currentPosition!.latitude,
      userLng: _currentPosition!.longitude,
    );

    final mecanicos = provider.mechanics;

    setState(() {
      _buscando = false;

      _markers = {
        Marker(
          markerId: const MarkerId('mi_ubicacion'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(title: 'Tú estás aquí'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
        ...mecanicos.map(
          (m) => Marker(
            markerId: MarkerId(m.uuid),
            position: LatLng(m.lat, m.lng),
            infoWindow: InfoWindow(
              title: m.name,
              snippet: "${_formatDistance(m.distance!)} de distancia",
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        ),
      };
    });

    // ⭐ Zoom automático
    await _zoomToMarkers();

    await AnalyticsService.logBuscarMecanicos(encontrados: mecanicos.length);

    if (mecanicos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🚫 No hay mecánicos cercanos en un radio de 10 km."),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }

  // ======================================================
  // 🔎 ZOOM A MARCADORES
  // ======================================================

  Future<void> _zoomToMarkers() async {
    if (_markers.isEmpty || _mapController == null) return;

    final positions = _markers.map((m) => m.position).toList();

    double minLat = positions.map((p) => p.latitude).reduce(min);
    double maxLat = positions.map((p) => p.latitude).reduce(max);
    double minLng = positions.map((p) => p.longitude).reduce(min);
    double maxLng = positions.map((p) => p.longitude).reduce(max);

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 90),
      );
    } catch (_) {
      final center = LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: center, zoom: 14),
        ),
      );
    }
  }

  // ======================================================
  // 🗺 MOSTRAR RUTA
  // ======================================================

  Future<void> _mostrarRuta(LocationEntity mecanico) async {
    if (_currentPosition == null) return;

    final provider = context.read<LocationProvider>();

    final origin =
        "${_currentPosition!.latitude},${_currentPosition!.longitude}";
    final destination = "${mecanico.lat},${mecanico.lng}";

    try {
      final result = await provider.calculateDistance(origin, destination);
      final duration = result?['durationText'] ?? "";
      final distance = result?['distanceText'] ?? "";

      final directionsUrl =
          "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=driving&key=$googleApiKey";

      final response = await http.get(Uri.parse(directionsUrl));
      final data = jsonDecode(response.body);

      final points = data["routes"][0]["overview_polyline"]["points"];
      final decoded = PolylinePoints.decodePolyline(points);
      final polyCoords = decoded
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();

      setState(() {
        _selectedMechanic = {
          "uuid": mecanico.uuid,
          "name": mecanico.name,
          "lat": mecanico.lat,
          "lng": mecanico.lng,
          "distanceText": distance,
          "durationText": duration,
        };

        _polylines = {
          Polyline(
            polylineId: const PolylineId("ruta"),
            color: Colors.blue,
            width: 7,
            points: polyCoords,
          ),
        };

        _markers = {
          Marker(
            markerId: const MarkerId("yo"),
            position: _currentPosition!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
          Marker(
            markerId: MarkerId(mecanico.uuid),
            position: LatLng(mecanico.lat, mecanico.lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        };
      });

      await AnalyticsService.logSeleccionarMecanico(mecanico.name);
    } catch (e) {
      debugPrint("❌ Error mostrando ruta: $e");
    }
  }

  String _formatDistance(double km) {
    if (km < 1) return "${(km * 1000).round()} m";
    return "${km.toStringAsFixed(1)} km";
  }

  // ======================================================
  // UI
  // ======================================================

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocationProvider>();
    final mecanicos = provider.mechanics;
    final selected = _selectedMechanic;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: _currentPosition == null
                  ? const MapSkeleton()
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition!,
                        zoom: 15,
                      ),
                      markers: _markers,
                      polylines: _polylines,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      onMapCreated: (controller) => _mapController = controller,
                    ),
            ),

            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: TopInfoBar(
                address: _currentAddress,
                selectedName: _selectedMechanic?['name'],
              ),
            ),

            if (mecanicos.isEmpty && !_buscando && selected == null)
              BuscarButton(onPressed: _buscarMecanicosCercanos),

            if (_buscando) const Center(child: CircularProgressIndicator()),

            if (mecanicos.isNotEmpty && selected == null)
              MechanicListSheet(
                mecanicos: mecanicos,
                formatDistance: _formatDistance,
                onClose: () {
                  setState(() {
                    _selectedMechanic = null;
                    _polylines.clear();
                    _markers.clear();
                    context.read<LocationProvider>().mechanics.clear();
                  });

                  if (_currentPosition != null && _mapController != null) {
                    _mapController!.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(target: _currentPosition!, zoom: 15),
                      ),
                    );
                  }
                },
                onRoute: _mostrarRuta,
                onRequest: (m) {
                  context.push(
                    AppRoutes.expressMechanic,
                    extra: {
                      'mechanicUuid': m.uuid,
                      'mechanicName': m.name,
                      'mechanicLat': m.lat,
                      'mechanicLng': m.lng,
                      'userLat': _currentPosition!.latitude,
                      'userLng': _currentPosition!.longitude,
                      'userAddress': _currentAddress,
                    },
                  );
                },
              ),

            if (selected != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SelectedMechanicCard(
                  mechanic: selected,
                  onBack: _buscarMecanicosCercanos,
                  onCancel: () {
                    setState(() {
                      _selectedMechanic = null;
                      _polylines.clear();
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
