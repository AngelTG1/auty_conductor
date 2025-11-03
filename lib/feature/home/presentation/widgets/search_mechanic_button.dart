import 'package:flutter/material.dart';

class SearchMechanicButton extends StatelessWidget {
  const SearchMechanicButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea( 
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          children: [
            // 🔹 Botón principal (azul)
            Expanded(
              child: ElevatedButton(
                onPressed: onPressed ?? () {},
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // 🔹 Botón de ícono (gris claro)
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
}
