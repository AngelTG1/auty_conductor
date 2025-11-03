import 'package:flutter/material.dart';
import 'package:auty_conductor/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:auty_conductor/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:auty_conductor/feature/auth/domain/entities/auth_entity.dart';
import 'package:auty_conductor/feature/auth/domain/usecases/login_usecase.dart';
import '../../../../core/services/secure_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase = LoginUseCase(
    AuthRepositoryImpl(AuthRemoteDataSource()),
  );

  AuthEntity? user;
  bool isLoading = false;

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final authUser = await _loginUseCase.call(email, password);
      user = authUser;

      // 🔹 Guarda datos cifrados localmente
      await SecureStorageService.write('token', authUser.token);
      await SecureStorageService.write('userUuid', authUser.uuid);
      await SecureStorageService.write('driverUuid', authUser.driverUuid);
      await SecureStorageService.write('userName', authUser.name);
      await SecureStorageService.write('userPhone', authUser.phone);
      await SecureStorageService.write('userEmail', authUser.email);
      await SecureStorageService.write('userLicense', authUser.licenseNumber);

      debugPrint('✅ Sesión iniciada correctamente');
      debugPrint('🧠 driverUuid: ${authUser.driverUuid}');
      debugPrint('🔐 token: ${authUser.token.substring(0, 15)}...');
    } catch (e) {
      debugPrint('❌ Error en login: $e');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await SecureStorageService.clear();
    user = null;
    notifyListeners();
  }
}
