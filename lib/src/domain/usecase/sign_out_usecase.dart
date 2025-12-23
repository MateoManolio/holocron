import '../../core/interfaces/i_usecase.dart';
import '../contracts/i_auth_repository.dart';

class SignOutUseCase implements IUseCaseCommand<void> {
  final IAuthRepository _repository;

  SignOutUseCase(this._repository);

  @override
  Future<void> call() {
    return _repository.signOut();
  }
}
