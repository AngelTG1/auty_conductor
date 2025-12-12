import 'package:flutter/material.dart';

mixin SafeAsyncState<T extends StatefulWidget> on State<T> {

  Future<void> runSafe(Future<void> Function() action) async {
    if (!mounted) return;
    await action();
    if (!mounted) return;
    setState(() {});
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) setState(fn);
  }
}
