import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/http/api_constants.dart';
import '../providers/auth_provider.dart';
import 'confirm_driver_modal.dart';
import 'terms_modal.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: _googleButton(
            context: context,
            onPressed: () async {
              try {
                // Términos
                final acceptedTerms =
                    await SecureStorageService.read('acceptedTerms') == 'true';

                if (!acceptedTerms) {
                  final accepted = await showTermsModal(context);
                  if (!accepted) return;
                  await SecureStorageService.write('acceptedTerms', 'true');
                }

                // Confirmar rol
                final acceptedDriver =
                    await SecureStorageService.read('acceptedDriverRole') ==
                    'true';

                if (!acceptedDriver) {
                  final confirmed = await showConfirmDriverModal(context);
                  if (!confirmed) return;
                  await SecureStorageService.write(
                    'acceptedDriverRole',
                    'true',
                  );
                }

                // Google Login
                final authUser = await auth.loginWithGoogle(context);

                final savedDriverUuid = await SecureStorageService.read(
                  'driverUuid',
                );

                if (savedDriverUuid == null || savedDriverUuid.isEmpty) {
                  final url = Uri.parse('${ApiConstants.auth}/set-role');

                  final response = await http.post(
                    url,
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({'uuid': authUser.uuid, 'isDriver': true}),
                  );

                  if (response.statusCode == 200) {
                    final data = jsonDecode(response.body);
                    await SecureStorageService.write(
                      'driverUuid',
                      data['driver']['uuid'],
                    );
                  }
                }

                await auth.checkHasVehicleAndNavigate(context);
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $e'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _googleButton({
    required BuildContext context,
    required VoidCallback onPressed,
  }) {
    final size = MediaQuery.of(context).size;

    final double width = size.width * 0.45;
    final double height = size.height * 0.07;
    final double iconSize = size.width * 0.07;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width.clamp(140, 240),
        height: height.clamp(48, 65),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.03),
          border: Border.all(color: const Color(0xFFE1E1E1)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: SvgPicture.network(
          'https://raw.githubusercontent.com/AngelTG1/imagenes-web/refs/heads/main/google.svg',
          width: iconSize,
          height: iconSize,
        ),
      ),
    );
  }
}
