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
    final width = MediaQuery.of(context).size.width;

    // --- Escalas responsivas ---
    final double padding = width * 0.04; // ~16 px
    final double badgeFont = width * 0.032; // ~12px
    final double brandFont = width * 0.032; // ~14px
    final double plateFont = width * 0.065; // ~30px
    final double carSize = width * 0.27; // imagen auto ~30% del ancho
    final double iconSize = width * 0.20;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 🔹 Contenedor principal
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: padding,
            right: padding,
            top: padding * 2,
            bottom: padding,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF171998), Color(0xFF272BFE)],
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
                    SizedBox(height: padding * 2.2), // espacio para badge
                    Text(
                      "${vehicle.brand} (${vehicle.colorName})",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: brandFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: padding * 0.3),
                    Text(
                      licenseNumber ?? 'Licencia no disponible',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: plateFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: padding * 0.5),

              // 🔹 Imagen o ícono responsivo
              if (vehicle.imageUrl.isNotEmpty)
                Image.network(
                  vehicle.imageUrl,
                  height: carSize,
                  width: carSize + width * 0.1,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.directions_car,
                    color: Colors.white,
                    size: iconSize,
                  ),
                )
              else
                Icon(Icons.directions_car, color: Colors.white, size: iconSize),
            ],
          ),
        ),

        // 🔹 Badge “Auto actual”
        Positioned(
          left: 0,
          top: padding * 1.2,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: padding * 0.8,
              vertical: padding * 0.3,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Text(
              "Auto actual",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: badgeFont,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
