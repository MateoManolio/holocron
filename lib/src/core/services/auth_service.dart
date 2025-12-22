import '../../domain/contracts/i_auth_repository.dart';
import '../../domain/entities/user_entity.dart';

/// Singleton service to access current authenticated user
/// Provides a clean way to access auth state without coupling BLoCs
class AuthService {
  final IAuthRepository _authRepository;

  AuthService(this._authRepository);

  /// Get the current user synchronously
  UserEntity? get currentUser => _authRepository.currentUser;

  /// Stream of user authentication state changes
  Stream<UserEntity?> get userStream => _authRepository.user;

  /// Check if user is authenticated (not guest and not null)
  bool get isAuthenticated {
    final user = currentUser;
    return user != null && !user.isGuest;
  }

  /// Check if user is guest
  bool get isGuest => currentUser?.isGuest ?? false;
}

