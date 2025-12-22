import '../../core/interfaces/i_usecase.dart';
import '../contracts/i_favorites_repository.dart';

class IsFavoriteUseCase implements IUseCaseQuery<bool, String> {
  final IFavoritesRepository _repository;

  IsFavoriteUseCase(this._repository);

  @override
  Future<bool> call(String id) {
    return _repository.isFavorite(id);
  }
}

