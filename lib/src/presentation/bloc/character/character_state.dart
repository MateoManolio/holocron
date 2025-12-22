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
  final String genderFilter;
  final String speciesFilter;
  final String statusFilter;
  final String sortOption;

  const CharacterLoaded({
    required this.allCharacters,
    required this.displayedCharacters,
    required this.hasReachedMax,
    this.query = '',
    this.genderFilter = 'All',
    this.speciesFilter = 'All',
    this.statusFilter = 'All',
    this.sortOption = 'Relevance',
  });

  @override
  List<Object?> get props => [
    allCharacters,
    displayedCharacters,
    hasReachedMax,
    query,
    genderFilter,
    speciesFilter,
    statusFilter,
    sortOption,
  ];

  CharacterLoaded copyWith({
    List<Character>? allCharacters,
    List<Character>? displayedCharacters,
    bool? hasReachedMax,
    String? query,
    String? genderFilter,
    String? speciesFilter,
    String? statusFilter,
    String? sortOption,
  }) {
    return CharacterLoaded(
      allCharacters: allCharacters ?? this.allCharacters,
      displayedCharacters: displayedCharacters ?? this.displayedCharacters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      query: query ?? this.query,
      genderFilter: genderFilter ?? this.genderFilter,
      speciesFilter: speciesFilter ?? this.speciesFilter,
      statusFilter: statusFilter ?? this.statusFilter,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

class CharacterError extends CharacterState {
  final String message;

  const CharacterError(this.message);

  @override
  List<Object?> get props => [message];
}

