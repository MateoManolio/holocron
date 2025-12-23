import 'dart:async';
import 'package:flutter/material.dart';
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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
    on<AuthNavigateToLoginRequested>(_onNavigateToLogin);
    on<AuthNavigateToSignupRequested>(_onNavigateToSignup);
    on<AuthProfileMenuRequested>(_onProfileMenuRequested);
    on<_AuthUserChanged>(_onUserChanged);
  }

  void _onUserChanged(_AuthUserChanged event, Emitter<AuthState> emit) {
    final newState = event.user != null
        ? AuthState.authenticated(event.user!)
        : const AuthState.unauthenticated();
    // Reset loading state and clear controllers on success
    if (event.user != null) {
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    }
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
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _signInUseCase(email, password);
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _signUpUseCase(email, password);
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
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _onNavigateToLogin(
    AuthNavigateToLoginRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(navigationTarget: AuthNavigationTarget.login));
    // Reset navigation target immediately after emitting
    emit(state.copyWith(navigationTarget: AuthNavigationTarget.none));
  }

  void _onNavigateToSignup(
    AuthNavigateToSignupRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(navigationTarget: AuthNavigationTarget.signup));
    emit(state.copyWith(navigationTarget: AuthNavigationTarget.none));
  }

  void _onProfileMenuRequested(
    AuthProfileMenuRequested event,
    Emitter<AuthState> emit,
  ) {
    if (state.user?.isGuest == true) {
      add(AuthNavigateToLoginRequested());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}

class _AuthUserChanged extends AuthEvent {
  final UserEntity? user;
  const _AuthUserChanged(this.user);
}
