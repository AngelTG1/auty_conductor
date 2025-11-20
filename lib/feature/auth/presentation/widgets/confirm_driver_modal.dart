import 'package:flutter/material.dart';

Future<bool> showConfirmDriverModal(BuildContext context) async {
  bool accepted = false;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 5,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const Text(
              "Confirmar que eres Conductor",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            const Text(
              "Para usar Auty, debes confirmar que usarás la app como "
              "CONDUCTOR.\n\n"
              "Esto solo debes hacerlo una vez.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 26),

            ElevatedButton(
              onPressed: () {
                accepted = true;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E329D),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Confirmar y continuar",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );

  return accepted;
}
