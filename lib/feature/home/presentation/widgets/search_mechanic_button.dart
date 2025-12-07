import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

class SearchMechanicButton extends StatelessWidget {
  const SearchMechanicButton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final double buttonFont = width * 0.033;
    final double verticalPadding = width * 0.04;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // 🚀 Navegación directa SIN modal
                  context.push(AppRoutes.locationMap);
                },
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
          ],
        ),
      ),
    );
  }
}
