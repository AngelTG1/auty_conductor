import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/auth_provider.dart';
import '../pages/select_role_page.dart'; // ✅ Para redirigir si no tiene rol
import '../../../../core/services/secure_storage_service.dart'; // ✅ Para leer tokens y datos locales

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Center(
      child: _buildSocialButton(
        iconUrl:
            'https://raw.githubusercontent.com/AngelTG1/imagenes-web/refs/heads/main/google.svg',
        onPressed: () async {
          try {
            await auth.loginWithGoogle();

            if (!context.mounted) return;

            // 🔹 Verifica si ya tiene driverUuid guardado
            final storedDriverUuid = await SecureStorageService.read(
              'driverUuid',
            );
            final isDriverFlag = await SecureStorageService.read('isDriver');

            // 🔹 Espera un frame antes de navegar
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if ((isDriverFlag == null || isDriverFlag == 'false') &&
                  (storedDriverUuid == null || storedDriverUuid.isEmpty)) {
                // 🧭 Si aún no tiene rol => ir a SelectRolePage
                context.pushReplacement(
                  '/select-role',
                  extra:
                      auth.user!.uuid, // ✅ Pasamos el UUID al selector de rol
                );
              } else {
                // 🚗 Si ya tiene rol => ir directamente al flujo de conductor
                context.go(AppRoutes.vehicleType);
              }
            });
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Error al iniciar sesión con Google: $e',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildSocialButton({
    required String iconUrl,
    required VoidCallback onPressed,
  }) {
    final isSvg = iconUrl.toLowerCase().endsWith('.svg');

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 64, // 🔹 Más pequeño (antes era 64)
        width: 185, // 🔹 No ocupa todo el ancho
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: isSvg
              ? SvgPicture.network(
                  iconUrl,
                  width: 26, // 🔹 Ícono más chico
                  height: 26,
                  placeholderBuilder: (context) => const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Image.network(
                  iconUrl,
                  width: 26,
                  height: 26,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                  ),
                ),
        ),
      ),
    );
  }
}
