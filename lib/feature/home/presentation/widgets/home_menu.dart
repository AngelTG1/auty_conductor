import 'package:flutter/material.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // 🔹 Valores responsivos
    final double iconSize = width * 0.072; 
    final double fontSize = width * 0.028; 
    final double verticalPadding = width * 0.033;
    final double borderRadius = width * 0.03;

    final items = [
      {'icon': Icons.attach_money, 'label': 'Precio'},
      {'icon': Icons.control_point, 'label': 'Puntos'},
      {'icon': Icons.access_time, 'label': 'Actividad'},
      {'icon': Icons.help_outline, 'label': 'Soporte'},
    ];

    return Padding(
      padding: EdgeInsets.only(top: width * 0.045),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.01),
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: () => debugPrint('➡️ ${item['label']} presionado'),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFD9D9D9),
                      width: width * 0.003,
                    ),
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: const Color(0xFFF8F8F8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: const Color(0xFF494949),
                        size: iconSize,
                      ),

                      SizedBox(height: width * 0.015),

                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: const Color(0xFF494949),
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
