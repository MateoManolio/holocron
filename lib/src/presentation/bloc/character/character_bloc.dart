import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/get_characters_usecase.dart';
import '../../../core/services/error_reporting_service.dart';
import '../../../../src/domain/entities/character.dart';
import 'character_event.dart';
import 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final GetCharactersUseCase _getCharactersUseCase;
  final ErrorReportingService _errorReporting;
  static const int _pageSize = 10;

  CharacterBloc({
    required GetCharactersUseCase getCharactersUseCase,
    required ErrorReportingService errorReporting,
  }) : _getCharactersUseCase = getCharactersUseCase,
       _errorReporting = errorReporting,
       super(CharacterInitial()) {
    on<FetchCharacters>(_onFetchCharacters);
    on<FetchMoreCharacters>(_onFetchMoreCharacters);
    on<SearchCharacters>(_onSearchCharacters);
    on<FilterCharacters>(_onFilterCharacters);
    on<SortCharacters>(_onSortCharacters);
    on<SearchFocusChanged>(_onSearchFocusChanged);
    on<FilterPopoverToggled>(_onFilterPopoverToggled);
  }

  Future<void> _onFetchCharacters(
    FetchCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    emit(CharacterLoading());
    try {
      final allCharacters = await _getCharactersUseCase.call();
      final displayed = allCharacters.take(_pageSize).toList();

      emit(
        CharacterLoaded(
          allCharacters: allCharacters,
          displayedCharacters: displayed,
          hasReachedMax: displayed.length >= allCharacters.length,
        ),
      );
    } catch (e, stackTrace) {
      _errorReporting.logError(
        error: e,
        stackTrace: stackTrace,
        context: 'character_bloc_fetch',
      );
      emit(CharacterError(_mapErrorToMessage(e)));
    }
  }

  Future<void> _onFetchMoreCharacters(
    FetchMoreCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CharacterLoaded || currentState.hasReachedMax) return;

    final filteredCharacters = _applyFiltersAndSort(
      currentState.allCharacters,
      currentState.query,
      currentState.genderFilter,
      currentState.speciesFilter,
      currentState.statusFilter,
      currentState.sortOption,
    );

    final currentDisplayCount = currentState.displayedCharacters.length;
    final nextDisplayCount = currentDisplayCount + _pageSize;
    final nextDisplayed = filteredCharacters.take(nextDisplayCount).toList();

    emit(
      currentState.copyWith(
        displayedCharacters: nextDisplayed,
        hasReachedMax: nextDisplayed.length >= filteredCharacters.length,
      ),
    );
  }

  Future<void> _onSearchCharacters(
    SearchCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CharacterLoaded) return;

    final filteredCharacters = _applyFiltersAndSort(
      currentState.allCharacters,
      event.query,
      currentState.genderFilter,
      currentState.speciesFilter,
      currentState.statusFilter,
      currentState.sortOption,
    );

    final displayed = filteredCharacters.take(_pageSize).toList();

    emit(
      currentState.copyWith(
        displayedCharacters: displayed,
        hasReachedMax: displayed.length >= filteredCharacters.length,
        query: event.query,
      ),
    );
  }

  Future<void> _onFilterCharacters(
    FilterCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CharacterLoaded) return;

    final filteredCharacters = _applyFiltersAndSort(
      currentState.allCharacters,
      currentState.query,
      event.gender,
      event.species,
      event.status,
      currentState.sortOption,
    );

    final displayed = filteredCharacters.take(_pageSize).toList();

    emit(
      currentState.copyWith(
        displayedCharacters: displayed,
        hasReachedMax: displayed.length >= filteredCharacters.length,
        genderFilter: event.gender,
        speciesFilter: event.species,
        statusFilter: event.status,
      ),
    );
  }

  Future<void> _onSortCharacters(
    SortCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CharacterLoaded) return;

    final filteredCharacters = _applyFiltersAndSort(
      currentState.allCharacters,
      currentState.query,
      currentState.genderFilter,
      currentState.speciesFilter,
      currentState.statusFilter,
      event.sortOption,
    );

    final displayed = filteredCharacters.take(_pageSize).toList();

    emit(
      currentState.copyWith(
        displayedCharacters: displayed,
        hasReachedMax: displayed.length >= filteredCharacters.length,
        sortOption: event.sortOption,
      ),
    );
  }

  List<Character> _applyFiltersAndSort(
    List<Character> allCharacters,
    String query,
    String gender,
    String species,
    String status,
    String sortOption,
  ) {
    var filtered = allCharacters;

    // 1. Search Query
    if (query.isNotEmpty) {
      filtered = filtered
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    // 2. Gender Filter
    if (gender != 'All') {
      filtered = filtered
          .where(
            (c) => c.gender?.toLowerCase() == gender.toLowerCase(),
          ) // Simple match
          .toList();
    }

    // 3. Species Filter
    if (species != 'All') {
      filtered = filtered
          .where(
            (c) => c.species?.toLowerCase() == species.toLowerCase(),
          ) // Simple match
          .toList();
    }

    // 4. Status Filter
    if (status != 'All') {
      if (status == 'Alive') {
        filtered = filtered.where((c) => c.died == null).toList();
      } else if (status == 'Deceased') {
        filtered = filtered.where((c) => c.died != null).toList();
      }
    }

    // 5. Sorting
    filtered = List<Character>.from(filtered);

    switch (sortOption) {
      case 'Name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Newest':
        filtered.sort((a, b) => b.id.compareTo(a.id));
        break;
      case 'Oldest':
        filtered.sort((a, b) => a.id.compareTo(b.id));
        break;
      case 'Relevance':
      default:
        break;
    }

    return filtered;
  }

  void _onSearchFocusChanged(
    SearchFocusChanged event,
    Emitter<CharacterState> emit,
  ) {
    final currentState = state;
    if (currentState is! CharacterLoaded) return;
    emit(currentState.copyWith(isSearchFocused: event.isFocused));
  }

  void _onFilterPopoverToggled(
    FilterPopoverToggled event,
    Emitter<CharacterState> emit,
  ) {
    final currentState = state;
    if (currentState is! CharacterLoaded) return;
    emit(currentState.copyWith(isFilterPopoverOpen: event.isOpen));
  }

  String _mapErrorToMessage(dynamic e) {
    return e
        .toString()
        .replaceAll('NetworkException: ', '')
        .replaceAll('ServerException: ', '');
  }
}
