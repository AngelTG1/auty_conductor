import 'package:flutter/material.dart';

class LocationField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onRefresh;

  const LocationField({
    super.key,
    required this.controller,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    const labelColor = Color(0xFF2C2C2C);
    const borderColor = Color(0xFFE1E1E1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ubicación actual",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),

        const SizedBox(height: 6),

        // ⭐ CONTENEDOR SIN SOMBRA Y SIN DOBLE BORDE
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              right: 6,
            ), // evita que se mueva el ícono
            child: TextField(
              controller: controller,
              readOnly: true,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Obteniendo dirección...",
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),

                // ⭐ BORDE TOTALMENTE INHABILITADO
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),

                // ⭐ Suffix ULTRA LIMPIO
                suffixIcon: IconButton(
                  onPressed: onRefresh,
                  splashRadius: 20,
                  icon: const Icon(Icons.my_location, color: Color(0xFF235FE8)),
                ),
              ),
              style: const TextStyle(fontSize: 15, color: labelColor),
            ),
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          "Presiona el ícono para actualizar tu ubicación",
          style: TextStyle(fontSize: 12, color: Colors.black45),
        ),
      ],
    );
  }
}
