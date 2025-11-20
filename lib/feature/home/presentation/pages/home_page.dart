import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:auty_conductor/feature/vehicle/presentation/providers/vehicle_provider.dart';
import 'package:auty_conductor/feature/vehicle/domain/entities/vehicle_entity.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/services/secure_storage_service.dart';

// Widgets
import '../widgets/car_card.dart';
import '../widgets/home_menu.dart';
import '../widgets/history_empty.dart';
import '../widgets/search_mechanic_button.dart';
import '../widgets/home_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VehicleEntity? myVehicle;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userLicense;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!loading) return;

    await Future.delayed(const Duration(seconds: 2));
    final driverUuid = await SecureStorageService.read('driverUuid');

    userName = await SecureStorageService.read('userName') ?? 'Conductor';
    userEmail = await SecureStorageService.read('userEmail') ?? 'Correo';
    userPhone = await SecureStorageService.read('userPhone') ?? 'Teléfono';
    userLicense =
        await SecureStorageService.read('licenseNumber') ?? 'Licencia';

    if (driverUuid == null || driverUuid.isEmpty) {
      if (!mounted) return;
      setState(() => loading = false);
      return;
    }

    final provider = context.read<VehicleProvider>();
    final vehicle = await provider.loadMyVehicle(driverUuid);

    if (!mounted) return;
    setState(() {
      myVehicle = vehicle;
      loading = false;
    });
  }

  Future<void> _confirmLogout() async {
    final width = MediaQuery.of(context).size.width;

    // 🔹 Valores responsivos calculados por ancho
    final double titleFont = width * 0.045; // ~18–20px
    final double contentFont = width * 0.038; // ~14–16px
    final double buttonFont = width * 0.033; // ~14–15px
    final double paddingBtn = width * 0.03;
    final double dialogRadius = width * 0.04; // ~12–18px

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogRadius),
        ),

        title: Text(
          '¿Cerrar sesión?',
          style: TextStyle(fontSize: titleFont, fontWeight: FontWeight.bold),
        ),

        content: Text(
          '¿Estás seguro de que deseas cerrar sesión?',
          style: TextStyle(fontSize: contentFont, height: 1.3),
        ),

        actionsPadding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: width * 0.02,
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Padding(
              padding: EdgeInsets.all(paddingBtn),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey, fontSize: buttonFont),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF235EE8),
              foregroundColor: Colors.white,
              padding: EdgeInsets.all(paddingBtn),
            ),
            child: Text(
              'Cerrar sesión',
              style: TextStyle(fontSize: buttonFont),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await SecureStorageService.clear();
      if (!mounted) return;
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Si está cargando → muestra skeleton con Scaffold propio
    if (loading) {
      return const _HomeSkeleton();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ⭐ Header responsivo
                HomeHeader(
                  userName: userName ?? '',
                  userEmail: userEmail ?? '',
                  onLogout: _confirmLogout,
                  onNotifications: () {
                    debugPrint("📦 Notificaciones presionado");
                  },
                ),

                const SizedBox(height: 20),

                // 🔹 Card de vehículo o mensaje
                if (myVehicle != null)
                  CarCard(vehicle: myVehicle!, licenseNumber: userLicense)
                else
                  _noVehicleCard(),

                const SizedBox(height: 10),
                const HomeMenu(),
                const SizedBox(height: 10),
                const SearchMechanicButton(),
                const HistoryEmpty(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Widget para cuando no hay vehículo
  Widget _noVehicleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            "No tienes vehículo registrado",
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.vehicleType),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF235EE8),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Configurar vehículo"),
          ),
        ],
      ),
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 100, height: 14, color: Colors.white),
                        const SizedBox(height: 6),
                        Container(width: 140, height: 12, color: Colors.white),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: 75,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
