import 'package:flutter/material.dart';

class HistoryEmpty extends StatelessWidget {
  const HistoryEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(
      context,
    ).size.width; // 🔹 Ancho total de pantalla

    return Container(
      width: width,
      height: MediaQuery.of(context).size.height * 0.38,

      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.public_outlined, size: 50, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            'Historial Vacío',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
