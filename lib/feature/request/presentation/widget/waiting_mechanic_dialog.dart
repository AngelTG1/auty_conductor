import 'dart:async';
import 'package:flutter/material.dart';

class WaitingMechanicDialog extends StatefulWidget {
  final VoidCallback onTimeOut;
  final VoidCallback onAutoRejected; // 👈 NUEVO

  const WaitingMechanicDialog({
    super.key,
    required this.onTimeOut,
    required this.onAutoRejected, // 👈 NUEVO
  });

  @override
  WaitingMechanicDialogState createState() => WaitingMechanicDialogState();
}

class WaitingMechanicDialogState extends State<WaitingMechanicDialog> {
  int seconds = 15;
  Timer? _timer;

  String statusMessage = "Esperando que el mecánico acepte...";
  bool finished = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (finished) return;

      if (seconds == 0) {
        t.cancel();
        if (mounted) Navigator.pop(context);

        widget.onAutoRejected(); // 🔥 Aquí avisamos que fue rechazado auto

        return;
      }

      setState(() => seconds--);
    });
  }

  void acceptRequest() {
    if (finished) return;

    setState(() {
      finished = true;
      statusMessage = "Solicitud aceptada ✔";
    });

    _timer?.cancel();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  void rejectRequest() {
    if (finished) return;

    setState(() {
      finished = true;
      statusMessage = "Solicitud rechazada ✖";
    });

    _timer?.cancel();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!finished)
              Text(
                "Tiempo restante: $seconds s",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF235FE8),
                ),
              ),

            if (!finished) const SizedBox(height: 20),
            if (!finished)
              const CircularProgressIndicator(color: Color(0xFF235FE8)),

            const SizedBox(height: 20),

            Text(
              statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
