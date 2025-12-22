import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_bloc.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_event.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_state.dart';
import '../../../helpers/mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockGetAuthStreamUseCase mockGetAuthStreamUseCase;
  late MockSignOutUseCase mockSignOutUseCase;
  late MockSignInUseCase mockSignInUseCase;
  late MockSignUpUseCase mockSignUpUseCase;
  late MockSignInAnonymouslyUseCase mockSignInAnonymouslyUseCase;

  setUp(() {
    mockGetAuthStreamUseCase = MockGetAuthStreamUseCase();
    mockSignOutUseCase = MockSignOutUseCase();
    mockSignInUseCase = MockSignInUseCase();
    mockSignUpUseCase = MockSignUpUseCase();
    mockSignInAnonymouslyUseCase = MockSignInAnonymouslyUseCase();

    authBloc = AuthBloc(
      getAuthStreamUseCase: mockGetAuthStreamUseCase,
      signOutUseCase: mockSignOutUseCase,
      signInUseCase: mockSignInUseCase,
      signUpUseCase: mockSignUpUseCase,
      signInAnonymouslyUseCase: mockSignInAnonymouslyUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state is unknown', () {
      expect(authBloc.state, const AuthState.unknown());
    });

    blocTest<AuthBloc, AuthState>(
      'emits unauthenticated when logout is requested',
      build: () {
        when(() => mockSignOutUseCase()).thenAnswer((_) async => {});
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthLogoutRequested()),
      verify: (_) {
        verify(() => mockSignOutUseCase()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits loading and then fails when login fails',
      build: () {
        when(
          () => mockSignInUseCase(any(), any()),
        ).thenThrow(Exception('Login failed'));
        return authBloc;
      },
      act: (bloc) =>
          bloc.add(const AuthLoginRequested(email: 'e', password: 'p')),
      expect: () => [
        const AuthState.unknown().copyWith(isLoading: true),
        const AuthState.unknown().copyWith(
          isLoading: false,
          errorMessage: 'Exception: Login failed',
        ),
      ],
    );
  });
}
