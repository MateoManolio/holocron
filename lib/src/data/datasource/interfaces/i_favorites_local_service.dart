import '../../models/character_model.dart';

/// Generic interface for favorites data sources (local or remote)
/// Both Hive and Firestore implementations will use this interface
abstract interface class IFavoritesDataSource {
  Future<List<CharacterModel>> getFavorites();
  Future<void> saveFavorite(CharacterModel character);
  Future<void> removeFavorite(String id);
  Future<bool> containsFavorite(String id);
  Future<void> clearFavorites();
}

