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
    final name = mechanic['name'] ?? 'Mecánico';
    final rating = mechanic['rating'];
    final isAvailable = mechanic['available'] ?? true;
    final photoUrl = mechanic['profileImage'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ───── FOTO DEL MECÁNICO
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: photoUrl != null && photoUrl.isNotEmpty
                      ? Image.network(
                          photoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _defaultAvatar(),
                        )
                      : _defaultAvatar(),
                ),
              ),

              const SizedBox(width: 12),

              // ───── Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre + estado
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusChip(available: isAvailable),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Rating + distancia
                    Row(
                      children: [
                        if (rating != null) ...[
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF2F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            distanceText,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ───── Acciones
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.push("/mechanic-info", extra: mechanic['uuid']);
                  },
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text("Información"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    foregroundColor: const Color(0xFF235EE8),
                    side: BorderSide(color: Colors.blue.shade200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onRoutePressed,
                  icon: const Icon(Icons.alt_route_rounded, size: 18),
                  label: const Text("Ver ruta"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF235EE8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ───── Avatar por defecto cuando no hay foto
  Widget _defaultAvatar() {
    return Container(
      color: Colors.blue.shade50,
      child: const Icon(Icons.person, color: Color(0xFF235EE8), size: 26),
    );
  }
}

// ───────────────── Estado del mecánico
class _StatusChip extends StatelessWidget {
  final bool available;
  const _StatusChip({required this.available});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: available
            ? Colors.green.withOpacity(0.12)
            : Colors.grey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        available ? "Disponible" : "Ocupado",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: available ? Colors.green : Colors.black54,
        ),
      ),
    );
  }
}
