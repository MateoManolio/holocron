import '../../domain/contracts/i_character_repository.dart';
import '../../domain/entities/character.dart';
import '../datasource/interfaces/i_swapi_service.dart';
import '../models/character_dto.dart';

class CharacterRepository implements ICharacterRepository {
  final ISwapiService _swapiService;
  List<Character>? _cachedCharacters;

  CharacterRepository(this._swapiService);

  @override
  Future<List<Character>> getCharacters() async {
    if (_cachedCharacters != null) return _cachedCharacters!;

    try {
      final dtos = await _swapiService.getPeople();
      _cachedCharacters = dtos.map(_mapDtoToEntity).toList();
      return _cachedCharacters!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Character?> getCharacterById(String id) async {
    if (_cachedCharacters != null) {
      final cached = _cachedCharacters!.where((c) => c.id.toString() == id);
      if (cached.isNotEmpty) return cached.first;
    }

    try {
      final dto = await _swapiService.getPerson(int.parse(id));
      return _mapDtoToEntity(dto);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Character>> getCharactersByQuery(String query) async {
    final characters = await getCharacters();
    if (query.isEmpty) return characters;

    return characters
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Character _mapDtoToEntity(CharacterDto dto) {
    return Character(
      id: dto.id,
      name: dto.name,
      height: dto.height,
      mass: dto.mass,
      gender: dto.gender,
      homeworld: dto.homeworld,
      wiki: dto.wiki,
      image: dto.image,
      born: dto.born,
      bornLocation: dto.bornLocation,
      died: dto.died,
      diedLocation: dto.diedLocation,
      species: dto.species,
      hairColor: dto.hairColor,
      eyeColor: dto.eyeColor,
      skinColor: dto.skinColor,
      cybernetics: dto.cybernetics,
      affiliations: dto.affiliations,
      masters: dto.masters,
      apprentices: dto.apprentices,
      formerAffiliations: dto.formerAffiliations,
    );
  }
}
