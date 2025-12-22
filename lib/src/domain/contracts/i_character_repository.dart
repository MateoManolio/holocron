import '../entities/character.dart';

abstract class ICharacterRepository {
  Future<List<Character>> getCharacters();
  Future<Character?> getCharacterById(String id);
  Future<List<Character>> getCharactersByQuery(String query);
}

