import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
    this.isLoading = false,
  });

  const AuthState.unknown() : this();

  const AuthState.authenticated(UserEntity user)
    : this(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, isLoading];
}

