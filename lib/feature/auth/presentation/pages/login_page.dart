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
    final size = MediaQuery.of(context).size;

    final double titleSize = size.width * 0.09; // ~36
    final double subtitleSize = size.width * 0.045; // ~20
    final double sectionSpacing = size.height * 0.03;
    final double fieldSpacing = size.height * 0.03;
    final double socialTitleSize = size.width * 0.030;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: size.height * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.10),

              // ========================
              //        TITULOS
              // ========================
              Text(
                "Auty",
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E329D),
                ),
              ),

              SizedBox(height: size.height * 0.02),

              Text(
                "Inicia sesión en tu cuenta",
                style: TextStyle(
                  fontSize: subtitleSize,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF393938),
                ),
              ),

              SizedBox(height: sectionSpacing),

              // ============================
              //      CORREO
              // ============================
              Selector<AuthProvider, String?>(
                selector: (_, provider) => provider.emailError,
                builder: (_, emailError, __) => InputField(
                  controller: emailCtrl,
                  label: "Correo electrónico",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  errorText: emailError,
                ),
              ),

              SizedBox(height: fieldSpacing),

              // ============================
              //      CONTRASEÑA
              // ============================
              Selector<AuthProvider, String?>(
                selector: (_, p) => p.passwordError,
                builder: (_, passError, __) => InputField(
                  controller: passCtrl,
                  label: "Contraseña",
                  obscure: obscure,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: obscure ? Icons.visibility_off : Icons.visibility,
                  onSuffixTap: () => setState(() => obscure = !obscure),
                  errorText: passError,
                ),
              ),

              SizedBox(height: fieldSpacing),

              _terms(size),

              SizedBox(height: size.height * 0.03),

              // ============================
              //      BOTÓN LOGIN
              // ============================
              Selector<AuthProvider, bool>(
                selector: (_, p) => p.isLoading,
                builder: (_, loading, __) {
                  final disabled =
                      emailCtrl.text.isEmpty ||
                      passCtrl.text.isEmpty ||
                      !acceptedTerms;

                  return AuthButton(
                    text: "Iniciar sesión",
                    loading: loading,
                    onPressed: disabled ? null : () => _handleLogin(context),
                  );
                },
              ),

              SizedBox(height: size.height * 0.04),

              Text(
                "O inicia sesión con",
                style: TextStyle(
                  color: const Color(0xFF6C6C6C),
                  fontWeight: FontWeight.w600,
                  fontSize: socialTitleSize,
                ),
              ),

              SizedBox(height: size.height * 0.03),

              SocialLoginButtons(),

              SizedBox(height: size.height * 0.03),

              _registerText(context, size),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  //   TÉRMINOS RESPONSIVE
  // =====================================================

  Widget _terms(Size size) {
    final double termsFontSize = size.width * 0.030;

    // 🔹 Tamaño del checkbox ajustado pero NO gigante
    final double checkboxSize = size.width * 0.055; // ~18–22px
    final double iconSize = checkboxSize * 0.6;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: checkboxSize,
          height: checkboxSize,
          child: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: acceptedTerms,
              onChanged: (value) =>
                  setState(() => acceptedTerms = value ?? false),

              shape: const CircleBorder(),
              side: const BorderSide(color: Color(0xFFBDBDBD), width: 2),
              activeColor: const Color(0xFF1E329D),

              // 🔹 Hace que no se vea tan grande sin romper accesibilidad
              visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            ),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: termsFontSize,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFACACAC),
              ),
              children: [
                const TextSpan(text: "He leído y acepto los "),
                _link("Términos y Condiciones", termsFontSize),
                const TextSpan(text: " y "),
                _link("Aviso de Privacidad", termsFontSize),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TextSpan _link(String text, double fontSize) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()..onTap = () {},
    );
  }

  // =====================================================
  //   REGISTRARSE RESPONSIVE
  // =====================================================

  Widget _registerText(BuildContext context, Size size) {
    final double fontSize = size.width * 0.035;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "¿No tienes una cuenta? ",
          style: TextStyle(
            color: const Color(0xFF6C6C6C),
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () => context.push(AppRoutes.register),
          child: Text(
            "Crea una",
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

  // =====================================================
  //                 LOGIN
  // =====================================================

  Future<void> _handleLogin(BuildContext context) async {
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

    final auth = context.read<AuthProvider>();

    try {
      await auth.login(context, emailCtrl.text.trim(), passCtrl.text.trim());
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
