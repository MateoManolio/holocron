import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/add_favorite_usecase.dart';
import '../../../domain/usecase/clear_favorites_usecase.dart';
import '../../../domain/usecase/get_favorites_usecase.dart';
import '../../../domain/usecase/remove_favorite_usecase.dart';
import '../../../core/services/error_reporting_service.dart';
import '../../../../src/domain/entities/character.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritesUseCase _getFavoritesUseCase;
  final AddFavoriteUseCase _addFavoriteUseCase;
  final RemoveFavoriteUseCase _removeFavoriteUseCase;
  final ClearFavoritesUseCase _clearFavoritesUseCase;
  final ErrorReportingService _errorReporting;

  FavoritesBloc({
    required GetFavoritesUseCase getFavoritesUseCase,
    required AddFavoriteUseCase addFavoriteUseCase,
    required RemoveFavoriteUseCase removeFavoriteUseCase,
    required ClearFavoritesUseCase clearFavoritesUseCase,
    required ErrorReportingService errorReporting,
  }) : _getFavoritesUseCase = getFavoritesUseCase,
       _addFavoriteUseCase = addFavoriteUseCase,
       _removeFavoriteUseCase = removeFavoriteUseCase,
       _clearFavoritesUseCase = clearFavoritesUseCase,
       _errorReporting = errorReporting,
       super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<SortFavorites>(_onSortFavorites);
    on<ClearAllFavorites>(_onClearAllFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    try {
      final favorites = await _getFavoritesUseCase.call();
      emit(FavoritesLoaded(favorites: favorites));
    } catch (e, stackTrace) {
      _errorReporting.logError(
        error: e,
        stackTrace: stackTrace,
        context: 'favorites_bloc_load',
      );
      emit(FavoritesError('Failed to load favorites: $e'));
    }
  }

  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _addFavoriteUseCase.call(event.character);

      final currentState = state;
      if (currentState is FavoritesLoaded) {
        final updatedFavorites = List<Character>.from(currentState.favorites)
          ..add(event.character);
        emit(currentState.copyWith(favorites: updatedFavorites));
      } else {
        add(LoadFavorites());
      }
    } catch (e, stackTrace) {
      _errorReporting.logError(
        error: e,
        stackTrace: stackTrace,
        context: 'favorites_bloc_add',
      );
      emit(FavoritesError('Failed to add to favorites: $e'));
    }
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _removeFavoriteUseCase.call(event.id);

      final currentState = state;
      if (currentState is FavoritesLoaded) {
        final updatedFavorites = currentState.favorites
            .where((c) => c.id.toString() != event.id)
            .toList();
        emit(currentState.copyWith(favorites: updatedFavorites));
      } else {
        add(LoadFavorites());
      }
    } catch (e, stackTrace) {
      _errorReporting.logError(
        error: e,
        stackTrace: stackTrace,
        context: 'favorites_bloc_remove',
      );
      emit(FavoritesError('Failed to remove from favorites: $e'));
    }
  }

  Future<void> _onClearAllFavorites(
    ClearAllFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _clearFavoritesUseCase.call();
      add(LoadFavorites());
    } catch (e, stackTrace) {
      _errorReporting.logError(
        error: e,
        stackTrace: stackTrace,
        context: 'favorites_bloc_clear',
      );
      emit(FavoritesError('Failed to clear favorites: $e'));
    }
  }

  Future<void> _onSortFavorites(
    SortFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FavoritesLoaded) return;

    final sortedFavorites = _sortFavorites(
      currentState.favorites,
      event.sortOption,
    );

    emit(
      currentState.copyWith(
        favorites: sortedFavorites,
        sortOption: event.sortOption,
      ),
    );
  }

  List<Character> _sortFavorites(List<Character> favorites, String sortOption) {
    var sorted = List<Character>.from(favorites);

    switch (sortOption) {
      case 'Name A-Z':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Name Z-A':
        sorted.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Newest':
        sorted.sort((a, b) => b.id.compareTo(a.id));
        break;
      case 'Oldest':
        sorted.sort((a, b) => a.id.compareTo(b.id));
        break;
      case 'Default':
      default:
        break;
    }
    return sorted;
  }
}
