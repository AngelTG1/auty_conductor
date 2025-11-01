import 'package:auty_conductor/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:auty_conductor/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:auty_conductor/feature/auth/domain/entities/auth_entity.dart';
import 'package:auty_conductor/feature/auth/domain/usecases/login_usecase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      final prefs = await SharedPreferences.getInstance();
      // 🔹 Guardar todos los datos del usuario
      await prefs.setString('token', authUser.token);
      await prefs.setString('userUuid', authUser.uuid);
      await prefs.setString('driverUuid', authUser.driverUuid);
      await prefs.setString('userName', authUser.name);  // 👈 agregado
      await prefs.setString('userEmail', authUser.email); // 👈 agregado

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    user = null;
    notifyListeners();
  }
}
