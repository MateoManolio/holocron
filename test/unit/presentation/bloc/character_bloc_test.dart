import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:holocron/src/presentation/bloc/character/character_bloc.dart';
import 'package:holocron/src/presentation/bloc/character/character_event.dart';
import 'package:holocron/src/presentation/bloc/character/character_state.dart';
import 'package:holocron/src/domain/entities/character.dart';
import '../../../helpers/mocks.dart';

void main() {
  late CharacterBloc characterBloc;
  late MockGetCharactersUseCase mockGetCharactersUseCase;

  setUp(() {
    mockGetCharactersUseCase = MockGetCharactersUseCase();
    characterBloc = CharacterBloc(
      getCharactersUseCase: mockGetCharactersUseCase,
    );
  });

  tearDown(() {
    characterBloc.close();
  });

  final tCharacter = Character(id: 1, name: 'Luke');
  final tCharacters = [tCharacter];

  group('CharacterBloc', () {
    test('initial state is CharacterInitial', () {
      expect(characterBloc.state, isA<CharacterInitial>());
    });

    blocTest<CharacterBloc, CharacterState>(
      'emits CharacterLoading then CharacterLoaded when FetchCharacters is successful',
      build: () {
        when(
          () => mockGetCharactersUseCase.call(),
        ).thenAnswer((_) async => tCharacters);
        return characterBloc;
      },
      act: (bloc) => bloc.add(FetchCharacters()),
      expect: () => [
        isA<CharacterLoading>(),
        isA<CharacterLoaded>().having(
          (s) => s.allCharacters,
          'allCharacters',
          tCharacters,
        ),
      ],
    );

    blocTest<CharacterBloc, CharacterState>(
      'emits CharacterError when FetchCharacters fails',
      build: () {
        when(
          () => mockGetCharactersUseCase.call(),
        ).thenThrow(Exception('Error'));
        return characterBloc;
      },
      act: (bloc) => bloc.add(FetchCharacters()),
      expect: () => [isA<CharacterLoading>(), isA<CharacterError>()],
    );
  });
}
