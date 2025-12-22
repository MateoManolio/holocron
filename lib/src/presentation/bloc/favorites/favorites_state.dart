import 'package:equatable/equatable.dart';
import '../../../domain/entities/character.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Character> favorites;
  final String sortOption;

  const FavoritesLoaded({required this.favorites, this.sortOption = 'Default'});

  @override
  List<Object?> get props => [favorites, sortOption];

  FavoritesLoaded copyWith({List<Character>? favorites, String? sortOption}) {
    return FavoritesLoaded(
      favorites: favorites ?? this.favorites,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}

