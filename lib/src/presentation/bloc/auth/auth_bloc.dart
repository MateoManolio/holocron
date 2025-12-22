import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecase/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetAuthStreamUseCase _getAuthStreamUseCase;
  final SignOutUseCase _signOutUseCase;
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignInAnonymouslyUseCase _signInAnonymouslyUseCase;

  StreamSubscription<UserEntity?>? _authSubscription;

  AuthBloc({
    required GetAuthStreamUseCase getAuthStreamUseCase,
    required SignOutUseCase signOutUseCase,
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignInAnonymouslyUseCase signInAnonymouslyUseCase,
  }) : _getAuthStreamUseCase = getAuthStreamUseCase,
       _signOutUseCase = signOutUseCase,
       _signInUseCase = signInUseCase,
       _signUpUseCase = signUpUseCase,
       _signInAnonymouslyUseCase = signInAnonymouslyUseCase,
       super(const AuthState.unknown()) {
    on<AuthSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthGuestLoginRequested>(_onGuestLoginRequested);
    on<_AuthUserChanged>(_onUserChanged);
  }

  void _onUserChanged(_AuthUserChanged event, Emitter<AuthState> emit) {
    final newState = event.user != null
        ? AuthState.authenticated(event.user!)
        : const AuthState.unauthenticated();
    // Reset loading state when user changes
    emit(newState.copyWith(isLoading: false));
  }

  Future<void> _onSubscriptionRequested(
    AuthSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authSubscription?.cancel();
    _authSubscription = _getAuthStreamUseCase().listen((user) {
      add(_AuthUserChanged(user));
    });
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _signOutUseCase();
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _signInUseCase(event.email, event.password);
      // The stream will update the state
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _signUpUseCase(event.email, event.password);
      // The stream will update the state
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onGuestLoginRequested(
    AuthGuestLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _signInAnonymouslyUseCase();
      // The stream will update the state
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}

// Private event for internal stream updates
class _AuthUserChanged extends AuthEvent {
  final UserEntity? user;
  const _AuthUserChanged(this.user);
}

