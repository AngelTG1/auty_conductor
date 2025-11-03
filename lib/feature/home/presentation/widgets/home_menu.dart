import 'package:flutter/material.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.attach_money, 'label': 'Precio'},
      {'icon': Icons.control_point, 'label': 'Puntos'},
      {'icon': Icons.access_time, 'label': 'Actividad'},
      {'icon': Icons.help_outline, 'label': 'Soporte'},
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // 🚀 Aquí pondrás tu navegación más adelante, ejemplo:
                  // context.go(AppRoutes.price);
                  debugPrint('➡️ ${item['label']} presionado');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFD9D9D9), width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFF8F8F8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: Color(0xFF494949),
                        size: 28,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['label'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF494949),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
