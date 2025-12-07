import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart';

// Providers
import '../provider/location_provider.dart';
import '../../../comments/presentation/providers/comment_provider.dart';

// Widgets propios
import '../widget/mechanic_profile_header.dart';
import '../widget/mechanic_info_card.dart';
import '../widget/mechanic_bottom_button.dart';
import '../../../comments/presentation/widgets/comment_section.dart';
import '../../../comments/presentation/widgets/comment_modal.dart';

class MechanicInfoPage extends StatefulWidget {
  final String mechanicUuid;

  const MechanicInfoPage({super.key, required this.mechanicUuid});

  @override
  State<MechanicInfoPage> createState() => _MechanicInfoPageState();
}

class _MechanicInfoPageState extends State<MechanicInfoPage> {
  GoogleMapController? _mapController;
  String? _address;

  String safeName(dynamic name) {
    if (name == null) return "Sin nombre";

    if (name is String) return name;

    if (name is Map) {
      if (name.containsKey("first") && name.containsKey("last")) {
        return "${name['first']} ${name['last']}";
      }
      if (name.containsKey("fullName")) return name['fullName'];
      if (name.containsKey("value")) return name['value'];
      return name.toString();
    }

    return name.toString();
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context.read<LocationProvider>().loadWorkshopInfo(
        widget.mechanicUuid,
      );

      final provider = context.read<LocationProvider>();
      final data = provider.selectedWorkshop;

      if (data != null) {
        await _convertLatLngToAddress(data['lat'], data['lng']);
      }
    });
  }

  Future<void> _convertLatLngToAddress(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      final place = placemarks.first;

      setState(() {
        _address =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (_) {
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

    return ChangeNotifierProvider(
      create: (_) => CommentProvider()..loadComments(widget.mechanicUuid),
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            safeName(data["workshopName"]),
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
              /// HEADER SEPARADO
              MechanicProfileHeader(data: data, safeName: safeName),

              const SizedBox(height: 10),

              /// CARD PROFESIONAL SEPARADA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: MechanicInfoCard(data: data, address: _address),
              ),

              const SizedBox(height: 25),

              // ⭐⭐⭐ SECCIÓN REAL DE COMENTARIOS ⭐⭐⭐
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Comentarios del mecánico",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        CommentModal.show(context, widget.mechanicUuid);
                      },
                      child: const Text(
                        "Escribir",
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              CommentSection(mechanicUuid: widget.mechanicUuid),

              const SizedBox(height: 40),
            ],
          ),
        ),

        /// BOTÓN INFERIOR SEPARADO
        bottomNavigationBar: MechanicBottomButton(
          mechanicUuid: data["mechanicUuid"],
        ),
      ),
    );
  }
}
