import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auty_conductor/feature/vehicle/presentation/providers/vehicle_provider.dart';
import 'package:auty_conductor/feature/vehicle/domain/entities/vehicle_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../widgets/car_card.dart';
import '../widgets/home_menu.dart';
import '../widgets/history_empty.dart';
import '../widgets/search_mechanic_button.dart';

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

  /// 🔹 Carga los datos del usuario y su vehículo actual
  Future<void> _loadData() async {
    final driverUuid = await SecureStorageService.read('driverUuid');
    userName = await SecureStorageService.read('userName') ?? 'Conductor';
    userEmail = await SecureStorageService.read('userEmail') ?? 'Correo';
    userPhone = await SecureStorageService.read('userPhone') ?? 'Teléfono';
    userLicense = await SecureStorageService.read('userLicense') ?? 'Licencia';

    if (driverUuid == null || driverUuid.isEmpty) {
      setState(() => loading = false);
      return;
    }

    final provider = context.read<VehicleProvider>();
    final vehicle = await provider.loadMyVehicle(driverUuid);

    setState(() {
      myVehicle = vehicle;
      loading = false;
    });
  }

  /// 🔹 Confirmar cierre de sesión
  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Cerrar sesión?'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF235EE8),
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await SecureStorageService.clear();
      if (!mounted) return;
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                // 🔹 Encabezado con usuario
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      radius: 17,
                      backgroundColor: Color(0xFFA1A1A1),
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName ?? '',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            userEmail ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.black,
                            size: 26,
                          ),
                        ),
                        IconButton(
                          onPressed: _confirmLogout,
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: Colors.black,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 🔹 Card de vehículo
                if (myVehicle != null)
                  CarCard(vehicle: myVehicle!, licenseNumber: userLicense)
                else
                  Container(
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Configurar vehículo"),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 10),
                const HomeMenu(),
                const SizedBox(height: 10),
                const SafeArea(
                  child: SearchMechanicButton(),
                ),
                const HistoryEmpty(),

                const SizedBox(height: 10),

                // 🔹 Botón inferior dentro del scroll (NO bottomNavigationBar)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
