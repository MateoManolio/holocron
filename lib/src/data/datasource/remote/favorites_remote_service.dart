import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/auth_service.dart';
import '../../models/character_model.dart';
import '../interfaces/i_favorites_local_service.dart';

/// Firestore implementation of favorites data source
/// Syncs favorites to the cloud for authenticated users
class FavoritesRemoteDataSourceImpl implements IFavoritesDataSource {
  final FirebaseFirestore _firestore;
  final AuthService _authService;
  final AnalyticsService _analytics;

  FavoritesRemoteDataSourceImpl(
    this._firestore,
    this._authService,
    this._analytics,
  );

  String get _collectionPath {
    final userId = _authService.currentUser?.id;
    if (userId == null) {
      throw Exception('User must be authenticated to access remote favorites');
    }
    return 'users/$userId/favorites';
  }

  @override
  Future<List<CharacterModel>> getFavorites() async {
    try {
      final snapshot = await _firestore.collection(_collectionPath).get();
      return snapshot.docs
          .map((doc) => CharacterModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      // Log error but don't throw - allows fallback to local storage
      await _analytics.logSyncError(
        operation: 'get_favorites',
        error: e.toString(),
      );
      return [];
    }
  }

  @override
  Future<void> saveFavorite(CharacterModel character) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(character.id.toString())
          .set(character.toJson(), SetOptions(merge: true));
    } catch (e) {
      // Log error but don't throw - local storage will still work
      await _analytics.logSyncError(
        operation: 'save_favorite',
        error: e.toString(),
      );
    }
  }

  @override
  Future<void> removeFavorite(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).delete();
    } catch (e) {
      await _analytics.logSyncError(
        operation: 'remove_favorite',
        error: e.toString(),
      );
    }
  }

  @override
  Future<bool> containsFavorite(String id) async {
    try {
      final doc = await _firestore.collection(_collectionPath).doc(id).get();
      return doc.exists;
    } catch (e) {
      await _analytics.logSyncError(
        operation: 'contains_favorite',
        error: e.toString(),
      );
      return false;
    }
  }

  @override
  Future<void> clearFavorites() async {
    try {
      final batch = _firestore.batch();
      final snapshot = await _firestore.collection(_collectionPath).get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      await _analytics.logSyncError(
        operation: 'clear_favorites',
        error: e.toString(),
      );
    }
  }
}

