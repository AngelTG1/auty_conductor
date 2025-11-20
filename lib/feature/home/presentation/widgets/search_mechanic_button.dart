import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

class SearchMechanicButton extends StatelessWidget {
  const SearchMechanicButton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // 🔹 Valores responsivos
    final double buttonFont = width * 0.033; // ~16px
    final double iconBox = width * 0.14; // ~54px
    final double iconSize = width * 0.07; // ~28px
    final double verticalPadding = width * 0.04;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showMechanicOptions(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF235EE8),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Buscar mecánicos cercanos',
                  style: TextStyle(
                    fontSize: buttonFont,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(width: width * 0.03),

            Container(
              height: iconBox,
              width: iconBox,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(width * 0.04),
              ),
              child: Icon(
                Icons.location_on,
                color: const Color(0xFF235EE8),
                size: iconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🧩 Modal inferior con opciones
  void _showMechanicOptions(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double tileFont = width * 0.042; // ~16px
    final double tileIconSize = width * 0.07;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: width * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildOption(
                  context,
                  icon: Icons.flash_on,
                  iconSize: tileIconSize,
                  fontSize: tileFont,
                  text: 'Mecánico express',
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.locationMap);
                  },
                ),
                const Divider(height: 0),
                _buildOption(
                  context,
                  icon: Icons.location_searching_outlined,
                  iconSize: tileIconSize,
                  fontSize: tileFont,
                  text: 'Buscar mecánicos cercanos',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 🔹 Estilo de opción dentro del modal
  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String text,
    required double fontSize,
    required double iconSize,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF235EE8), size: iconSize),
      title: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
