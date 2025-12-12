import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login(String email, String password);

  Future<AuthEntity> register(
    String name,
    String phone,
    String email,
    String password,
    bool isDriver,
  );
}
