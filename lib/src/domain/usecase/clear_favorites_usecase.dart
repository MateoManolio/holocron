import '../contracts/i_favorites_repository.dart';

class ClearFavoritesUseCase {
  final IFavoritesRepository _repository;

  ClearFavoritesUseCase(this._repository);

  Future<void> call() async {
    return _repository.clearFavorites();
  }
}
