import '../../../core/network/app_cancellation_token.dart';
import '../../models/character_dto.dart';

abstract class ISwapiService {
  /// Method to fetch people from SWAPI
  /// Supports [cancelToken] for manual request cancellation
  Future<List<CharacterDto>> getPeople({
    int page = 1,
    String? search,
    AppCancellationToken? cancelToken,
  });

  /// Method to fetch a single person
  Future<CharacterDto> getPerson(int id, {AppCancellationToken? cancelToken});
}

