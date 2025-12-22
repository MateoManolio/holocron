import '../../core/interfaces/i_usecase.dart';
import '../contracts/i_character_repository.dart';
import '../entities/character.dart';

class GetCharactersUseCase implements IUseCaseCommand<List<Character>> {
  final ICharacterRepository _repository;

  GetCharactersUseCase(this._repository);

  @override
  Future<List<Character>> call() {
    return _repository.getCharacters();
  }
}

