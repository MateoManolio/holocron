import 'package:equatable/equatable.dart';
import '../../../domain/entities/character.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class AddToFavorites extends FavoritesEvent {
  final Character character;

  const AddToFavorites(this.character);

  @override
  List<Object?> get props => [character];
}

class RemoveFromFavorites extends FavoritesEvent {
  final String id;

  const RemoveFromFavorites(this.id);

  @override
  List<Object?> get props => [id];
}
