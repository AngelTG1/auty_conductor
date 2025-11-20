import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart';

import '../provider/location_provider.dart';

class MechanicInfoPage extends StatefulWidget {
  final String mechanicUuid;

  const MechanicInfoPage({super.key, required this.mechanicUuid});

  @override
  State<MechanicInfoPage> createState() => _MechanicInfoPageState();
}

class _MechanicInfoPageState extends State<MechanicInfoPage> {
  GoogleMapController? _mapController;

  String? _address; // ✔ Aquí guardamos la dirección real

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      // Cargar la info del taller
      await context.read<LocationProvider>().loadWorkshopInfo(
        widget.mechanicUuid,
      );

      final provider = context.read<LocationProvider>();
      final data = provider.selectedWorkshop;

      if (data != null) {
        // Convertir coordenadas → dirección real
        await _convertLatLngToAddress(data['lat'], data['lng']);
      }
    });
  }

  // ✔ Convierte latitud y longitud en dirección real
  Future<void> _convertLatLngToAddress(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      final place = placemarks.first;

      setState(() {
        _address =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      setState(() => _address = "Dirección no disponible");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocationProvider>();
    final data = provider.selectedWorkshop;

    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          data["workshopName"] ?? "Taller",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMapSection(data),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _buildInfoCard(data),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomButton(data),
    );
  }

  // 🗺️ MINI MAPA ESTILO UBER/DIDI
  Widget _buildMapSection(Map<String, dynamic> data) {
    return Container(
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      clipBehavior: Clip.hardEdge,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(data['lat'], data['lng']),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("workshop"),
            position: LatLng(data['lat'], data['lng']),
            infoWindow: InfoWindow(title: data["workshopName"]),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        },
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
      ),
    );
  }

  // 🟦 TARJETA DE INFORMACIÓN PRINCIPAL (incluye dirección real)
  Widget _buildInfoCard(Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEAF0FF),
                ),
                child: const Icon(
                  Icons.engineering,
                  size: 30,
                  color: Color(0xFF235EE8),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  data['user']['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          _section("Información del mecánico"),
          _tile("Certificado", data['mechanic']['certificateNumber']),

          const SizedBox(height: 14),

          _section("Contacto"),
          _tile("Teléfono", data['user']['phone']),
          _tile("Correo", data['user']['email']),

          const SizedBox(height: 14),

          _section("Ubicación"),
          _tile(
            "Dirección",
            _address ?? "Cargando dirección...",
          ), // ✔ AQUÍ VA LA DIRECCIÓN REAL

          const SizedBox(height: 10),

          Text(
            "Última actualización: ${data['timestamp'].toString().substring(0, 10)}",
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _tile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // 🔵 Botón para solicitar mecánico
  Widget _buildBottomButton(Map<String, dynamic> data) {
    return SafeArea(
      minimum: const EdgeInsets.only(left: 20, right: 20, bottom: 60, top: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            context.push(
              "/express-mechanic",
              extra: {"mechanicUuid": data["mechanicUuid"]},
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF235EE8),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            "Solicitar mecánico",
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
