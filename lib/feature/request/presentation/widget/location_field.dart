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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          maxLines: 2,
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Detectando ubicación...',
            hintStyle: const TextStyle(color: Color(0xFFA3A3A3)),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.my_location, color: Color(0xFF235EE8)),
              onPressed: onRefresh,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Presiona el ícono para actualizar la ubicación',
          style: TextStyle(fontSize: 12, color: Colors.black38),
        ),
      ],
    );
  }
}
