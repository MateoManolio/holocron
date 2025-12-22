import '../../../core/interfaces/local_storage.dart';
import '../../models/character_model.dart';
import '../interfaces/i_favorites_local_service.dart';

class FavoritesLocalDataSourceImpl implements IFavoritesDataSource {
  final ILocalStorage _storage;
  static const String _boxName = 'favorites';

  FavoritesLocalDataSourceImpl(this._storage);

  @override
  Future<List<CharacterModel>> getFavorites() async {
    final favorites = await _storage.getValue<List<dynamic>>(_boxName, 'list');
    if (favorites == null) return [];

    return favorites
        .map(
          (e) => CharacterModel.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  @override
  Future<void> saveFavorite(CharacterModel character) async {
    final favorites = await getFavorites();
    if (!favorites.any((e) => e.id == character.id)) {
      favorites.add(character);
      await _saveList(favorites);
    }
  }

  @override
  Future<void> removeFavorite(String id) async {
    final favorites = await getFavorites();
    favorites.removeWhere((e) => e.id.toString() == id);
    await _saveList(favorites);
  }

  @override
  Future<bool> containsFavorite(String id) async {
    final favorites = await getFavorites();
    return favorites.any((e) => e.id.toString() == id);
  }

  @override
  Future<void> clearFavorites() async {
    await _saveList([]);
  }

  Future<void> _saveList(List<CharacterModel> list) async {
    final jsonList = list.map((e) => e.toJson()).toList();
    await _storage.setValue(_boxName, 'list', jsonList);
  }
}

