import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MechanicBottomButton extends StatelessWidget {
  final String mechanicUuid;

  const MechanicBottomButton({super.key, required this.mechanicUuid});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(left: 20, right: 20, bottom: 60, top: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            context.push(
              "/express-mechanic",
              extra: {"mechanicUuid": mechanicUuid},
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF235EE8),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            "Solicitar mecánico",
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
