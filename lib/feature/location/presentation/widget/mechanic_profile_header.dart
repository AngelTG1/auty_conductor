import 'package:flutter/material.dart';

class MechanicProfileHeader extends StatelessWidget {
  final Map<String, dynamic> data;
  final String Function(dynamic) safeName;

  const MechanicProfileHeader({
    super.key,
    required this.data,
    required this.safeName,
  });

  @override
  Widget build(BuildContext context) {
    // ================================
    // 🔍 USER Y MECÁNICO
    // ================================
    final mechanic = data["mechanic"] ?? {};
    final user = data["user"] ?? {};

    // ================================
    // 🔵 FOTO DEL MECÁNICO
    // ================================
    dynamic rawImage = user["profileImage"];

    // Soporta formatos:
    // profileImage: "url"
    // profileImage: { "value": "url" }
    // null
    final String photoUrl = rawImage is Map
        ? (rawImage["value"] ?? "")
        : (rawImage?.toString() ?? "");

    final String finalPhotoUrl = (photoUrl.isNotEmpty && photoUrl != "null")
        ? photoUrl
        : "https://robohash.org/default.png?size=400x400";

    // ================================
    // 🔵 NOMBRE
    // ================================
    final String mechanicName = safeName(
      user["name"] ?? mechanic["name"] ?? "Mecánico",
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          // FOTO
          ClipOval(
            child: Image.network(
              finalPhotoUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE5E5E5),
                  ),
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          // NOMBRE
          Text(
            mechanicName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          Text(
            "Mecánico Automotriz",
            style: TextStyle(fontSize: 14, color: Colors.blue[600]),
          ),

          const SizedBox(height: 20),

          // ⭐ MÉTRICAS
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            margin: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4FA),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.blue, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _metricBox(
                  Icons.access_time_rounded,
                  "${mechanic['experience'] ?? 0} años",
                  "Experiencia",
                ),
                Container(height: 35, width: 1, color: Colors.black12),
                _metricBox(Icons.groups_2_outlined, "1000", "Clientes"),
                Container(height: 35, width: 1, color: Colors.black12),
                _metricBox(Icons.star_border_outlined, "4.8", "Rating"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricBox(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.blue)),
      ],
    );
  }
}
