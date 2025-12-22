import '../../models/character_model.dart';

abstract interface class IFavoritesLocalDataSource {
  Future<List<CharacterModel>> getFavorites();
  Future<void> saveFavorite(CharacterModel character);
  Future<void> removeFavorite(String id);
  Future<bool> containsFavorite(String id);
}
