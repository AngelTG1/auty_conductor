import 'dart:math' show sin, cos, sqrt, atan2, pi, min, max;
import 'package:auty_conductor/feature/location/presentation/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ws/ws_service.dart';

class DriverTrackingMechanicPage extends StatefulWidget {
  final Map<String, dynamic> request;

  const DriverTrackingMechanicPage({super.key, required this.request});

  @override
  State<DriverTrackingMechanicPage> createState() =>
      _DriverTrackingMechanicPageState();
}

class _DriverTrackingMechanicPageState
    extends State<DriverTrackingMechanicPage> {
  GoogleMapController? mapController;

  LatLng? driverPos;
  LatLng? mechanicPos;
  bool alertShown = false;

  Set<Marker> markers = {};
  late PolylinePoints polylinePoints;

  @override
  void initState() {
    super.initState();

    polylinePoints = PolylinePoints(apiKey: "TU_API_KEY");

    driverPos = LatLng(
      double.tryParse(widget.request["lat"].toString()) ?? 0.0,
      double.tryParse(widget.request["lng"].toString()) ?? 0.0,
    );

    _setupInitialMarkers();
    _listenMechanicUpdates();

    // ✅ CARGAR INFO REAL DEL MECÁNICO DESDE API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mechanicUuid = widget.request["mechanicUuid"];
      context.read<LocationProvider>().loadWorkshopInfo(mechanicUuid);
    });
  }

  // ───────────────── MARCADOR DRIVER
  void _setupInitialMarkers() {
    if (driverPos == null) return;

    markers = {
      Marker(
        markerId: const MarkerId("driver"),
        position: driverPos!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    };

    setState(() {});
  }

  // ───────────────── UBICACIÓN REAL VIA WS
  void _listenMechanicUpdates() {
    final ws = context.read<WsService>();

    ws.addListener(() {
      final msg = ws.lastMessage;
      if (msg == null) return;

      if (msg["type"].toString().contains("mechanic_location")) {
        final data = msg["data"];

        final newPos = LatLng(
          (data["lat"] as num).toDouble(),
          (data["lng"] as num).toDouble(),
        );

        mechanicPos = newPos;

        markers.removeWhere((m) => m.markerId.value == "mechanic");
        markers.add(
          Marker(
            markerId: const MarkerId("mechanic"),
            position: newPos,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange,
            ),
          ),
        );

        setState(() {});
        _fitCamera();
        _checkDistanceAlert();
      }
    });
  }

  // ───────────────── AJUSTE DE CÁMARA
  void _fitCamera() {
    if (driverPos == null || mechanicPos == null) return;

    final bounds = LatLngBounds(
      southwest: LatLng(
        min(driverPos!.latitude, mechanicPos!.latitude),
        min(driverPos!.longitude, mechanicPos!.longitude),
      ),
      northeast: LatLng(
        max(driverPos!.latitude, mechanicPos!.latitude),
        max(driverPos!.longitude, mechanicPos!.longitude),
      ),
    );

    mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  // ───────────────── ALERTA 50M
  void _checkDistanceAlert() {
    if (driverPos == null || mechanicPos == null) return;

    final dist = _distanceBetween(
      driverPos!.latitude,
      driverPos!.longitude,
      mechanicPos!.latitude,
      mechanicPos!.longitude,
    );

    if (dist <= 50 && !alertShown) {
      alertShown = true;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text("🔔 Mecánico muy cerca"),
          content: Text("Distancia: ${dist.toStringAsFixed(1)} m"),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  double _distanceBetween(lat1, lon1, lat2, lon2) {
    const R = 6371000;
    final dLat = (lat2 - lat1) * (pi / 180);
    final dLon = (lon2 - lon1) * (pi / 180);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180)) *
            cos(lat2 * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  // ───────────────── MODAL CON DATOS DEL PROVIDER
  void _showMechanicInfo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Consumer<LocationProvider>(
          builder: (_, provider, __) {
            final data = provider?.selectedWorkshop;

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  const Text(
                    "Datos del mecánico",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),

                  const SizedBox(height: 20),

                  CircleAvatar(
                    radius: 44,
                    backgroundImage: data?["photoUrl"] != null
                        ? NetworkImage(data!["photoUrl"])
                        : null,
                    child: data?["photoUrl"] == null
                        ? const Icon(Icons.person, size: 42)
                        : null,
                  ),

                  const SizedBox(height: 14),

                  _infoRow("Nombre", data?["name"]),
                  _infoRow("Teléfono", data?["phone"]),
                  _infoRow("Taller", data?["workshopName"]),
                  _infoRow("Rating", data?["rating"]?.toString()),
                  _infoRow(
                    "Ubicación",
                    mechanicPos != null
                        ? "${mechanicPos!.latitude.toStringAsFixed(6)}, ${mechanicPos!.longitude.toStringAsFixed(6)}"
                        : "Cargando...",
                  ),

                  const SizedBox(height: 26),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF235FE8),
                        padding:
                            const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        "Entendido",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          Text(value ?? "No disponible"),
        ],
      ),
    );
  }

  // ───────────────── UI PRINCIPAL
  @override
  Widget build(BuildContext context) {
    final chatUuid = widget.request["chatUuid"];
    final driverUuid = widget.request["driverUuid"];
    final mechanicUuid = widget.request["mechanicUuid"];

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: markers,
            initialCameraPosition: CameraPosition(
              target: driverPos ?? const LatLng(0, 0),
              zoom: 16,
            ),
            onMapCreated: (controller) => mapController = controller,
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 40,
            child: SafeArea(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showMechanicInfo,
                    child: _infoButton(),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      context.push(
                        "/chat",
                        extra: {
                          "chatUuid": chatUuid,
                          "driverUuid": driverUuid,
                          "mechanicUuid": mechanicUuid,
                        },
                      );
                    },
                    child: _chatButton(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 10),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Color(0xFF235FE8)),
          SizedBox(width: 10),
          Text(
            "Ver información del mecánico",
            style: TextStyle(
              color: Color(0xFF235FE8),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF235FE8), Color(0xFF1A46C8)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_rounded, color: Colors.white),
          SizedBox(width: 10),
          Text(
            "Chatear con el mecánico",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
