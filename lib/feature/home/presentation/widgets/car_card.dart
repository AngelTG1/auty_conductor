import 'package:flutter/material.dart';
import 'package:auty_conductor/feature/vehicle/domain/entities/vehicle_entity.dart';

class CarCard extends StatelessWidget {
  final VehicleEntity vehicle;
  final String? licenseNumber;

  const CarCard({
    super.key,
    required this.vehicle,
    required this.licenseNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 🔹 Contenedor principal con gradiente de abajo hacia arriba
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 30,
            bottom: 16,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF171998), // color inferior
                Color(0xFF272BFE), // color superior
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Info del vehículo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 37), // espacio para el badge
                    Text(
                      "${vehicle.brand} (${vehicle.colorName})",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      licenseNumber ?? 'Licencia no disponible',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // 🔹 Imagen o ícono
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

        // 🔹 Badge “Auto actual”
        Positioned(
          left: 0,
          top: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: const Text(
              "Auto actual",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
