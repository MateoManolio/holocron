import '../../core/interfaces/i_usecase.dart';
import '../contracts/i_character_repository.dart';
import '../entities/character.dart';

class GetCharactersByQueryUseCase
    implements IUseCaseQuery<List<Character>, String> {
  final ICharacterRepository _repository;

  GetCharactersByQueryUseCase(this._repository);

  @override
  Future<List<Character>> call(String query) {
    return _repository.getCharactersByQuery(query);
  }
}

