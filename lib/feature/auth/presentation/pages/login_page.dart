import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Inicia sesión",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            InputField(
              controller: emailCtrl,
              label: "Correo electrónico",
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            InputField(
              controller: passCtrl,
              label: "Contraseña",
              obscure: obscure,
              prefixIcon: Icons.lock_outline,
              suffixIcon: obscure ? Icons.visibility_off : Icons.visibility,
              onSuffixTap: () => setState(() => obscure = !obscure),
            ),
            const SizedBox(height: 24),

            AuthButton(
              text: "Iniciar sesión",
              loading: auth.isLoading,
              onPressed: () async {
                try {
                  await auth.login(emailCtrl.text, passCtrl.text);
                  if (context.mounted) {
                    context.go(AppRoutes.vehicleType); // ✅ ruta correcta
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
