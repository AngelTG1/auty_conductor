import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/ws/ws_service.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

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

  // ======================================================
  // LOGIN NORMAL
  // ======================================================
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

      // Guarda la sesión
      await _saveSession(authUser, context);

      // Navega según vehículo
      await checkHasVehicleAndNavigate(context);
    } catch (e) {
      passwordError = e.toString().replaceAll("Exception:", "");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ======================================================
  // LOGIN GOOGLE
  // ======================================================
  Future<AuthEntity> loginWithGoogle(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception("Cancelado");

      final authUser = await _googleUseCase.call();

      // Guarda sesión + WS
      await _saveSession(authUser, context);

      return authUser;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ======================================================
  // REGISTER
  // ======================================================
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

      await _saveSession(newUser, context);
      await checkHasVehicleAndNavigate(context);
    } catch (e) {
      emailError = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ======================================================
  // SAVE SESSION + CONNECT WS
  // ======================================================
  Future<void> _saveSession(AuthEntity authUser, BuildContext context) async {
    print("🔥 Guardando sesión…");
    print("🟦 Imagen recibida del backend: ${authUser.profileImage}");

    // ⚠️ Importante: YA NO HACEMOS replace
    String fixedImageUrl = authUser.profileImage;

    // Guardar datos
    await SecureStorageService.write('profileImage', fixedImageUrl);
    await SecureStorageService.write('token', authUser.token);
    await SecureStorageService.write('userUuid', authUser.uuid);
    await SecureStorageService.write('driverUuid', authUser.driverUuid);
    await SecureStorageService.write('userName', authUser.name);
    await SecureStorageService.write('userEmail', authUser.email);
    await SecureStorageService.write('userPhone', authUser.phone);
    await SecureStorageService.write('licenseNumber', authUser.licenseNumber);

    // Conectar WebSocket
    final driverUuid = authUser.driverUuid;
    if (driverUuid.isNotEmpty) {
      final ws = Provider.of<WsService>(context, listen: false);
      if (!ws.connected) ws.connect(driverUuid);
    }
  }

  // ======================================================
  // NAVIGATION BY VEHICLE
  // ======================================================
  // ======================================================
  // NAVIGATION BY VEHICLE
  // ======================================================
  Future<void> checkHasVehicleAndNavigate(BuildContext context) async {
    final token = await SecureStorageService.read("token");
    final driverUuid = await SecureStorageService.read("driverUuid");
    final userUuid = await SecureStorageService.read("userUuid");

    // 🔴 Si no hay sesión, regresar a login
    if (token == null || token.isEmpty) {
      context.go(AppRoutes.login);
      return;
    }

    // 🟡 Si es usuario NUEVO (aún no es driver)
    if (driverUuid == null || driverUuid.isEmpty) {
      context.go("${AppRoutes.selectRole}?uuid=$userUuid");
      return;
    }

    // 🟢 Si ya es driver, ahora sí validar si tiene vehículo
    try {
      final uri = Uri.parse(
        "https://auty-microservices-production.up.railway.app/API/v1/u/vehicles/has/$driverUuid",
      );
      debugPrint("📡 GET hasVehicle → $uri");

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint("📡 hasVehicle status: ${response.statusCode}");
      debugPrint("📡 hasVehicle body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        // 🔍 Intentar obtener hasVehicle de varias formas
        dynamic raw = json["hasVehicle"];
        if (raw == null && json is Map && json["data"] is Map) {
          raw = (json["data"] as Map)["hasVehicle"];
        }

        bool hasVehicle = false;

        if (raw is bool) {
          hasVehicle = raw;
        } else if (raw is num) {
          hasVehicle = raw == 1;
        } else if (raw is String) {
          hasVehicle = raw.toLowerCase() == "true" || raw == "1";
        }

        debugPrint("✅ hasVehicle interpretado como: $hasVehicle");

        if (hasVehicle) {
          // ✅ YA TIENE VEHÍCULO → HOME DIRECTO
          context.go(AppRoutes.home);
          return;
        } else {
          // 🟡 ES DRIVER PERO SIN VEHÍCULO → REGISTRAR VEHÍCULO
          context.go(AppRoutes.vehicleType);
          return;
        }
      }

      // ⚠️ Si el backend responde algo inesperado → mandar a registrar vehículo
      debugPrint(
        "⚠️ Respuesta no esperada al validar vehículo: ${response.statusCode}",
      );
      context.go(AppRoutes.vehicleType);
    } catch (e) {
      // ⚠️ Si falla la API → por seguridad mandar a registrar vehículo
      debugPrint("❌ Error validando vehículo: $e");
      context.go(AppRoutes.vehicleType);
    }
  }

  // ======================================================
  // LOGOUT
  // ======================================================
  Future<void> logout(BuildContext context) async {
    await _googleSignIn.signOut();
    await SecureStorageService.clear();

    user = null;

    // Desconectar WS
    final ws = Provider.of<WsService>(context, listen: false);
    ws.disconnect();

    notifyListeners();
  }
}
