import 'package:equatable/equatable.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object?> get props => [];
}

class FetchCharacters extends CharacterEvent {}

class FetchMoreCharacters extends CharacterEvent {}

class SearchCharacters extends CharacterEvent {
  final String query;

  const SearchCharacters(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterCharacters extends CharacterEvent {
  final String gender;
  final String species;
  final String status;

  const FilterCharacters({
    required this.gender,
    required this.species,
    required this.status,
  });

  @override
  List<Object?> get props => [gender, species, status];
}

class SortCharacters extends CharacterEvent {
  final String sortOption;

  const SortCharacters(this.sortOption);

  @override
  List<Object?> get props => [sortOption];
}
