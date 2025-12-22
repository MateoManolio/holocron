import '../../core/interfaces/i_usecase.dart';
import '../contracts/i_favorites_repository.dart';
import '../entities/character.dart';

class AddFavoriteUseCase implements IUseCaseQuery<void, Character> {
  final IFavoritesRepository _repository;

  AddFavoriteUseCase(this._repository);

  @override
  Future<void> call(Character character) {
    return _repository.addFavorite(character);
  }
}

