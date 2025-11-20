import 'dart:convert';
import 'dart:math' show min, max;
import 'package:auty_conductor/core/services/analytics_service.dart';
import 'package:auty_conductor/feature/location/domain/entities/location_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../provider/location_provider.dart';
import '../provider/tracking_provider.dart';
import '../widget/mechanic_card.dart';
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
    Future.microtask(() => context.read<TrackingProvider>().startTracking());
  }

  /// 📍 Obtener ubicación actual
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
    } catch (e) {
      debugPrint("❌ Error obteniendo ubicación: $e");
    }
  }

  /// 🔍 Buscar mecánicos cercanos
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
              snippet: '${_formatDistance(m.distance!)} de distancia',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        ),
      };
    });

    await AnalyticsService.logBuscarMecanicos(encontrados: mecanicos.length);

    if (mecanicos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🚫 No hay mecánicos cercanos en un radio de 10 km.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }

  /// 🗺️ Mostrar ruta
  Future<void> _mostrarRuta(LocationEntity mecanico) async {
    if (_currentPosition == null) return;

    final provider = context.read<LocationProvider>();
    final origin =
        "${_currentPosition!.latitude},${_currentPosition!.longitude}";
    final destination = "${mecanico.lat},${mecanico.lng}";

    try {
      final result = await provider.calculateDistance(origin, destination);
      final duration = result?['durationText'] ?? '';
      final distance = result?['distanceText'] ?? '';

      final directionsUrl =
          "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=driving&key=$googleApiKey";

      final directionsResponse = await http.get(Uri.parse(directionsUrl));
      final data = jsonDecode(directionsResponse.body);

      if (data["routes"].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró una ruta.')),
        );
        return;
      }

      final points = data["routes"][0]["overview_polyline"]["points"];
      final decodedPoints = PolylinePoints.decodePolyline(points);
      final polylineCoords = decodedPoints
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();

      setState(() {
        _selectedMechanic = {
          'uuid': mecanico.uuid,
          'name': mecanico.name,
          'lat': mecanico.lat,
          'lng': mecanico.lng,
          'distanceText': distance,
          'durationText': duration,
        };

        _polylines = {
          Polyline(
            polylineId: const PolylineId('ruta'),
            color: Colors.blue,
            width: 10,
            points: polylineCoords,
          ),
        };

        _markers = {
          Marker(
            markerId: const MarkerId('mi_ubicacion'),
            position: _currentPosition!,
            infoWindow: const InfoWindow(title: 'Tú estás aquí'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
          Marker(
            markerId: MarkerId(mecanico.uuid),
            position: LatLng(mecanico.lat, mecanico.lng),
            infoWindow: InfoWindow(title: mecanico.name),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        };
      });

      await AnalyticsService.logSeleccionarMecanico(mecanico.name);

      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
              min(_currentPosition!.latitude, mecanico.lat),
              min(_currentPosition!.longitude, mecanico.lng),
            ),
            northeast: LatLng(
              max(_currentPosition!.latitude, mecanico.lat),
              max(_currentPosition!.longitude, mecanico.lng),
            ),
          ),
          80,
        ),
      );
    } catch (e) {
      debugPrint('❌ Error mostrando ruta: $e');
    }
  }

  String _formatDistance(double km) {
    if (km < 1) return '${(km * 1000).round()} m';
    return '${km.toStringAsFixed(1)} km';
  }

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
                  ? _buildMapSkeleton()
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

            Positioned(top: 20, left: 20, right: 20, child: _buildTopInfo()),

            if (mecanicos.isEmpty && !_buscando && selected == null)
              _buildBuscarButton(),

            if (_buscando) const Center(child: CircularProgressIndicator()),

            if (mecanicos.isNotEmpty && selected == null)
              _buildMechanicList(mecanicos),

            if (selected != null) _buildSelectedMechanicCard(selected),
          ],
        ),
      ),
    );
  }

  /// 🔵 Caja superior
  Widget _buildTopInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            setState(() {
              _selectedMechanic = null;
              _markers.clear();
              _polylines.clear();
              context.read<LocationProvider>().mechanics.clear();
            });
            context.pop();

            if (_currentPosition != null && _mapController != null) {
              await _mapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: _currentPosition!, zoom: 15),
                ),
              );
            }
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.close, color: Colors.black87),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentAddress ?? "Obteniendo dirección...",
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedMechanic?['name'] ?? "Sin mecánico seleccionado",
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBuscarButton() {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: _buscarMecanicosCercanos,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF235EE8),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Buscar mecánicos cercanos',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildMechanicList(List<LocationEntity> mecanicos) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 298,
        padding: const EdgeInsets.only(top: 4, left: 10, right: 10, bottom: 10),
        decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Mecánicos localizados:",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${mecanicos.length}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _selectedMechanic = null;
                        _polylines.clear();
                        _markers.clear();
                        _buscando = false;
                        context.read<LocationProvider>().mechanics.clear();
                      });

                      if (_currentPosition != null && _mapController != null) {
                        await _mapController!.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(target: _currentPosition!, zoom: 15),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(
                        side: BorderSide(color: Colors.grey, width: 1.2),
                      ),
                      padding: const EdgeInsets.all(8),
                      elevation: 2,
                    ),
                    child: const Icon(
                      Icons.close_sharp,
                      size: 20,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: mecanicos.length,
                itemBuilder: (context, i) {
                  final m = mecanicos[i];
                  return MechanicCard(
                    mechanic: {
                      'uuid': m.uuid,
                      'lat': m.lat,
                      'lng': m.lng,
                      'name': m.name,
                      'distance': m.distance,
                      'address': m.address,
                    },
                    distanceText: _formatDistance(m.distance!),
                    onRoutePressed: () => _mostrarRuta(m),

                    onRequestPressed: () {
                      if (_currentPosition == null) return;

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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedMechanicCard(Map<String, dynamic> selected) {
    return Positioned(
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
    );
  }

  /// Skeleton de carga
  Widget _buildMapSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        color: Colors.grey.shade200,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.white)),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                width: 200,
                height: 20,
                color: Colors.white,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 40),
                width: 260,
                height: 50,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
