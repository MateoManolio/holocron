import '../../../core/network/app_cancellation_token.dart';
import '../../../core/network/dio_client.dart';
import '../../models/character_dto.dart';
import '../../../core/services/error_reporting_service.dart';
import '../interfaces/i_swapi_service.dart';

class SwapiService implements ISwapiService {
  final DioClient _dioClient;
  final ErrorReportingService _errorReporting;

  SwapiService(this._dioClient, this._errorReporting);

  @override
  Future<List<CharacterDto>> getPeople({
    int page = 1,
    String? search,
    AppCancellationToken? cancelToken,
  }) async {
    try {
      final response = await _dioClient.get(
        'all.json',
        cancelToken: cancelToken,
      );

      final list = response.data as List<dynamic>;
      return list
          .map((json) => CharacterDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      _errorReporting.logError(
        error: e,
        stackTrace: stackTrace,
        context: 'swapi_service_get_people',
      );
      rethrow;
    }
  }

  @override
  Future<CharacterDto> getPerson(
    int id, {
    AppCancellationToken? cancelToken,
  }) async {
    try {
      final response = await _dioClient.get(
        'id/$id.json',
        cancelToken: cancelToken,
      );
      return CharacterDto.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stackTrace) {
      _errorReporting.logError(
        error: e,
        stackTrace: stackTrace,
        context: 'swapi_service_get_person',
      );
      rethrow;
    }
  }
}
