import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/input_field.dart';
import '../widgets/social_login_buttons.dart';

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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Encabezado
              const Row(
                children: [
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
              const SizedBox(height: 12),

              // 🔹 Campos de formulario con errores dinámicos
              InputField(
                controller: nameCtrl,
                label: 'Nombre',
                prefixIcon: Icons.person_outline,
                errorText: auth.nameError,
              ),
              InputField(
                controller: phoneCtrl,
                label: 'Teléfono',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_iphone_outlined,
                errorText: auth.phoneError,
              ),
              InputField(
                controller: emailCtrl,
                label: 'Correo',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline,
                errorText: auth.emailError,
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
                errorText: auth.passwordError,
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
                errorText: auth.confirmError,
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

              // 🔹 Checkbox de rol
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

              const SizedBox(height: 8),

              // 🔹 Botón principal
              AuthButton(
                text: 'Registrarme',
                loading: auth.isLoading,
                onPressed: (!acceptedTerms)
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

                        await auth.register(
                          context: context,
                          name: nameCtrl.text.trim(),
                          phone: phoneCtrl.text.trim(),
                          email: emailCtrl.text.trim(),
                          password: passCtrl.text.trim(),
                          isDriver: isDriver,
                        );
                      },
              ),

              const SizedBox(height: 25),

              // 🔹 Divider de métodos alternativos
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

              SocialLoginButtons(),

              const SizedBox(height: 28),

              // 🔹 Navegación a Login
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
