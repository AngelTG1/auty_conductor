import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../core/ws/ws_service.dart';

class MechanicTrackingPage extends StatefulWidget {
  final Map<String, dynamic> request;

  const MechanicTrackingPage({super.key, required this.request});

  @override
  State<MechanicTrackingPage> createState() => _MechanicTrackingPageState();
}

class _MechanicTrackingPageState extends State<MechanicTrackingPage> {
  GoogleMapController? mapController;

  Marker mechanicMarker = const Marker(markerId: MarkerId("mechanic"));
  LatLng mechanicPos = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();

    final ws = context.read<WsService>();

    // 🔵 ESCUCHAR ubicación del mecánico EN TIEMPO REAL
    ws.addListener(() {
      final msg = ws.lastMessage;
      if (msg == null) return;

      if (msg["type"] == "mechanic_location") {
        final data = msg["data"];

        if (data["mechanicUuid"] == widget.request["mechanicUuid"]) {
          _updateMechanicLocation(data["lat"], data["lng"]);
        }
      }
    });
  }

  void _updateMechanicLocation(double lat, double lng) {
    setState(() {
      mechanicPos = LatLng(lat, lng);

      mechanicMarker = Marker(
        markerId: const MarkerId("mechanic"),
        position: mechanicPos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
    });

    mapController?.animateCamera(CameraUpdate.newLatLng(mechanicPos));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mecánico en camino"),
        backgroundColor: const Color(0xFF235FE8),
      ),
      body: GoogleMap(
        onMapCreated: (c) => mapController = c,
        initialCameraPosition: CameraPosition(target: mechanicPos, zoom: 15),
        markers: {mechanicMarker},
      ),
    );
  }
}
