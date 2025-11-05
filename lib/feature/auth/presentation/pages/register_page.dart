import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/input_field.dart';
import '../widgets/social_login_buttons.dart'; // ✅ Botones Google/Facebook

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool obscurePass = true;
  bool obscureConfirm = true;
  bool acceptedTerms = false;
  bool isDriver = false;

  bool get _isFormValid {
    return acceptedTerms &&
        isDriver &&
        nameCtrl.text.isNotEmpty &&
        phoneCtrl.text.isNotEmpty &&
        emailCtrl.text.isNotEmpty &&
        passCtrl.text.isNotEmpty &&
        confirmCtrl.text.isNotEmpty &&
        passCtrl.text == confirmCtrl.text;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,

      // 👇 NUEVO: GestureDetector para cerrar teclado
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Encabezado
              Row(
                children: const [
                  Text(
                    "Regístrate en ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Auty",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E329D),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),

              // 🔹 Campos
              InputField(
                controller: nameCtrl,
                label: 'Nombre',
                prefixIcon: Icons.person_outline,
              ),
              InputField(
                controller: phoneCtrl,
                label: 'Teléfono',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_iphone_outlined,
              ),
              InputField(
                controller: emailCtrl,
                label: 'Correo',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline,
              ),
              InputField(
                controller: passCtrl,
                label: 'Contraseña',
                obscure: obscurePass,
                prefixIcon: Icons.lock_outline,
                suffixIcon: obscurePass
                    ? Icons.visibility
                    : Icons.visibility_off,
                onSuffixTap: () => setState(() => obscurePass = !obscurePass),
              ),
              InputField(
                controller: confirmCtrl,
                label: 'Confirmar contraseña',
                obscure: obscureConfirm,
                prefixIcon: Icons.lock_outline,
                suffixIcon: obscureConfirm
                    ? Icons.visibility
                    : Icons.visibility_off,
                onSuffixTap: () =>
                    setState(() => obscureConfirm = !obscureConfirm),
              ),

              const SizedBox(height: 10),

              // 🔹 Checkbox de términos
              Row(
                children: [
                  Checkbox(
                    value: acceptedTerms,
                    onChanged: (v) =>
                        setState(() => acceptedTerms = v ?? false),
                    shape: const CircleBorder(),
                    activeColor: const Color(0xFF1E329D),
                  ),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          height: 1.3,
                        ),
                        children: [
                          TextSpan(text: "He leído y acepto los "),
                          TextSpan(
                            text: "Términos y Condiciones ",
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: "y "),
                          TextSpan(
                            text: "Avisos de Privacidad",
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 🔹 Checkbox de conductor
              Row(
                children: [
                  Checkbox(
                    value: isDriver,
                    onChanged: (v) => setState(() => isDriver = v ?? false),
                    shape: const CircleBorder(),
                    activeColor: const Color(0xFF1E329D),
                  ),
                  const Text(
                    'Soy mecánico',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // 🔹 Botón de registro
              AuthButton(
                text: 'Iniciar sesión',
                loading: auth.isLoading,
                onPressed: !_isFormValid
                    ? null
                    : () async {
                        if (passCtrl.text != confirmCtrl.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('⚠️ Las contraseñas no coinciden'),
                              backgroundColor: Colors.orangeAccent,
                            ),
                          );
                          return;
                        }

                        try {
                          await auth.register(
                            name: nameCtrl.text.trim(),
                            phone: phoneCtrl.text.trim(),
                            email: emailCtrl.text.trim(),
                            password: passCtrl.text.trim(),
                            isDriver: isDriver,
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Registro exitoso'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            context.go(AppRoutes.login);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      },
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "O regístrate con",
                  style: TextStyle(
                    color: Color(0xFF6C6C6C),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [SizedBox(width: 300, child: SocialLoginButtons())],
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "¿Ya tienes una cuenta? ",
                    style: TextStyle(
                      color: Color(0xFF6C6C6C),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.login),
                    child: const Text(
                      "Inicia sesión",
                      style: TextStyle(
                        color: Color(0xFF1E329D),
                        fontSize: 15,
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
    );
  }
}
