import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/contracts/i_auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../core/error/exceptions.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository(this._firebaseAuth);

  @override
  Stream<UserEntity?> get user {
    return _firebaseAuth.authStateChanges().map(_mapFirebaseUserToUserEntity);
  }

  @override
  UserEntity? get currentUser {
    return _mapFirebaseUserToUserEntity(_firebaseAuth.currentUser);
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw ServerException(message: 'User not found after sign in');
      }
      return _mapFirebaseUserToUserEntity(userCredential.user!)!;
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Authentication failed');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserEntity> signUp(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw ServerException(message: 'User not found after sign up');
      }
      return _mapFirebaseUserToUserEntity(userCredential.user!)!;
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Sign up failed');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserEntity> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      if (userCredential.user == null) {
        throw ServerException(
          message: 'User not found after anonymous sign in',
        );
      }
      return _mapFirebaseUserToUserEntity(userCredential.user!)!;
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Anonymous authentication failed',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  UserEntity? _mapFirebaseUserToUserEntity(User? user) {
    if (user == null) return null;
    return UserEntity(
      id: user.uid,
      email: user.email,
      isGuest: user.isAnonymous,
    );
  }
}

