import 'package:flutter/material.dart';

/// 🔹 Mixin para prevenir errores de setState() después de dispose()
mixin SafeAsyncState<T extends StatefulWidget> on State<T> {
  /// Ejecuta una función async solo si el widget sigue montado
  Future<void> runSafe(Future<void> Function() action) async {
    if (!mounted) return;
    await action();
    if (!mounted) return;
    setState(() {});
  }

  /// Alternativa segura de setState()
  void safeSetState(VoidCallback fn) {
    if (mounted) setState(fn);
  }
}
