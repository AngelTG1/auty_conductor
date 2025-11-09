import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
    // ⏳ Esperar mientras se muestra la animación
    await Future.delayed(const Duration(seconds: 3));

    final token = await SecureStorageService.read('token');
    final driverUuid = await SecureStorageService.read('driverUuid');

    debugPrint('🔐 Token guardado: $token');
    debugPrint('🚗 DriverUuid guardado: $driverUuid');

    if (!mounted) return;

    if (token != null &&
        token.isNotEmpty &&
        driverUuid != null &&
        driverUuid.isNotEmpty) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🚗 Animación de Lottie
            Lottie.asset(
              'assets/animations/car_loading.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              'Cargando tu sesión...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
