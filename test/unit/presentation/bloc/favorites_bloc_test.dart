import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:holocron/src/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:holocron/src/presentation/bloc/favorites/favorites_event.dart';
import 'package:holocron/src/presentation/bloc/favorites/favorites_state.dart';
import 'package:holocron/src/domain/entities/character.dart';
import '../../../helpers/mocks.dart';

void main() {
  late FavoritesBloc favoritesBloc;
  late MockGetFavoritesUseCase mockGetFavoritesUseCase;
  late MockAddFavoriteUseCase mockAddFavoriteUseCase;
  late MockRemoveFavoriteUseCase mockRemoveFavoriteUseCase;
  late MockClearFavoritesUseCase mockClearFavoritesUseCase;
  late MockErrorReportingService mockErrorReportingService;

  setUpAll(() {
    registerFallbackValue(Character(id: 0, name: ''));
  });

  setUp(() {
    mockGetFavoritesUseCase = MockGetFavoritesUseCase();
    mockAddFavoriteUseCase = MockAddFavoriteUseCase();
    mockRemoveFavoriteUseCase = MockRemoveFavoriteUseCase();
    mockClearFavoritesUseCase = MockClearFavoritesUseCase();
    mockErrorReportingService = MockErrorReportingService();

    favoritesBloc = FavoritesBloc(
      getFavoritesUseCase: mockGetFavoritesUseCase,
      addFavoriteUseCase: mockAddFavoriteUseCase,
      removeFavoriteUseCase: mockRemoveFavoriteUseCase,
      clearFavoritesUseCase: mockClearFavoritesUseCase,
      errorReporting: mockErrorReportingService,
    );
  });

  tearDown(() {
    favoritesBloc.close();
  });

  final tCharacter = Character(id: 1, name: 'Luke');
  final tFavorites = [tCharacter];

  group('FavoritesBloc', () {
    test('initial state is FavoritesInitial', () {
      expect(favoritesBloc.state, isA<FavoritesInitial>());
    });

    blocTest<FavoritesBloc, FavoritesState>(
      'emits FavoritesLoading then FavoritesLoaded when LoadFavorites is successful',
      build: () {
        when(
          () => mockGetFavoritesUseCase.call(),
        ).thenAnswer((_) async => tFavorites);
        return favoritesBloc;
      },
      act: (bloc) => bloc.add(LoadFavorites()),
      expect: () => [
        isA<FavoritesLoading>(),
        isA<FavoritesLoaded>().having(
          (s) => s.favorites,
          'favorites',
          tFavorites,
        ),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'calls addFavorite and reloads favorites when AddToFavorites is added',
      build: () {
        when(
          () => mockAddFavoriteUseCase.call(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockGetFavoritesUseCase.call(),
        ).thenAnswer((_) async => tFavorites);
        return favoritesBloc;
      },
      act: (bloc) => bloc.add(AddToFavorites(tCharacter)),
      expect: () => [
        isA<FavoritesLoading>(),
        isA<FavoritesLoaded>().having(
          (s) => s.favorites,
          'favorites',
          tFavorites,
        ),
      ],
      verify: (_) {
        verify(() => mockAddFavoriteUseCase.call(tCharacter)).called(1);
      },
    );
  });
}
