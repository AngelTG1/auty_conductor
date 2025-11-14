import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../core/router/app_routes.dart';

// 🔹 Widgets separados
import '../widget/description_field.dart';
import '../widget/location_field.dart';
import '../widget/vehicle_box.dart';

class ExpressMechanicPage extends StatefulWidget {
  const ExpressMechanicPage({super.key});

  @override
  State<ExpressMechanicPage> createState() => _ExpressMechanicPageState();
}

class _ExpressMechanicPageState extends State<ExpressMechanicPage> {
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _locationCtrl = TextEditingController();
  bool isSaving = false;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    _descCtrl.addListener(_validateForm);
    _locationCtrl.addListener(_validateForm);
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid =
        _descCtrl.text.trim().isNotEmpty &&
        _locationCtrl.text.trim().isNotEmpty;

    if (isValid != isFormValid) {
      setState(() => isFormValid = isValid);
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, activa la ubicación para continuar.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permiso de ubicación denegado.'),
            backgroundColor: Colors.orangeAccent,
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permiso de ubicación denegado permanentemente.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final formattedAddress =
            '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}';

        setState(() {
          _locationCtrl.text = formattedAddress.trim();
        });
        _validateForm();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo obtener la ubicación.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Configuración del problema'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0.5,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Descripción",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DescriptionField(
                        controller: _descCtrl,
                        onValidate: _validateForm,
                      ),

                      const SizedBox(height: 24),
                      const Text(
                        "Ubicación actual",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LocationField(
                        controller: _locationCtrl,
                        onRefresh: _getCurrentLocation,
                      ),

                      const SizedBox(height: 24),
                      const Text(
                        "Cargar vehículo",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Selecciona el vehículo que necesita asistencia.",
                        style: TextStyle(fontSize: 12, color: Colors.black38),
                      ),
                      const SizedBox(height: 8),
                      VehicleBox(onTap: _showVehicleModal),

                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
              _buildBottomButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Modal inferior para seleccionar tipo de vehículo
  void _showVehicleModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Center(
                    child: Text(
                      'Agregar nuevo vehículo',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // 🔹 Navegar a la pantalla de registro de vehículo
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  title: const Center(
                    child: Text(
                      'Agregar existente',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // 🔹 Abrir lista de vehículos guardados
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(22, 8, 22, 12),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: isFormValid && !isSaving
              ? () async {
                  setState(() => isSaving = true);
                  await Future.delayed(const Duration(seconds: 1));
                  setState(() => isSaving = false);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Solicitud enviada con éxito 🚗💨'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.go(AppRoutes.home);
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isFormValid
                ? const Color(0xFF1E329D)
                : Colors.grey.shade300,
            foregroundColor: isFormValid ? Colors.white : Colors.grey.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: isSaving
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Guardar',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }
}
