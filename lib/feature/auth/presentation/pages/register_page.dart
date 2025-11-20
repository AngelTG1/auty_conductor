import 'package:auty_conductor/feature/auth/presentation/widgets/social_login_buttons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/input_field.dart';

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

  // -------------------------------
  //      TEXTOS ESTÁTICOS
  // -------------------------------
  static const Widget _title = Row(
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
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),

        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 60),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title,
              const SizedBox(height: 30),

              // ---------------------------------
              // CAMPOS CON SELECTOR (OPTIMIZADOS)
              // ---------------------------------
              Selector<AuthProvider, String?>(
                selector: (_, p) => p.nameError,
                builder: (_, error, __) => InputField(
                  controller: nameCtrl,
                  label: 'Nombre',
                  prefixIcon: Icons.person_outline,
                  errorText: error,
                ),
              ),
              const SizedBox(height: 16),

              Selector<AuthProvider, String?>(
                selector: (_, p) => p.phoneError,
                builder: (_, error, __) => InputField(
                  controller: phoneCtrl,
                  label: 'Teléfono',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_iphone_outlined,
                  errorText: error,
                ),
              ),
              const SizedBox(height: 16),

              Selector<AuthProvider, String?>(
                selector: (_, p) => p.emailError,
                builder: (_, error, __) => InputField(
                  controller: emailCtrl,
                  label: 'Correo',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline,
                  errorText: error,
                ),
              ),
              const SizedBox(height: 16),

              Selector<AuthProvider, String?>(
                selector: (_, p) => p.passwordError,
                builder: (_, error, __) => InputField(
                  controller: passCtrl,
                  label: 'Contraseña',
                  obscure: obscurePass,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: obscurePass
                      ? Icons.visibility_off
                      : Icons.visibility,
                  onSuffixTap: () => setState(() => obscurePass = !obscurePass),
                  errorText: error,
                ),
              ),
              const SizedBox(height: 16),

              Selector<AuthProvider, String?>(
                selector: (_, p) => p.confirmError,
                builder: (_, error, __) => InputField(
                  controller: confirmCtrl,
                  label: 'Confirmar contraseña',
                  obscure: obscureConfirm,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: obscureConfirm
                      ? Icons.visibility_off
                      : Icons.visibility,
                  onSuffixTap: () =>
                      setState(() => obscureConfirm = !obscureConfirm),
                  errorText: error,
                ),
              ),

              const SizedBox(height: 10),
              _termsCheckbox(),
              _driverCheckbox(),

              const SizedBox(height: 15),

              // ---------------------------------
              // BOTÓN REGISTRO REACTIVO
              // ---------------------------------
              Selector<AuthProvider, bool>(
                selector: (_, p) => p.isLoading,
                builder: (_, loading, __) => AuthButton(
                  text: "Registrarme",
                  loading: loading,
                  onPressed: acceptedTerms ? () => _onRegister(context) : null,
                ),
              ),

              const SizedBox(height: 25),
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
              _loginRedirect(context),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------
  //       WIDGETS REUTILIZABLES
  // -------------------------------
  Widget _termsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: acceptedTerms,
          onChanged: (v) => setState(() => acceptedTerms = v ?? false),
          shape: const CircleBorder(),
          activeColor: const Color(0xFF1E329D),
        ),
        Expanded(
          child: RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 13, color: Colors.black54),
              children: [
                TextSpan(text: "He leído y acepto los "),
                TextSpan(
                  text: "Términos y Condiciones",
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: " y "),
                TextSpan(
                  text: "Aviso de Privacidad",
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
    );
  }

  Widget _driverCheckbox() {
    final width = MediaQuery.of(context).size.width;
    final double fontSize = width * 0.035; // ~15px en un móvil estándar

    return Row(
      children: [
        Checkbox(
          value: isDriver,
          onChanged: (v) => setState(() => isDriver = v ?? false),
          shape: const CircleBorder(),
          activeColor: const Color(0xFF1E329D),
        ),
        Text(
          "Soy conductor",
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _loginRedirect(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Escala controlada
    final double fontSize = width * 0.035; // ~15px en un móvil estándar

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "¿Ya tienes una cuenta?",
          style: TextStyle(
            color: const Color(0xFF6C6C6C),
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () => context.go(AppRoutes.login),
          child: Text(
            " Inicia sesión",
            style: TextStyle(
              color: const Color(0xFF1E329D),
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------------
  //             REGISTRO
  // -------------------------------
  Future<void> _onRegister(BuildContext context) async {
    if (passCtrl.text != confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Las contraseñas no coinciden'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();

    await auth.register(
      context: context,
      name: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passCtrl.text.trim(),
      isDriver: isDriver,
    );
  }
}
