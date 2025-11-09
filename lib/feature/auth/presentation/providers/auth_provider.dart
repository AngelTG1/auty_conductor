import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/router/app_routes.dart';
import 'package:auty_conductor/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:auty_conductor/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:auty_conductor/feature/auth/domain/entities/auth_entity.dart';
import 'package:auty_conductor/feature/auth/domain/usecases/login_usecase.dart';
import 'package:auty_conductor/feature/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:auty_conductor/feature/auth/domain/usecases/register_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepositoryImpl _repository = AuthRepositoryImpl(
    AuthRemoteDataSource(),
  );

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  late final LoginUseCase _loginUseCase = LoginUseCase(_repository);
  late final RegisterUseCase _registerUseCase = RegisterUseCase(_repository);
  late final LoginWithGoogleUseCase _googleUseCase = LoginWithGoogleUseCase(
    _repository,
  );

  AuthEntity? user;
  bool isLoading = false;

  // 🔹 Variables para mostrar errores bajo los inputs
  String? emailError;
  String? passwordError;
  String? nameError;
  String? phoneError;
  String? confirmError;

  // 🔹 Limpia errores
  void clearErrors() {
    emailError = null;
    passwordError = null;
    nameError = null;
    phoneError = null;
    confirmError = null;
    notifyListeners();
  }

  // 🔹 Login normal con validaciones visuales
  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    clearErrors(); // ✅ Limpia errores previos
    isLoading = true;
    notifyListeners();

    // --- Validaciones locales ---
    if (email.isEmpty) {
      emailError = 'El correo es obligatorio';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emailError = 'Formato de correo inválido';
    }

    if (password.isEmpty) {
      passwordError = 'La contraseña es obligatoria';
    } else if (password.length < 8) {
      passwordError = 'Debe tener al menos 8 caracteres';
    }

    if (emailError != null || passwordError != null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    // --- Lógica de autenticación ---
    try {
      final authUser = await _loginUseCase.call(email, password);
      await _saveSession(authUser);
      await checkHasVehicleAndNavigate(context);
    } catch (e) {
      debugPrint('⚠️ Error en login: $e');
      passwordError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Registro normal con validaciones visuales
  Future<void> register({
    required BuildContext context,
    required String name,
    required String phone,
    required String email,
    required String password,
    required bool isDriver,
  }) async {
    clearErrors();
    isLoading = true;
    notifyListeners();

    // --- Validaciones locales ---
    if (name.isEmpty || !RegExp(r'^[A-Za-zÁÉÍÓÚáéíóúÑñ ]+$').hasMatch(name)) {
      nameError = 'El nombre solo debe contener letras y espacios';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      phoneError = 'El teléfono debe tener exactamente 10 dígitos';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emailError = 'Formato de correo inválido';
    }
    if (!RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$',
    ).hasMatch(password)) {
      passwordError =
          'Debe tener mayúscula, minúscula, número y mínimo 8 caracteres';
    }

    if (nameError != null ||
        phoneError != null ||
        emailError != null ||
        passwordError != null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    // --- Lógica de registro ---
    try {
      final newUser = await _registerUseCase.call(
        name: name,
        phone: phone,
        email: email,
        password: password,
        isDriver: isDriver,
      );
      await _saveSession(newUser);
      await checkHasVehicleAndNavigate(context);
    } catch (e) {
      debugPrint('⚠️ Error al registrar: $e');
      emailError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Login con Google (solo si ya aceptó términos)
  Future<void> loginWithGoogle(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final accepted = await SecureStorageService.read('acceptedTerms');
      if (accepted != 'true') {
        debugPrint('⚠️ Usuario no ha aceptado los términos.');
        if (context.mounted) {
          context.go(AppRoutes.terms);
        }
        return;
      }

      await _googleSignIn.signOut();
      final authUser = await _googleUseCase.call();
      await _saveSession(authUser);
      await checkHasVehicleAndNavigate(context);
    } catch (e) {
      debugPrint('⚠️ Error en login con Google: $e');
      passwordError = 'Error al iniciar sesión con Google';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Guardar sesión localmente
  Future<void> _saveSession(AuthEntity authUser) async {
    user = authUser;
    await SecureStorageService.write('token', authUser.token);
    await SecureStorageService.write('userUuid', authUser.uuid);
    await SecureStorageService.write('driverUuid', authUser.driverUuid);
    await SecureStorageService.write('userName', authUser.name);
    await SecureStorageService.write('userPhone', authUser.phone);
    await SecureStorageService.write('userEmail', authUser.email);
    await SecureStorageService.write('userLicense', authUser.licenseNumber);
  }

  // 🔹 Verificar si tiene vehículo o necesita confirmar rol
  Future<void> checkHasVehicleAndNavigate(BuildContext context) async {
    final driverUuid = await SecureStorageService.read('driverUuid');
    final token = await SecureStorageService.read('token');
    final userUuid = await SecureStorageService.read('userUuid');

    if (token == null || token.isEmpty) {
      debugPrint('⚠️ No se encontró token. Regresando al login.');
      if (context.mounted) context.go(AppRoutes.login);
      return;
    }

    if (driverUuid == null || driverUuid.isEmpty) {
      debugPrint('🚗 Usuario nuevo → redirigiendo a SelectRolePage');
      if (context.mounted) {
        context.go('${AppRoutes.selectRole}?uuid=$userUuid');
      }
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          'https://backauty-production.up.railway.app/API/v1/vehicles/has/$driverUuid',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final hasVehicle = data['hasVehicle'] == true;

        if (context.mounted) {
          if (hasVehicle) {
            context.go(AppRoutes.home);
          } else {
            context.go(AppRoutes.vehicleType);
          }
        }
      } else {
        if (context.mounted) context.go(AppRoutes.vehicleType);
      }
    } catch (e) {
      debugPrint('❌ Error al verificar vehículo: $e');
      if (context.mounted) context.go(AppRoutes.vehicleType);
    }
  }

  // 🔹 Cerrar sesión
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await SecureStorageService.clear();
    user = null;
    notifyListeners();
  }
}
