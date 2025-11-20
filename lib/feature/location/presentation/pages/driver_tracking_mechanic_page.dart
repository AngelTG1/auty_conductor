import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
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

  Set<Circle> circles = {};
  List<LatLng> polylineCoords = [];

  late PolylinePoints polylinePoints;

  @override
  void initState() {
    super.initState();

    polylinePoints = PolylinePoints(
      apiKey: "AIzaSyBXv1NijoLfRFR-oWDFVn_6nC1wKI4LQZQ",
    );

    final dLat = double.tryParse(widget.request["lat"].toString()) ?? 0.0;
    final dLng = double.tryParse(widget.request["lng"].toString()) ?? 0.0;

    final mLat =
        double.tryParse(widget.request["mechanicLat"]?.toString() ?? "0") ??
        0.0;
    final mLng =
        double.tryParse(widget.request["mechanicLng"]?.toString() ?? "0") ??
        0.0;

    driverPos = LatLng(dLat, dLng);
    mechanicPos = LatLng(mLat, mLng);

    circles = {
      // 🔵 CONDUCTOR
      Circle(
        circleId: const CircleId("driver"),
        center: driverPos!,
        radius: 20,
        fillColor: Colors.blue.withOpacity(0.9),
        strokeColor: Colors.white,
        strokeWidth: 3,
      ),

      // 🟠 MECÁNICO
      Circle(
        circleId: const CircleId("mechanic"),
        center: mechanicPos!,
        radius: 26,
        fillColor: Colors.deepOrange.withOpacity(0.9),
        strokeColor: Colors.black,
        strokeWidth: 3,
      ),
    };

    _listenToMechanicUpdates();
    _createRoute();
  }

  // ======================================================
  // 🔥 ACTUALIZACIÓN EN TIEMPO REAL DEL MECÁNICO
  // ======================================================
  void _listenToMechanicUpdates() {
    final ws = context.read<WsService>();

    ws.addListener(() {
      final msg = ws.lastMessage;
      if (msg == null) return;

      if (msg["type"] == "mechanic_location_update") {
        final lat = msg["data"]["lat"];
        final lng = msg["data"]["lng"];

        setState(() {
          mechanicPos = LatLng(lat, lng);
          circles.removeWhere((c) => c.circleId.value == "mechanic");

          circles.add(
            Circle(
              circleId: const CircleId("mechanic"),
              center: mechanicPos!,
              radius: 26,
              fillColor: Colors.deepOrange.withOpacity(0.9),
              strokeColor: Colors.black,
              strokeWidth: 3,
            ),
          );

          mapController?.animateCamera(CameraUpdate.newLatLng(mechanicPos!));
        });
      }
    });
  }

  Future<void> _createRoute() async {
    if (driverPos == null || mechanicPos == null) return;

    final result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(driverPos!.latitude, driverPos!.longitude),
        destination: PointLatLng(mechanicPos!.latitude, mechanicPos!.longitude),
        mode: TravelMode.driving,
      ),
    );

    polylineCoords = result.points
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: false,
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(target: driverPos!, zoom: 15),
        circles: circles,
        polylines: {
          Polyline(
            polylineId: const PolylineId("route"),
            width: 5,
            color: Colors.blue,
            points: polylineCoords,
          ),
        },
        onMapCreated: (controller) => mapController = controller,
      ),
    );
  }
}
