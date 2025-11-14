import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

class SearchMechanicButton extends StatelessWidget {
  const SearchMechanicButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _showMechanicOptions(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF235EE8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Buscar mecánicos cercanos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on,
                color: Color(0xFF235EE8),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🧩 Modal inferior con opciones
  void _showMechanicOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildOption(
                  context,
                  icon: Icons.flash_on,
                  text: 'Mecánico express',
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.expressMechanic);
                  },
                ),
                const Divider(height: 0),
                _buildOption(
                  context,
                  icon: Icons.location_searching_outlined,
                  text: 'Buscar mecánicos cercanos',
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.locationMap);
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
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF235EE8)),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
