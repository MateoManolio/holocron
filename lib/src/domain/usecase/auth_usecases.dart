import '../contracts/i_auth_repository.dart';
import '../entities/user_entity.dart';

class SignInUseCase {
  final IAuthRepository _repository;

  SignInUseCase(this._repository);

  Future<UserEntity> call(String email, String password) {
    return _repository.signInWithEmailAndPassword(email, password);
  }
}

class SignUpUseCase {
  final IAuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<UserEntity> call(String email, String password) {
    return _repository.signUp(email, password);
  }
}

class SignInAnonymouslyUseCase {
  final IAuthRepository _repository;

  SignInAnonymouslyUseCase(this._repository);

  Future<UserEntity> call() {
    return _repository.signInAnonymously();
  }
}

class SignOutUseCase {
  final IAuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<void> call() {
    return _repository.signOut();
  }
}

class GetAuthStreamUseCase {
  final IAuthRepository _repository;

  GetAuthStreamUseCase(this._repository);

  Stream<UserEntity?> call() {
    return _repository.user;
  }
}

