import 'package:flutter/material.dart';

class BuscarButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BuscarButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF235EE8),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Buscar mecánicos cercanos',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
