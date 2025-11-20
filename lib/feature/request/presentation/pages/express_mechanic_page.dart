import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../vehicle/domain/entities/vehicle_entity.dart';
import '../../../vehicle/presentation/providers/vehicle_provider.dart';
import '../../presentation/provider/request_provider.dart';

import '../widget/description_field.dart';
import '../widget/location_field.dart';
import '../widget/card_express.dart';

import '../../../../core/ws/ws_service.dart';
import '../widget/waiting_mechanic_dialog.dart';

class ExpressMechanicPage extends StatefulWidget {
  final String? mechanicUuid;
  const ExpressMechanicPage({super.key, this.mechanicUuid});

  @override
  State<ExpressMechanicPage> createState() => _ExpressMechanicPageState();
}

class _ExpressMechanicPageState extends State<ExpressMechanicPage> {
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _locationCtrl = TextEditingController();

  final ValueNotifier<bool> isFormValid = ValueNotifier(false);
  final ValueNotifier<bool> isSaving = ValueNotifier(false);
  final ValueNotifier<bool> locationOk = ValueNotifier(false);
  final ValueNotifier<Widget?> vehicleCardMemo = ValueNotifier(null);

  VehicleEntity? myVehicle;
  Position? _currentPosition;
  String? mechanicUuid;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    mechanicUuid = widget.mechanicUuid;

    _loadInitialData();

    _descCtrl.addListener(_onTextChange);
    _locationCtrl.addListener(_onTextChange);

    // =====================================================
    // 🔥 ESCUCHAR RESPUESTA DEL MECÁNICO POR WEBSOCKET
    // =====================================================
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ws = context.read<WsService>();

      ws.addListener(() {
        final msg = ws.lastMessage; // ✅ CORREGIDO

        if (msg == null) return;
        if (!mounted) return;

        // Cerrar modal si está abierto
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        switch (msg["type"]) {
          case "request_accepted":
            _onAccepted(msg["data"]);
            break;

          case "request_rejected":
            _onRejected(msg["data"]);
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([_loadVehicle(), _loadLocation()]);

    if (!mounted) return; // 🔥 evita crash
  }

  void _onTextChange() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 120), () {
      isFormValid.value =
          _descCtrl.text.trim().isNotEmpty &&
          _locationCtrl.text.trim().isNotEmpty;
    });
  }

  Future<void> _loadVehicle() async {
    final uuid = await SecureStorageService.read("driverUuid");
    if (uuid == null) return;

    final result = await context.read<VehicleProvider>().loadMyVehicle(uuid);

    if (!mounted) return; // 👈 evita el crash

    myVehicle = result;

    vehicleCardMemo.value = myVehicle != null
        ? CardExpress(vehicle: myVehicle!)
        : _registerVehicleCard(context);
  }

  Future<void> _loadLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      _currentPosition = pos;

      final address = await _convertAddress(pos.latitude, pos.longitude);
      _locationCtrl.text = address;

      locationOk.value = true;

      Future.delayed(const Duration(seconds: 2), () {
        locationOk.value = false;
      });
    } catch (_) {
      _locationCtrl.text = "No se pudo obtener la ubicación";
    }
  }

  Future<String> _convertAddress(double lat, double lng) async {
    try {
      final place = (await placemarkFromCoordinates(lat, lng)).first;
      return "${place.street}, ${place.locality}, ${place.country}";
    } catch (_) {
      return "Dirección no disponible";
    }
  }

  // ======================================================
  // 🔥 ENVIAR SOLICITUD + ABRIR MODAL "ESPERANDO..."
  // ======================================================
  Future<void> _sendRequest() async {
    isSaving.value = true;

    final provider = context.read<RequestProvider>();
    final driverUuid = await SecureStorageService.read("driverUuid");

    await provider.create(
      context,
      driverUuid: driverUuid!,
      mechanicUuid: mechanicUuid ?? "express-mode",
      description: _descCtrl.text,
      address: _locationCtrl.text,
      lat: _currentPosition!.latitude,
      lng: _currentPosition!.longitude,
    );

    isSaving.value = false;

    if (!mounted) return;
    final dialogKey = GlobalKey<WaitingMechanicDialogState>();

    // Abrir modal de espera
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return WaitingMechanicDialog(
          onTimeOut: () {
            context.go(AppRoutes.home);
          },
          onAutoRejected: () {
            // 🔥 Mostrar mensaje automático
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Solicitud Expirada"),
                content: const Text(
                  "El mecánico no respondió a tiempo y la solicitud fue rechazada automáticamente.",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.home);
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ======================================================
  // 🟢 MECÁNICO ACEPTÓ LA SOLICITUD
  // ======================================================
  void _onAccepted(Map<String, dynamic> request) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Solicitud Aceptada"),
        content: const Text("El mecánico aceptó tu solicitud."),
        actions: [
          TextButton(
            onPressed: () {
              if (!mounted) return;
              Navigator.of(context, rootNavigator: true).pop(); // cerrar alerta
              context.go(AppRoutes.home); // navegar
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // ❌ MECÁNICO RECHAZÓ LA SOLICITUD
  // ======================================================
  void _onRejected(Map<String, dynamic> request) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Solicitud Rechazada"),
        content: const Text("El mecánico rechazó tu solicitud."),
        actions: [
          TextButton(
            onPressed: () {
              if (!mounted) return;
              Navigator.of(context, rootNavigator: true).pop();
              context.go(AppRoutes.home);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // UI
  // ======================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _buildUI(context)),
      bottomNavigationBar: _bottomButton(),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 40),

                  const Text(
                    "Configuración del problema",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 12),

                  DescriptionField(
                    controller: _descCtrl,
                    onValidate: _onTextChange,
                  ),

                  const SizedBox(height: 12),

                  LocationField(
                    controller: _locationCtrl,
                    onRefresh: _loadLocation,
                  ),

                  ValueListenableBuilder<bool>(
                    valueListenable: locationOk,
                    builder: (_, ok, __) => AnimatedOpacity(
                      opacity: ok ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: ok
                          ? _locationSuccessIndicator()
                          : const SizedBox.shrink(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ValueListenableBuilder<Widget?>(
                    valueListenable: vehicleCardMemo,
                    builder: (_, w, __) =>
                        w ?? const Center(child: CircularProgressIndicator()),
                  ),

                  const SizedBox(height: 150),
                ]),
              ),
            ),
          ],
        ),

        // Botón BACK
        Positioned(
          top: 10,
          left: 10,
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, size: 22),
            ),
          ),
        ),
      ],
    );
  }

  Widget _locationSuccessIndicator() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text("Ubicación detectada correctamente"),
        ],
      ),
    );
  }

  Widget _registerVehicleCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.vehicleType),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: const Row(
          children: [
            Icon(Icons.add_road, color: Color(0xFF235FE8), size: 40),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                "Registra tu vehículo\nNecesitamos tu auto para solicitar un mecánico.",
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomButton() {
    return SafeArea(
      minimum: const EdgeInsets.only(left: 20, right: 20, bottom: 60, top: 10),
      child: ValueListenableBuilder<bool>(
        valueListenable: isFormValid,
        builder: (_, valid, __) {
          return ValueListenableBuilder<bool>(
            valueListenable: isSaving,
            builder: (_, saving, __) {
              return ElevatedButton(
                onPressed: valid && !saving ? _sendRequest : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: valid
                      ? const Color(0xFF235FE8)
                      : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Enviar solicitud",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
