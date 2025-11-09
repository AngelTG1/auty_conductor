import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../providers/auth_provider.dart';
import 'terms_modal.dart';

class SocialLoginButtons extends StatelessWidget {
  SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Center(
      child: _buildSocialButton(
        iconUrl:
            'https://raw.githubusercontent.com/AngelTG1/imagenes-web/refs/heads/main/google.svg',
        onPressed: () async {
          try {
            // Revisar si el usuario ya aceptó términos
            final acceptedTerms = await SecureStorageService.read(
              'acceptedTerms',
            );

            if (acceptedTerms != 'true') {
              // Mostrar modal si aún no ha aceptado
              final accepted = await showTermsModal(context);
              if (!accepted) return; // No puede seguir si no acepta
            }

            // Si ya aceptó, iniciar sesión con Google
            await auth.loginWithGoogle(context);

            // Luego dirigirlo según su estado (vehículo, rol, etc.)
            await auth.checkHasVehicleAndNavigate(context);
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error al iniciar sesión con Google: $e'),
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
        height: 64,
        width: 185,
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
              ? SvgPicture.network(iconUrl, width: 26, height: 26)
              : Image.network(iconUrl, width: 26, height: 26),
        ),
      ),
    );
  }
}
