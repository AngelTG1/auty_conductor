import 'package:flutter/material.dart';

class VehicleBox extends StatelessWidget {
  final VoidCallback onTap;

  const VehicleBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(Icons.car_repair, size: 60, color: Color(0xFFA3A3A3)),
        ),
      ),
    );
  }
}
