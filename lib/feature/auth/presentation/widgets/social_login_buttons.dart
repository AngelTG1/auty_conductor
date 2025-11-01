import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            iconUrl:
                'https://raw.githubusercontent.com/AngelTG1/imagenes-web/refs/heads/main/google.svg', // PNG
            onPressed: () {
              // Acción Google
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSocialButton(
            iconUrl:
                'https://raw.githubusercontent.com/AngelTG1/imagenes-web/refs/heads/main/facebook.svg', // SVG
            onPressed: () {
              // Acción Facebook
            },
          ),
        ),
      ],
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isSvg
              ? SvgPicture.network(
                  iconUrl,
                  width: 32,
                  height: 32,
                  placeholderBuilder: (context) => const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Image.network(
                  iconUrl,
                  width: 32,
                  height: 32,
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
