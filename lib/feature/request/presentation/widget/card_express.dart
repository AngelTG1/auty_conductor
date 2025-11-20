import 'package:flutter/material.dart';
import 'package:auty_conductor/feature/vehicle/domain/entities/vehicle_entity.dart';

class CardExpress extends StatelessWidget {
  final VehicleEntity vehicle;

  const CardExpress({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ⭐ LABEL SUPERIOR ⭐
        const Text(
          "Cargar vehículo",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 8),

        // ⭐ TARJETA DEL VEHÍCULO ⭐
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF235FE8), // azul sólido
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ---------- INFORMACIÓN DEL VEHÍCULO ----------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${vehicle.brand} (${vehicle.colorName})",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Tipo: ${vehicle.type}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // ---------- IMAGEN O ICONO ----------
              if (vehicle.imageUrl.isNotEmpty)
                Image.network(
                  vehicle.imageUrl,
                  height: 90,
                  width: 135,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.directions_car,
                    color: Colors.white,
                    size: 80,
                  ),
                )
              else
                const Icon(Icons.directions_car, color: Colors.white, size: 80),
            ],
          ),
        ),
      ],
    );
  }
}
