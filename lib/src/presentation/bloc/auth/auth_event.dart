import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthSubscriptionRequested extends AuthEvent {
  const AuthSubscriptionRequested();
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthLoginRequested extends AuthEvent {
  final String? email;
  final String? password;

  const AuthLoginRequested({this.email, this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthGuestLoginRequested extends AuthEvent {
  const AuthGuestLoginRequested();
}

class AuthSignUpRequested extends AuthEvent {
  final String? email;
  final String? password;

  const AuthSignUpRequested({this.email, this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthNavigateToLoginRequested extends AuthEvent {
  const AuthNavigateToLoginRequested();
}

class AuthNavigateToSignupRequested extends AuthEvent {
  const AuthNavigateToSignupRequested();
}

class AuthProfileMenuRequested extends AuthEvent {
  const AuthProfileMenuRequested();
}
