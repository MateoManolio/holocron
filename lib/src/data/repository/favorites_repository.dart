import 'package:holocron/src/domain/entities/character.dart';
import '../../core/services/analytics_service.dart';
import '../../core/services/auth_service.dart';
import '../../domain/contracts/i_favorites_repository.dart';
import '../datasource/interfaces/i_favorites_local_service.dart';
import '../models/character_model.dart';

class FavoritesRepository implements IFavoritesRepository {
  final IFavoritesDataSource _localDataSource;
  final IFavoritesDataSource? _remoteDataSource;
  final AuthService _authService;
  final AnalyticsService _analytics;

  FavoritesRepository({
    required IFavoritesDataSource localDataSource,
    IFavoritesDataSource? remoteDataSource,
    required AuthService authService,
    required AnalyticsService analytics,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _authService = authService,
       _analytics = analytics;

  CharacterModel _toModel(Character character) {
    return CharacterModel(
      id: character.id,
      name: character.name,
      height: character.height,
      mass: character.mass,
      gender: character.gender,
      homeworld: character.homeworld,
      wiki: character.wiki,
      image: character.image,
      born: character.born,
      bornLocation: character.bornLocation,
      died: character.died,
      diedLocation: character.diedLocation,
      species: character.species,
      hairColor: character.hairColor,
      eyeColor: character.eyeColor,
      skinColor: character.skinColor,
      cybernetics: character.cybernetics,
      affiliations: character.affiliations,
      masters: character.masters,
      apprentices: character.apprentices,
      formerAffiliations: character.formerAffiliations,
    );
  }

  bool get _shouldSyncToCloud => _authService.isAuthenticated;

  @override
  Future<void> addFavorite(Character character) async {
    final model = _toModel(character);

    // Always save to local storage first (for offline support)
    await _localDataSource.saveFavorite(model);

    // Sync to cloud if user is authenticated
    if (_shouldSyncToCloud && _remoteDataSource != null) {
      // Fire and forget - errors are logged in the datasource
      _remoteDataSource.saveFavorite(model).catchError((e) {
        _analytics.logSyncError(
          operation: 'background_save_favorite',
          error: e.toString(),
        );
      });
    }
  }

  @override
  Future<List<Character>> getFavorites() async {
    // If authenticated, try to get from cloud first, fallback to local
    if (_shouldSyncToCloud && _remoteDataSource != null) {
      try {
        final remoteFavorites = await _remoteDataSource.getFavorites();
        if (remoteFavorites.isNotEmpty) {
          return remoteFavorites;
        }
      } catch (e) {
        await _analytics.logSyncError(
          operation: 'get_favorites_cloud',
          error: e.toString(),
        );
      }
    }

    // Use local storage (for guests or as fallback)
    return await _localDataSource.getFavorites();
  }

  @override
  Future<bool> isFavorite(String id) async {
    // Check local storage for quick response
    final isLocalFavorite = await _localDataSource.containsFavorite(id);

    // If found locally, return immediately
    if (isLocalFavorite) return true;

    // If authenticated, also check remote
    if (_shouldSyncToCloud && _remoteDataSource != null) {
      try {
        return await _remoteDataSource.containsFavorite(id);
      } catch (e) {
        await _analytics.logSyncError(
          operation: 'check_favorite_remote',
          error: e.toString(),
        );
      }
    }

    return false;
  }

  @override
  Future<void> removeFavorite(String id) async {
    // Remove from local storage
    await _localDataSource.removeFavorite(id);

    // Remove from cloud if authenticated
    if (_shouldSyncToCloud && _remoteDataSource != null) {
      _remoteDataSource.removeFavorite(id).catchError((e) {
        _analytics.logSyncError(
          operation: 'background_remove_favorite',
          error: e.toString(),
        );
      });
    }
  }

  @override
  Future<void> clearFavorites() async {
    // Clear local storage
    await _localDataSource.clearFavorites();

    // Clear cloud if authenticated
    if (_shouldSyncToCloud && _remoteDataSource != null) {
      _remoteDataSource.clearFavorites().catchError((e) {
        _analytics.logSyncError(
          operation: 'background_clear_favorites',
          error: e.toString(),
        );
      });
    }
  }
}

