import 'package:auty_conductor/feature/auth/presentation/widgets/social_login_buttons.dart';
import 'package:flutter/gestures.dart';
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
  bool acceptedTerms = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                const Text(
                  "Auty",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E329D),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Inicia sesión en tu cuenta",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF393938),
                  ),
                ),
                const SizedBox(height: 40),

                // 🔹 Campos de entrada
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

                const SizedBox(height: 20),

                // 🔹 Checkbox de términos
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 1.3,
                      child: Checkbox(
                        value: acceptedTerms,
                        onChanged: (value) =>
                            setState(() => acceptedTerms = value ?? false),
                        shape: const CircleBorder(),
                        side: const BorderSide(
                          color: Color(0xFFBDBDBD),
                          width: 2,
                        ),
                        activeColor: const Color(0xFF1E329D),
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFACACAC),
                          ),
                          children: [
                            const TextSpan(text: "He leído y acepto los "),
                            TextSpan(
                              text: "Términos y Condiciones",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Aquí podrías abrir una página de términos
                                },
                            ),
                            const TextSpan(text: " y "),
                            TextSpan(
                              text: "Aviso de Privacidad",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Aquí podrías abrir aviso de privacidad
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 🔹 Botón de login
                AuthButton(
                  text: "Iniciar sesión",
                  loading: auth.isLoading,
                  onPressed:
                      (emailCtrl.text.isEmpty ||
                          passCtrl.text.isEmpty ||
                          !acceptedTerms)
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();

                          if (!acceptedTerms) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Debes aceptar los Términos y Condiciones para continuar',
                                ),
                              ),
                            );
                            return;
                          }

                          try {
                            await auth.login(emailCtrl.text, passCtrl.text);
                            if (context.mounted) {
                              context.go(AppRoutes.vehicleType);
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                ),

                const SizedBox(height: 32),

                const Text(
                  "O inicia sesión con",
                  style: TextStyle(
                    color: Color(0xFF6C6C6C),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),

                const SocialLoginButtons(),
                const SizedBox(height: 27),

                // 🔹 Navegación al registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "¿No tienes una cuenta? ",
                      style: TextStyle(
                        color: Color(0xFF6C6C6C),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push(
                          AppRoutes.register,
                        ); // ✅ Redirige al registro
                      },
                      child: const Text(
                        "Crea una",
                        style: TextStyle(
                          color: Color(0xFF1E329D),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
