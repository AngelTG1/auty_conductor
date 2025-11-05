import 'package:flutter/material.dart';
import 'package:auty_conductor/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:auty_conductor/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:auty_conductor/feature/auth/domain/entities/auth_entity.dart';
import 'package:auty_conductor/feature/auth/domain/usecases/login_usecase.dart';
import 'package:auty_conductor/feature/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:auty_conductor/feature/auth/domain/usecases/register_usecase.dart';
import '../../../../core/services/secure_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepositoryImpl _repository = AuthRepositoryImpl(
    AuthRemoteDataSource(),
  );

  late final LoginUseCase _loginUseCase = LoginUseCase(_repository);
  late final RegisterUseCase _registerUseCase = RegisterUseCase(_repository);
  late final LoginWithGoogleUseCase _googleUseCase = LoginWithGoogleUseCase(
    _repository,
  );

  AuthEntity? user;
  bool isLoading = false;

  // 🔹 Login normal
  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final authUser = await _loginUseCase.call(email, password);
      await _saveSession(authUser);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Login con Google
  Future<void> loginWithGoogle() async {
    isLoading = true;
    notifyListeners();

    try {
      final authUser = await _googleUseCase.call();
      await _saveSession(authUser);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Registro de nuevo usuario con isDriver
  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required bool isDriver, // ✅ nuevo parámetro
  }) async {
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
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Guardar sesión
  Future<void> _saveSession(AuthEntity authUser) async {
    user = authUser;
    debugPrint(
      '✅ Sesión guardada: ${authUser.uuid}, driver=${authUser.driverUuid}',
    );

    await SecureStorageService.write('token', authUser.token);
    await SecureStorageService.write('userUuid', authUser.uuid);
    await SecureStorageService.write('driverUuid', authUser.driverUuid);
    await SecureStorageService.write('userName', authUser.name);
    await SecureStorageService.write('userPhone', authUser.phone);
    await SecureStorageService.write('userEmail', authUser.email);
    await SecureStorageService.write('userLicense', authUser.licenseNumber);
  }

  Future<void> logout() async {
    await SecureStorageService.clear();
    user = null;
    notifyListeners();
  }
}
