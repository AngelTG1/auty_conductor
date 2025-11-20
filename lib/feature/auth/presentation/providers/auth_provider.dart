import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/router/app_routes.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

import 'package:provider/provider.dart';
import '../../../../core/ws/ws_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepositoryImpl _repository = AuthRepositoryImpl(
    AuthRemoteDataSource(),
  );

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  late final LoginUseCase _loginUseCase = LoginUseCase(_repository);
  late final RegisterUseCase _registerUseCase = RegisterUseCase(_repository);
  late final LoginWithGoogleUseCase _googleUseCase = LoginWithGoogleUseCase(
    _repository,
  );

  AuthEntity? user;
  bool isLoading = false;

  String? emailError;
  String? passwordError;
  String? nameError;
  String? phoneError;
  String? confirmError;

  void clearErrors() {
    emailError = null;
    passwordError = null;
    nameError = null;
    phoneError = null;
    confirmError = null;
    notifyListeners();
  }

  // ========================================================
  // 🔐 LOGIN NORMAL
  // ========================================================
  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    clearErrors();
    isLoading = true;
    notifyListeners();

    if (email.isEmpty) emailError = 'Correo requerido';
    if (password.isEmpty) passwordError = 'Contraseña requerida';

    if (emailError != null || passwordError != null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final authUser = await _loginUseCase.call(email, password);
      await _saveSession(authUser);

      // 🔥 Conectar WebSocket automáticamente
      final ws = Provider.of<WsService>(context, listen: false);
      ws.connect(authUser.driverUuid);

      await checkHasVehicleAndNavigate(context);
    } catch (e) {
      passwordError = e.toString().replaceAll("Exception: ", "");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ========================================================
  // 🔐 LOGIN CON GOOGLE
  // ========================================================
  Future<AuthEntity> loginWithGoogle(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("Cancelado por el usuario");
      }

      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw Exception("idToken nulo — revisa SHA1 en Firebase");
      }

      final authUser = await _googleUseCase.call();
      await _saveSession(authUser);

      // 🔥 Conectar WebSocket automáticamente
      final ws = Provider.of<WsService>(context, listen: false);
      ws.connect(authUser.driverUuid);

      return authUser;
    } catch (e, stack) {
      debugPrint("🔥 ERROR GOOGLE LOGIN:");
      debugPrint(e.toString());
      debugPrint(stack.toString());
      throw Exception(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ========================================================
  // 🔐 REGISTRO NORMAL
  // ========================================================
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

    try {
      final newUser = await _registerUseCase.call(
        name: name,
        phone: phone,
        email: email,
        password: password,
        isDriver: isDriver,
      );

      await _saveSession(newUser);

      // 🔥 WebSocket opcional aquí si quieres
      final ws = Provider.of<WsService>(context, listen: false);
      ws.connect(newUser.driverUuid);

      await checkHasVehicleAndNavigate(context);
    } catch (e) {
      emailError = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ========================================================
  // 💾 GUARDAR SESIÓN
  // ========================================================
  Future<void> _saveSession(AuthEntity authUser) async {
    user = authUser;

    await SecureStorageService.write('token', authUser.token);
    await SecureStorageService.write('userUuid', authUser.uuid);
    await SecureStorageService.write('driverUuid', authUser.driverUuid);
    await SecureStorageService.write('userName', authUser.name);
    await SecureStorageService.write('userEmail', authUser.email);
    await SecureStorageService.write('userPhone', authUser.phone);
    await SecureStorageService.write('licenseNumber', authUser.licenseNumber);
  }

  // ========================================================
  // 🚗 NAVEGACIÓN SEGÚN SI TIENE VEHÍCULO
  // ========================================================
  Future<void> checkHasVehicleAndNavigate(BuildContext context) async {
    final token = await SecureStorageService.read("token");
    final driverUuid = await SecureStorageService.read("driverUuid");
    final userUuid = await SecureStorageService.read("userUuid");

    if (token == null || token.isEmpty) {
      context.go(AppRoutes.login);
      return;
    }

    if (driverUuid == null || driverUuid.isEmpty) {
      context.go("${AppRoutes.selectRole}?uuid=$userUuid");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          "https://backauty-production.up.railway.app/API/v1/vehicles/has/$driverUuid",
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final hasVehicle = json["hasVehicle"] == true;

        if (hasVehicle) {
          context.go(AppRoutes.home);
        } else {
          context.go(AppRoutes.vehicleType);
        }
        return;
      }

      context.go(AppRoutes.vehicleType);
    } catch (e) {
      context.go(AppRoutes.vehicleType);
    }
  }

  // ========================================================
  // 🚪 LOGOUT
  // ========================================================
  Future<void> logout(BuildContext context) async {
    await _googleSignIn.signOut();
    await SecureStorageService.clear();
    user = null;

    // 🔴 Cerrar WebSocket cuando cierre sesión
    final ws = Provider.of<WsService>(context, listen: false);
    ws.disconnect();

    notifyListeners();
  }
}
