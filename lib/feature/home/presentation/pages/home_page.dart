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
  String? profileImageUrl;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _loadData() async {
    setState(() => loading = true);

    await Future.delayed(const Duration(milliseconds: 400));

    final driverUuid = await SecureStorageService.read('driverUuid');

    userName = await SecureStorageService.read('userName') ?? 'Conductor';
    userEmail = await SecureStorageService.read('userEmail') ?? 'Correo';
    userPhone = await SecureStorageService.read('userPhone') ?? 'Teléfono';
    userLicense =
        await SecureStorageService.read('licenseNumber') ?? 'Licencia';
    profileImageUrl = await SecureStorageService.read('profileImage');

    if (driverUuid == null || driverUuid.isEmpty) {
      if (!mounted) return;
      setState(() => loading = false);
      return;
    }

    final provider = context.read<VehicleProvider>();
    myVehicle = await provider.loadMyVehicle(driverUuid);

    if (!mounted) return;

    setState(() => loading = false);
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Cerrar sesión?"),
        content: const Text("¿Estás seguro que deseas cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Cerrar sesión"),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: loading
            ? const _HomeSkeleton() // ⭐ se muestra de inmediato
            : RefreshIndicator(
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 800;

                      final vehicleSection = myVehicle != null
                          ? CarCard(
                              vehicle: myVehicle!,
                              licenseNumber: userLicense,
                            )
                          : _noVehicleCard();

                      final primaryActions = Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          SizedBox(height: 10),
                          SearchMechanicButton(),
                        ],
                      );

                      final historySection = Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          SizedBox(height: 10),
                          HistoryEmpty(),
                        ],
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeHeader(
                            userName: userName ?? '',
                            userEmail: userEmail ?? '',
                            onLogout: _confirmLogout,
                            onNotifications: () {},
                          ),
                          const SizedBox(height: 20),
                          if (isWide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      vehicleSection,
                                      primaryActions,
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 2,
                                  child: historySection,
                                ),
                              ],
                            )
                          else ...[
                            vehicleSection,
                            primaryActions,
                            historySection,
                          ],
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }

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
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header skeleton
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 120, height: 14, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(width: 160, height: 12, color: Colors.white),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // CarCard skeleton
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),       

            const SizedBox(height: 20),

            // Search button skeleton
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            const SizedBox(height: 20),

            // History skeleton
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
    );
  }
}
