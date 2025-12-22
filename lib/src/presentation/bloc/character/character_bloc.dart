import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/get_characters_usecase.dart';
import 'character_event.dart';
import 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final GetCharactersUseCase _getCharactersUseCase;
  static const int _pageSize = 10;

  CharacterBloc({required GetCharactersUseCase getCharactersUseCase})
    : _getCharactersUseCase = getCharactersUseCase,
      super(CharacterInitial()) {
    on<FetchCharacters>(_onFetchCharacters);
    on<FetchMoreCharacters>(_onFetchMoreCharacters);
    on<SearchCharacters>(_onSearchCharacters);
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
    } catch (e) {
      emit(CharacterError(_mapErrorToMessage(e)));
    }
  }

  Future<void> _onFetchMoreCharacters(
    FetchMoreCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CharacterLoaded || currentState.hasReachedMax) return;

    final query = currentState.query;
    final allPossible = query.isEmpty
        ? currentState.allCharacters
        : currentState.allCharacters
              .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

    final currentDisplayCount = currentState.displayedCharacters.length;
    final nextDisplayCount = currentDisplayCount + _pageSize;
    final nextDisplayed = allPossible.take(nextDisplayCount).toList();

    emit(
      currentState.copyWith(
        displayedCharacters: nextDisplayed,
        hasReachedMax: nextDisplayed.length >= allPossible.length,
      ),
    );
  }

  Future<void> _onSearchCharacters(
    SearchCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CharacterLoaded) return;

    final query = event.query;
    final filtered = query.isEmpty
        ? currentState.allCharacters
        : currentState.allCharacters
              .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

    final displayed = filtered.take(_pageSize).toList();

    emit(
      currentState.copyWith(
        displayedCharacters: displayed,
        hasReachedMax: displayed.length >= filtered.length,
        query: query,
      ),
    );
  }

  String _mapErrorToMessage(dynamic e) {
    return e
        .toString()
        .replaceAll('NetworkException: ', '')
        .replaceAll('ServerException: ', '');
  }
}
