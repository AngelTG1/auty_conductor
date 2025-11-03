import 'package:auty_conductor/feature/vehicle/presentation/providers/vehicle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

class VehicleTypePage extends StatefulWidget {
  const VehicleTypePage({super.key});

  @override
  State<VehicleTypePage> createState() => _VehicleTypePageState();
}

class _VehicleTypePageState extends State<VehicleTypePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<VehicleProvider>().loadCatalogs());
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<VehicleProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Configura tu vehículo'),
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 0.5,
      ),
      body: SafeArea(
        child: prov.loading
            ? const Center(child: CircularProgressIndicator())
            : GestureDetector(
                // 🔹 Detecta toque fuera del grid para deseleccionar
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (prov.selectedTypeId != null) {
                    prov.selectType(null); // ✅ Deselecciona tipo
                  }
                },
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 37,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: "¿Qué tipo de ",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: "vehículo ",
                                    style: TextStyle(color: Color(0xFF235EE8)),
                                  ),
                                  TextSpan(
                                    text: "tienes?",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Selecciona el tipo que mejor describa tu auto",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // 🔹 Cuadrícula uniforme
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1,
                                  ),
                              itemCount: prov.types.length,
                              itemBuilder: (context, index) {
                                final t = prov.types[index];
                                final selected = prov.selectedTypeId == t.id;

                                return GestureDetector(
                                  onTap: () => prov.selectType(t.id),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: selected
                                            ? const Color(0xFF235EE8)
                                            : Colors.grey.shade300,
                                        width: selected ? 2.5 : 1.5,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x11000000),
                                          blurRadius: 5,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        if (selected)
                                          const Positioned(
                                            top: 8,
                                            left: 8,
                                            child: CircleAvatar(
                                              radius: 6,
                                              backgroundColor: Color(
                                                0xFF235EE8,
                                              ),
                                            ),
                                          ),
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                t.imageUrl,
                                                height: 60,
                                                fit: BoxFit.contain,
                                              ),
                                              const SizedBox(height: 20),
                                              Text(
                                                t.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: selected
                                                      ? const Color(0xFF235EE8)
                                                      : Colors.black87,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),

                    // 🔹 Zona inferior fija y segura para botones
                    Container(
                      color: const Color(0xFFF8F8F8),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 🔹 Botón pequeño: Home
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: OutlinedButton(
                                  onPressed: () => context.go(AppRoutes.home),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xFF666666),
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    'Ir a Home',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF666666),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // 🔹 Botón grande: Seleccionar vehículo
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: prov.selectedTypeId != null
                                      ? () => context.go(AppRoutes.vehicleBrand)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF235EE8),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Seleccionar vehículo',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
