import 'package:equatable/equatable.dart';
import '../../../domain/entities/character.dart';

abstract class CharacterState extends Equatable {
  const CharacterState();

  @override
  List<Object?> get props => [];
}

class CharacterInitial extends CharacterState {}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final List<Character> allCharacters;
  final List<Character> displayedCharacters;
  final bool hasReachedMax;
  final String query;

  const CharacterLoaded({
    required this.allCharacters,
    required this.displayedCharacters,
    required this.hasReachedMax,
    this.query = '',
  });

  @override
  List<Object?> get props => [
    allCharacters,
    displayedCharacters,
    hasReachedMax,
    query,
  ];

  CharacterLoaded copyWith({
    List<Character>? allCharacters,
    List<Character>? displayedCharacters,
    bool? hasReachedMax,
    String? query,
  }) {
    return CharacterLoaded(
      allCharacters: allCharacters ?? this.allCharacters,
      displayedCharacters: displayedCharacters ?? this.displayedCharacters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      query: query ?? this.query,
    );
  }
}

class CharacterError extends CharacterState {
  final String message;

  const CharacterError(this.message);

  @override
  List<Object?> get props => [message];
}
