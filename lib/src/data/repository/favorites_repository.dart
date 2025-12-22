import 'package:holocron/src/domain/entities/character.dart';
import '../../domain/contracts/i_favorites_repository.dart';
import '../datasource/interfaces/i_favorites_local_service.dart';
import '../models/character_model.dart';

class FavoritesRepository implements IFavoritesRepository {
  final IFavoritesLocalDataSource _localDataSource;

  FavoritesRepository(this._localDataSource);

  @override
  Future<void> addFavorite(Character character) {
    return _localDataSource.saveFavorite(
      CharacterModel(
        id: character.id,
        name: character.name,
        height: character.height,
        mass: character.mass,
        gender: character.gender,
        homeworld: character.homeworld,
        wiki: character.wiki,
        image: character.image,
        born: character.born,
        bornLocation: character.bornLocation,
        died: character.died,
        diedLocation: character.diedLocation,
        species: character.species,
        hairColor: character.hairColor,
        eyeColor: character.eyeColor,
        skinColor: character.skinColor,
        cybernetics: character.cybernetics,
        affiliations: character.affiliations,
        masters: character.masters,
        apprentices: character.apprentices,
        formerAffiliations: character.formerAffiliations,
      ),
    );
  }

  @override
  Future<List<Character>> getFavorites() async {
    return await _localDataSource.getFavorites();
  }

  @override
  Future<bool> isFavorite(String id) {
    return _localDataSource.containsFavorite(id);
  }

  @override
  Future<void> removeFavorite(String id) {
    return _localDataSource.removeFavorite(id);
  }

  @override
  Future<void> clearFavorites() {
    return _localDataSource.clearFavorites();
  }
}
