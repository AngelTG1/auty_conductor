import 'package:auty_conductor/feature/vehicle/presentation/providers/vehicle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

class VehicleColorsPage extends StatelessWidget {
  const VehicleColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<VehicleProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: prov.loading
            ? const Center(child: CircularProgressIndicator())
            : GestureDetector(
                // 🔹 Detecta toques fuera del grid para deseleccionar
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (prov.selectedColorId != null) {
                    prov.selectColor(null); // ✅ Deselecciona el color
                  }
                },
                child: Column(
                  children: [
                    // 🔹 Contenido principal desplazable
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Configura tu vehículo",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: "¿De qué ",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: "color ",
                                    style: TextStyle(color: Color(0xFF235EE8)),
                                  ),
                                  TextSpan(
                                    text: "es?",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Selecciona el color de tu vehículo",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // 🔹 Cuadrícula de colores
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
                              itemCount: prov.colors.length,
                              itemBuilder: (context, index) {
                                final c = prov.colors[index];
                                final selected = prov.selectedColorId == c.id;

                                return GestureDetector(
                                  // 🔹 Este mantiene la selección del color
                                  onTap: () => prov.selectColor(c.id),
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
                                        // 🔹 Indicador de selección (puntito azul)
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

                                        // 🔹 Contenido principal
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  2,
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: CircleAvatar(
                                                  radius: 38,
                                                  backgroundColor: Color(
                                                    int.parse(
                                                      '0xFF${c.hexCode.replaceAll("#", "")}',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 18),
                                              Text(
                                                c.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: selected
                                                      ? const Color(0xFF235EE8)
                                                      : Colors.black87,
                                                  fontSize: 20,
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

                    // 🔹 Botones inferiores
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
                              // 🔹 Botón pequeño: Regresar
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: OutlinedButton(
                                  onPressed: () =>
                                      context.go(AppRoutes.vehicleBrand),
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
                                    'Regresar',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF666666),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // 🔹 Botón grande: Continuar
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: prov.selectedColorId != null
                                      ? () =>
                                            context.go(AppRoutes.vehicleSummary)
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
                                    'Guardar color',
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
