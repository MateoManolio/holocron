import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_bloc.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_event.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_state.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockGetAuthStreamUseCase mockGetAuthStreamUseCase;
  late MockSignOutUseCase mockSignOutUseCase;
  late MockSignInUseCase mockSignInUseCase;
  late MockSignUpUseCase mockSignUpUseCase;
  late MockSignInAnonymouslyUseCase mockSignInAnonymouslyUseCase;
  late MockErrorReportingService mockErrorReportingService;

  setUp(() {
    mockGetAuthStreamUseCase = MockGetAuthStreamUseCase();
    mockSignOutUseCase = MockSignOutUseCase();
    mockSignInUseCase = MockSignInUseCase();
    mockSignUpUseCase = MockSignUpUseCase();
    mockSignInAnonymouslyUseCase = MockSignInAnonymouslyUseCase();
    mockErrorReportingService = MockErrorReportingService();
  });

  group('AuthBloc', () {
    test('initial state is unknown', () {
      final authBloc = AuthBloc(
        getAuthStreamUseCase: mockGetAuthStreamUseCase,
        signOutUseCase: mockSignOutUseCase,
        signInUseCase: mockSignInUseCase,
        signUpUseCase: mockSignUpUseCase,
        signInAnonymouslyUseCase: mockSignInAnonymouslyUseCase,
        errorReporting: mockErrorReportingService,
      );
      expect(authBloc.state, const AuthState.unknown());
      authBloc.close();
    });

    blocTest<AuthBloc, AuthState>(
      'emits unauthenticated when logout is requested',
      build: () {
        when(() => mockSignOutUseCase()).thenAnswer((_) async => {});
        when(
          () => mockErrorReportingService.logError(
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
            context: any(named: 'context'),
          ),
        ).thenAnswer((_) async => {});
        return AuthBloc(
          getAuthStreamUseCase: mockGetAuthStreamUseCase,
          signOutUseCase: mockSignOutUseCase,
          signInUseCase: mockSignInUseCase,
          signUpUseCase: mockSignUpUseCase,
          signInAnonymouslyUseCase: mockSignInAnonymouslyUseCase,
          errorReporting: mockErrorReportingService,
        );
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
        when(
          () => mockErrorReportingService.logError(
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
            context: any(named: 'context'),
          ),
        ).thenAnswer((_) async => {});
        return AuthBloc(
          getAuthStreamUseCase: mockGetAuthStreamUseCase,
          signOutUseCase: mockSignOutUseCase,
          signInUseCase: mockSignInUseCase,
          signUpUseCase: mockSignUpUseCase,
          signInAnonymouslyUseCase: mockSignInAnonymouslyUseCase,
          errorReporting: mockErrorReportingService,
        );
      },
      act: (bloc) {
        bloc.emailController.text = 'test@test.com';
        bloc.passwordController.text = 'password';
        return bloc.add(const AuthLoginRequested());
      },
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
