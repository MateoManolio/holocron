import '../../domain/contracts/i_character_repository.dart';
import '../../domain/entities/character.dart';

class CharacterRepository implements ICharacterRepository {
  @override
  Future<List<Character>> getCharacters() {
    throw UnimplementedError();
  }

  @override
  Future<Character?> getCharacterById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Character>> getCharactersByQuery(String query) {
    throw UnimplementedError();
  }
}
