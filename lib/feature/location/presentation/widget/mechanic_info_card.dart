import 'package:flutter/material.dart';

class MechanicInfoCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String? address;

  const MechanicInfoCard({
    super.key,
    required this.data,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Título en español
          const Text(
            "Horario y Ubicación",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 18),

          // 🔹 Secciones
          _infoSection([
            _infoItem(Icons.calendar_today_outlined, "Días", "Lunes - Viernes"),
            _infoItem(Icons.access_time, "Horario", "10:00 AM - 6:00 PM"),
            _infoItem(
              Icons.engineering_outlined,
              "Servicios",
              "Mecánica general",
            ),
            _infoItem(
              Icons.location_on_outlined,
              "Dirección",
              address ?? "Cargando dirección...",
            ),
          ]),

          const SizedBox(height: 20),

          // 🔹 Última actualización
          Text(
            "Última actualización: ${data['timestamp'].toString().substring(0, 10)}",
            style: const TextStyle(color: Colors.black45, fontSize: 12.5),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Contenedor de las secciones
  // -------------------------------------------------------------
  Widget _infoSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                color: Colors.black12.withOpacity(0.06),
              ),
          ],
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Ítem individual
  // -------------------------------------------------------------
  Widget _infoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black54),

          const SizedBox(width: 6),

          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),

          const Spacer(),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
