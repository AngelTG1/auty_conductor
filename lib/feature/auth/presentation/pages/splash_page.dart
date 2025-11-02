import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/services/secure_storage_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _verifySession();
  }

  Future<void> _verifySession() async {
    // Esperar a que secure storage inicialice
    await Future.delayed(const Duration(milliseconds: 800));

    final token = await SecureStorageService.read('token');
    final driverUuid = await SecureStorageService.read('driverUuid');

    debugPrint('🔐 Token guardado: $token');
    debugPrint('🚗 DriverUuid guardado: $driverUuid');

    // Espera a que el contexto esté montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (token != null && token.isNotEmpty && driverUuid != null && driverUuid.isNotEmpty) {
        context.go(AppRoutes.home);
      } else {
        context.go(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car, color: Colors.blue, size: 80),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
