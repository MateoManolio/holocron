import '../../core/interfaces/i_usecase.dart';
import '../contracts/i_character_repository.dart';
import '../entities/character.dart';

class GetCharacterByIdUseCase implements IUseCaseQuery<Character?, String> {
  final ICharacterRepository _repository;

  GetCharacterByIdUseCase(this._repository);

  @override
  Future<Character?> call(String id) {
    return _repository.getCharacterById(id);
  }
}

