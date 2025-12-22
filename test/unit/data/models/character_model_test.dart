import 'package:flutter_test/flutter_test.dart';
import 'package:holocron/src/data/models/character_model.dart';
import 'package:holocron/src/domain/entities/character.dart';

void main() {
  group('CharacterModel', () {
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

    final tCharacterModel = CharacterModel(
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

    test('should be a subclass of Character entity', () {
      expect(tCharacterModel, isA<Character>());
    });

    test('fromJson should return a valid model', () {
      final result = CharacterModel.fromJson(tJson);
      expect(result.id, tCharacterModel.id);
      expect(result.name, tCharacterModel.name);
      expect(result.height, tCharacterModel.height);
      expect(result.affiliations, tCharacterModel.affiliations);
    });

    test('toJson should return a JSON map containing proper data', () {
      final result = tCharacterModel.toJson();
      expect(result, tJson);
    });

    test('fromJson should handle null/missing optional fields', () {
      final json = {'id': 1, 'name': 'Luke'};
      final result = CharacterModel.fromJson(json);
      expect(result.id, 1);
      expect(result.name, 'Luke');
      expect(result.height, null);
      expect(result.affiliations, isEmpty);
    });

    test('fromJson should handle string numbers for height and mass', () {
      final json = {'id': 1, 'name': 'Luke', 'height': '172.5', 'mass': '77'};
      final result = CharacterModel.fromJson(json);
      expect(result.height, 172.5);
      expect(result.mass, 77);
    });
  });
}
