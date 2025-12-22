import '../contracts/i_auth_repository.dart';
import '../entities/user_entity.dart';

class SignInAnonymouslyUseCase {
  final IAuthRepository _repository;

  SignInAnonymouslyUseCase(this._repository);

  Future<UserEntity> call() {
    return _repository.signInAnonymously();
  }
}

