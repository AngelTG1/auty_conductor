import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final name = mechanic['name'] ?? 'Mecánico desconocido';
    final distance = mechanic['distanceText'] ?? '--';
    final duration = mechanic['durationText'] ?? '--';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ───────── Indicador superior
          Container(
            width: 46,
            height: 5,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          // ───────── Avatar + Nombre
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.blue.shade50,
                child: const Icon(
                  Icons.person,
                  color: Colors.blueAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ───────── Datos de distancia / tiempo
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.timer_rounded,
                  size: 18,
                  color: Colors.blueAccent,
                ),
                const SizedBox(width: 6),
                Text(
                  duration,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(width: 14),
                const Icon(
                  Icons.place_rounded,
                  size: 18,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 6),
                Text(
                  distance,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ───────── Botón principal
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.push(
                  "/express-mechanic",
                  extra: {"mechanicUuid": mechanic["uuid"]},
                );
              },
              icon: const Icon(Icons.build_rounded),
              label: const Text(
                "Solicitar mecánico",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF235FE8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ───────── Botón secundario
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onCancel,
              icon: const Icon(Icons.close_rounded),
              label: const Text("Cancelar selección"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: Colors.black87,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
