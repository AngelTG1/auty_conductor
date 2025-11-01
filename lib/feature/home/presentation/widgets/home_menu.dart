import 'package:flutter/material.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.attach_money, 'label': 'Precio'},
      {'icon': Icons.star_outline, 'label': 'Puntos'},
      {'icon': Icons.access_time, 'label': 'Actividad'},
      {'icon': Icons.help_outline, 'label': 'Soporte'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((item) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              child: Column(
                children: [
                  Icon(item['icon'] as IconData, color: Colors.black54, size: 26),
                  const SizedBox(height: 6),
                  Text(
                    item['label'] as String,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
