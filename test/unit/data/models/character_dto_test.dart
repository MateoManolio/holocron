import 'package:flutter_test/flutter_test.dart';
import 'package:holocron/src/data/models/character_dto.dart';

void main() {
  group('CharacterDto', () {
    final tJson = {
      'id': 1,
      'name': 'Luke Skywalker',
      'height': 172.0,
      'mass': 77,
      'gender': 'male',
      'homeworld': 'Tatooine',
      'wiki': 'http://starwars.wikia.com/wiki/Luke_Skywalker',
      'image':
          'https://vignette.wikia.nocookie.net/starwars/images/2/20/Luke_Skywalker_DNR.png',
      'born': -19,
      'bornLocation': 'polis massa',
      'died': 34,
      'diedLocation': 'ahch-to',
      'species': 'human',
      'hairColor': 'blond',
      'eyeColor': 'blue',
      'skinColor': 'fair',
      'cybernetics': 'Right hand',
      'affiliations': ['Alliance to Restore the Republic', 'Jedi Order'],
      'masters': ['Obi-Wan Kenobi', 'Yoda'],
      'apprentices': ['Leia Organa', 'Ben Solo'],
      'formerAffiliations': [],
    };

    final tCharacterDto = CharacterDto(
      id: 1,
      name: 'Luke Skywalker',
      height: 172.0,
      mass: 77,
      gender: 'male',
      homeworld: 'Tatooine',
      wiki: 'http://starwars.wikia.com/wiki/Luke_Skywalker',
      image:
          'https://vignette.wikia.nocookie.net/starwars/images/2/20/Luke_Skywalker_DNR.png',
      born: -19,
      bornLocation: 'polis massa',
      died: 34,
      diedLocation: 'ahch-to',
      species: 'human',
      hairColor: 'blond',
      eyeColor: 'blue',
      skinColor: 'fair',
      cybernetics: 'Right hand',
      affiliations: const ['Alliance to Restore the Republic', 'Jedi Order'],
      masters: const ['Obi-Wan Kenobi', 'Yoda'],
      apprentices: const ['Leia Organa', 'Ben Solo'],
      formerAffiliations: const [],
    );

    test('fromJson should return a valid DTO', () {
      final result = CharacterDto.fromJson(tJson);
      expect(result.id, tCharacterDto.id);
      expect(result.name, tCharacterDto.name);
      expect(result.height, tCharacterDto.height);
      expect(result.affiliations, tCharacterDto.affiliations);
    });

    test('toJson should return a JSON map containing proper data', () {
      final result = tCharacterDto.toJson();
      expect(result, tJson);
    });

    test('fromJson should handle null/missing optional fields', () {
      final json = {'id': 1, 'name': 'Luke'};
      final result = CharacterDto.fromJson(json);
      expect(result.id, 1);
      expect(result.name, 'Luke');
      expect(result.height, null);
      expect(result.affiliations, isEmpty);
    });
  });
}
