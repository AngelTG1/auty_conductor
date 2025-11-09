import 'package:flutter/material.dart';

class SelectedMechanicCard extends StatelessWidget {
  final Map<String, dynamic> mechanic;
  final VoidCallback onBack;
  final VoidCallback onCancel;

  const SelectedMechanicCard({
    super.key,
    required this.mechanic,
    required this.onBack,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            mechanic['name'] ?? 'Mecánico desconocido',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            mechanic['address'] ?? '',
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_car, color: Colors.redAccent, size: 20),
              const SizedBox(width: 6),
              Text(
                "${mechanic['durationText']} · ${mechanic['distanceText']}",
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.cancel_outlined),
            label: const Text("Cancelar mecánico seleccionado"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),

        ],
      ),
    );
  }
}
