import 'package:holocron/src/domain/entities/character.dart';

import '../../domain/contracts/i_favorites_repository.dart';

class FavoritesRepository implements IFavoritesRepository {
  @override
  Future<void> addFavorite(Character character) {
    // TODO: implement addFavorite
    throw UnimplementedError();
  }

  @override
  Future<List<Character>> getFavorites() {
    // TODO: implement getFavorites
    throw UnimplementedError();
  }

  @override
  Future<bool> isFavorite(String id) {
    // TODO: implement isFavorite
    throw UnimplementedError();
  }

  @override
  Future<void> removeFavorite(String id) {
    // TODO: implement removeFavorite
    throw UnimplementedError();
  }
}
