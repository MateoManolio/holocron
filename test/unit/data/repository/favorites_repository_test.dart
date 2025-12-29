import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:holocron/src/data/repository/favorites_repository.dart';
import 'package:holocron/src/data/models/character_model.dart';
import '../../../helpers/mocks.dart';

void main() {
  late FavoritesRepository repository;
  late MockFavoritesDataSource mockLocalDataSource;
  late MockFavoritesDataSource mockRemoteDataSource;
  late MockAuthService mockAuthService;
  late MockErrorReportingService mockErrorReportingService;

  setUpAll(() {
    registerFallbackValue(CharacterModel(id: 0, name: ''));
  });

  setUp(() {
    mockLocalDataSource = MockFavoritesDataSource();
    mockRemoteDataSource = MockFavoritesDataSource();
    mockAuthService = MockAuthService();
    mockErrorReportingService = MockErrorReportingService();

    repository = FavoritesRepository(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      authService: mockAuthService,
      errorReporting: mockErrorReportingService,
    );
  });

  final tCharacter = CharacterModel(id: 1, name: 'Luke');

  group('addFavorite', () {
    test(
      'should save to local and skip remote when not authenticated',
      () async {
        when(() => mockAuthService.isAuthenticated).thenReturn(false);
        when(
          () => mockLocalDataSource.saveFavorite(any()),
        ).thenAnswer((_) async => {});

        await repository.addFavorite(tCharacter);

        verify(() => mockLocalDataSource.saveFavorite(any())).called(1);
        verifyNever(() => mockRemoteDataSource.saveFavorite(any()));
      },
    );

    test('should save to local and remote when authenticated', () async {
      when(() => mockAuthService.isAuthenticated).thenReturn(true);
      when(
        () => mockLocalDataSource.saveFavorite(any()),
      ).thenAnswer((_) async => {});
      when(
        () => mockRemoteDataSource.saveFavorite(any()),
      ).thenAnswer((_) async => {});

      await repository.addFavorite(tCharacter);

      verify(() => mockLocalDataSource.saveFavorite(any())).called(1);
      verify(() => mockRemoteDataSource.saveFavorite(any())).called(1);
    });
  });

  group('getFavorites', () {
    test('should return local favorites when not authenticated', () async {
      when(() => mockAuthService.isAuthenticated).thenReturn(false);
      when(
        () => mockLocalDataSource.getFavorites(),
      ).thenAnswer((_) async => [tCharacter]);

      final result = await repository.getFavorites();

      expect(result, [tCharacter]);
      verify(() => mockLocalDataSource.getFavorites()).called(1);
      verifyNever(() => mockRemoteDataSource.getFavorites());
    });

    test('should try remote first then local when authenticated', () async {
      when(() => mockAuthService.isAuthenticated).thenReturn(true);
      when(
        () => mockRemoteDataSource.getFavorites(),
      ).thenAnswer((_) async => [tCharacter]);

      final result = await repository.getFavorites();

      expect(result, [tCharacter]);
      verify(() => mockRemoteDataSource.getFavorites()).called(1);
      verifyNever(() => mockLocalDataSource.getFavorites());
    });
  });
}
