import '../entities/character.dart';

abstract class IFavoritesRepository {
  Future<List<Character>> getFavorites();
  Future<void> addFavorite(Character character);
  Future<void> removeFavorite(String id);
  Future<bool> isFavorite(String id);
  Future<void> clearFavorites();
}

