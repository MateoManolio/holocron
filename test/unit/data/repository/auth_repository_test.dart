import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:holocron/src/data/repository/auth_repository.dart';
import 'package:holocron/src/domain/entities/user_entity.dart';
import 'package:holocron/src/core/error/exceptions.dart';
import '../../../helpers/mocks.dart';

void main() {
  late AuthRepository repository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late MockErrorReportingService mockErrorReportingService;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    mockErrorReportingService = MockErrorReportingService();
    repository = AuthRepository(mockFirebaseAuth, mockErrorReportingService);
  });

  group('signInAnonymously', () {
    test('should return UserEntity when sign in is successful', () async {
      when(
        () => mockFirebaseAuth.signInAnonymously(),
      ).thenAnswer((_) async => mockUserCredential);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('123');
      when(() => mockUser.email).thenReturn(null);
      when(() => mockUser.isAnonymous).thenReturn(true);

      final result = await repository.signInAnonymously();

      expect(result, isA<UserEntity>());
      expect(result.id, '123');
      expect(result.isGuest, true);
    });

    test('should throw ServerException when sign in fails', () async {
      when(
        () => mockFirebaseAuth.signInAnonymously(),
      ).thenThrow(Exception('Error'));
      when(
        () => mockErrorReportingService.logError(
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
          context: any(named: 'context'),
        ),
      ).thenAnswer((_) async => {});

      expect(
        () => repository.signInAnonymously(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('signOut', () {
    test('should call signOut on FirebaseAuth', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async => {});

      await repository.signOut();

      verify(() => mockFirebaseAuth.signOut()).called(1);
    });
  });
}
