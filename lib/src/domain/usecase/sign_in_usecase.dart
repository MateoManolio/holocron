import '../contracts/i_auth_repository.dart';
import '../entities/user_entity.dart';

class SignInUseCase {
  final IAuthRepository _repository;

  SignInUseCase(this._repository);

  Future<UserEntity> call(String email, String password) {
    return _repository.signInWithEmailAndPassword(email, password);
  }
}

