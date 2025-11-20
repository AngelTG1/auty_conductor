import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MechanicCard extends StatelessWidget {
  final Map<String, dynamic> mechanic;
  final String distanceText;
  final VoidCallback onRoutePressed;
  final VoidCallback onRequestPressed;

  const MechanicCard({
    super.key,
    required this.mechanic,
    required this.distanceText,
    required this.onRoutePressed,
    required this.onRequestPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 20,
              child: Icon(Icons.build, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          mechanic['name'] ?? 'Mecánico desconocido',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF2F9),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        child: Text(
                          distanceText,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      // 🔵 BOTÓN INFORMACIÓN (Corregido)
                      ElevatedButton(
                        onPressed: () {
                          context.push(
                            "/mechanic-info",
                            extra: mechanic['uuid'],
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF235EE8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                        ),
                        child: const Text(
                          "Información",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // 🧭 Ver ruta
                      ElevatedButton(
                        onPressed: onRoutePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                            side: const BorderSide(color: Color(0xFFBABABA)),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 6,
                          ),
                        ),
                        child: const Text(
                          "Ver ruta",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),

                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
