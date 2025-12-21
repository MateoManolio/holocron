import '../../core/interfaces/i_usecase.dart';
import '../contracts/i_favorites_repository.dart';

class RemoveFavoriteUseCase implements IUseCaseQuery<void, String> {
  final IFavoritesRepository _repository;

  RemoveFavoriteUseCase(this._repository);

  @override
  Future<void> call(String id) {
    return _repository.removeFavorite(id);
  }
}
