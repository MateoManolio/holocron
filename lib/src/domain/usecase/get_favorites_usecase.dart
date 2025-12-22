import '../../core/interfaces/i_usecase.dart';
import '../contracts/i_favorites_repository.dart';
import '../entities/character.dart';

class GetFavoritesUseCase implements IUseCaseCommand<List<Character>> {
  final IFavoritesRepository _repository;

  GetFavoritesUseCase(this._repository);

  @override
  Future<List<Character>> call() {
    return _repository.getFavorites();
  }
}

