import '../entities/auth_entity.dart';
import '../../data/repositories/auth_repository_impl.dart';

class LoginWithGoogleUseCase {
  final AuthRepositoryImpl repository;

  LoginWithGoogleUseCase(this.repository);

  Future<AuthEntity> call() {
    return repository.loginWithGoogle();
  }
}
