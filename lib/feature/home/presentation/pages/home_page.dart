import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auty_conductor/feature/vehicle/presentation/providers/vehicle_provider.dart';
import 'package:auty_conductor/feature/vehicle/domain/entities/vehicle_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VehicleEntity? myVehicle;
  String? userName;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// 🔹 Carga el nombre del usuario y su vehículo actual
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final driverUuid = prefs.getString('driverUuid');
    userName = prefs.getString('userName') ?? 'Conductor';

    if (driverUuid == null) {
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

  /// 🔹 Cerrar sesión
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Inicio'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: "Cerrar sesión",
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Bienvenida con el nombre del usuario
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFF235EE8),
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      "Hola, $userName 👋",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 🔹 Card del vehículo actual
              if (myVehicle != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF235EE8), Color(0xFF3B83F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🔹 Texto a la izquierda
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Text(
                                "Auto actual",
                                style: TextStyle(
                                  color: Color(0xFF235EE8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "${myVehicle!.brand} (${myVehicle!.type})",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text(
                                  "Color: ",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Color(
                                    int.parse(
                                      '0xFF${myVehicle!.colorHex.replaceAll("#", "")}',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  myVehicle!.colorName,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // 🔹 Imagen del vehículo a la derecha
                      if (myVehicle!.imageUrl != null &&
                          myVehicle!.imageUrl!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            myVehicle!.imageUrl!,
                            height: 80,
                            width: 120,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.directions_car,
                              color: Colors.white,
                              size: 80,
                            ),
                          ),
                        )
                      else
                        const Icon(
                          Icons.directions_car,
                          color: Colors.white,
                          size: 80,
                        ),
                    ],
                  ),
                ),
              ] else ...[
                // 🔹 Sin vehículo registrado
                Container(
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
              ],

              const SizedBox(height: 30),
              const Text(
                "Historial vacío",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
