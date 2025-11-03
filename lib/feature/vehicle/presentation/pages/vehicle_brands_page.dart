import 'package:auty_conductor/feature/vehicle/presentation/providers/vehicle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

class VehicleBrandsPage extends StatelessWidget {
  const VehicleBrandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<VehicleProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Configura tu vehículo'),
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: prov.loading
            ? const Center(child: CircularProgressIndicator())
            : GestureDetector(
                // 👇 Este detecta cualquier toque fuera de los elementos interactivos
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // 🔹 Si había una marca seleccionada, la deseleccionamos
                  if (prov.selectedBrandId != null) {
                    prov.selectBrand(null);
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
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: "¿Cuál es la ",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: "marca?",
                                    style: TextStyle(color: Color(0xFF235EE8)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Selecciona la marca de tu vehículo",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // 🔹 Grid uniforme
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 2.3,
                                  ),
                              itemCount: prov.brands.length,
                              itemBuilder: (context, index) {
                                final b = prov.brands[index];
                                final selected = prov.selectedBrandId == b.id;

                                return GestureDetector(
                                  // 👇 Este mantiene la selección del carro
                                  onTap: () => prov.selectBrand(b.id),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
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
                                        // 🔹 Indicador seleccionado (puntito azul)
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

                                        // 🔹 Nombre centrado
                                        Center(
                                          child: Text(
                                            b.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: selected
                                                  ? const Color(0xFF235EE8)
                                                  : Colors.black87,
                                              fontSize: 18,
                                            ),
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
                              // Botón pequeño (Regresar)
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: OutlinedButton(
                                  onPressed: () =>
                                      context.go(AppRoutes.vehicleType),
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

                              // Botón grande (Seleccionar color)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: prov.selectedBrandId != null
                                      ? () => context.go(AppRoutes.vehicleColor)
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
                                    'Seleccionar color',
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
