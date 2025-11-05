import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<AuthEntity> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  // ✅ Ahora el método register también incluye isDriver
  @override
  Future<AuthEntity> register(
    String name,
    String phone,
    String email,
    String password,
    bool isDriver,
  ) {
    return remoteDataSource.register(name, phone, email, password, isDriver);
  }

  // 🔹 Nuevo método Google
  Future<AuthEntity> loginWithGoogle() {
    return remoteDataSource.loginWithGoogle();
  }
}
