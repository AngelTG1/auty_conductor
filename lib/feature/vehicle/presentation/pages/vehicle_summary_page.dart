import 'package:auty_conductor/feature/vehicle/presentation/providers/vehicle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/router/app_routes.dart';

class VehicleSummaryPage extends StatelessWidget {
  const VehicleSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<VehicleProvider>();

    final type = prov.types.firstWhere((t) => t.id == prov.selectedTypeId);
    final brand = prov.brands.firstWhere((b) => b.id == prov.selectedBrandId);
    final color = prov.colors.firstWhere((c) => c.id == prov.selectedColorId);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Configura tu vehículo'),
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Resumen del vehículo",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Verifica la información antes de guardar",
                style: TextStyle(fontSize: 20, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // 🧩 Resumen visual del vehículo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x11000000),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      type.imageUrl,
                      height: 110,
                      width: 110,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow("Tipo", type.name),
                          _infoRow("Marca", brand.name),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text(
                                "Color: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: Color(
                                  int.parse(
                                    '0xFF${color.hexCode.replaceAll("#", "")}',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                color.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

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
                            onPressed: () => context.go(AppRoutes.vehicleColor),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
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

                        // 🔹 Botón grande: Guardar vehículo
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF235EE8),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              _showSavingDialog(context);

                              try {
                                await prov.registerVehicle();

                                if (context.mounted) {
                                  Navigator.pop(
                                    context,
                                  ); // 🔹 Cierra "Guardando"

                                  // 🔹 Muestra animación de éxito
                                  _showSuccessDialog(context);

                                  await Future.delayed(
                                    const Duration(
                                      milliseconds: 2100,
                                    ), // ⏱️ 2.1 segundos
                                  );

                                  if (context.mounted) {
                                    Navigator.pop(context); // 🔹 Cierra éxito
                                    context.go(AppRoutes.home);
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: const Text(
                              'Guardar vehículo',
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

  // 🔹 Widget auxiliar de fila
  Widget _infoRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          children: [
            TextSpan(
              text: "$key: ",
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  // 🧩 Diálogo con fondo blanco y animación "guardando"
  void _showSavingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.1),
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/animations/saving.json',
                  width: 180,
                  height: 180,
                  repeat: true,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Guardando vehículo...',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🟢 Diálogo de éxito con fondo blanco
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.1),
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Lottie.asset(
              'assets/animations/success.json',
              width: 180,
              height: 180,
              repeat: false,
            ),
          ),
        );
      },
    );
  }
}
