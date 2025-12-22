import '../contracts/i_auth_repository.dart';
import '../entities/user_entity.dart';

class GetAuthStreamUseCase {
  final IAuthRepository _repository;

  GetAuthStreamUseCase(this._repository);

  Stream<UserEntity?> call() {
    return _repository.user;
  }
}

