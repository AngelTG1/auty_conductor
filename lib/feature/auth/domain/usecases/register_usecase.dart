import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<AuthEntity> call({
    required String name,
    required String phone,
    required String email,
    required String password,
    required bool isDriver, // ✅ nuevo parámetro
  }) {
    return repository.register(name, phone, email, password, isDriver);
  }
}
