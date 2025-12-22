import '../entities/user_entity.dart';

abstract class IAuthRepository {
  Stream<UserEntity?> get user;
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<UserEntity> signUp(String email, String password);
  Future<UserEntity> signInAnonymously();
  Future<void> signOut();
  UserEntity? get currentUser;
}

