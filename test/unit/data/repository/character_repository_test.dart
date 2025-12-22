import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:holocron/src/data/repository/character_repository.dart';
import 'package:holocron/src/data/models/character_dto.dart';
import 'package:holocron/src/domain/entities/character.dart';
import 'package:holocron/src/data/datasource/interfaces/i_swapi_service.dart';

class MockSwapiService extends Mock implements ISwapiService {}

void main() {
  late CharacterRepository repository;
  late MockSwapiService mockSwapiService;

  setUp(() {
    mockSwapiService = MockSwapiService();
    repository = CharacterRepository(mockSwapiService);
  });

  final tCharacterDto = CharacterDto(id: 1, name: 'Luke');
  final tCharacterDtos = [tCharacterDto];

  group('getCharacters', () {
    test('should return characters from service and cache them', () async {
      when(
        () => mockSwapiService.getPeople(),
      ).thenAnswer((_) async => tCharacterDtos);

      final result = await repository.getCharacters();

      expect(result.first.name, 'Luke');
      expect(result.first, isA<Character>());
      verify(() => mockSwapiService.getPeople()).called(1);

      // Call again to verify cache
      await repository.getCharacters();
      verifyNoMoreInteractions(mockSwapiService);
    });
  });
}
