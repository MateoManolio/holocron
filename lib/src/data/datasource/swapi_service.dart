import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';

class SwapiService {
  final DioClient _dioClient;

  SwapiService(this._dioClient);

  /// Method to fetch people from SWAPI
  /// Supports [cancelToken] for manual request cancellation
  Future<Map<String, dynamic>> getPeople({
    int page = 1,
    String? search,
    CancelToken? cancelToken,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        if (search != null) 'search': search,
      };

      final response = await _dioClient.get(
        'people/',
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      // Errors are already handled and transformed by DioClient
      rethrow;
    }
  }

  /// Example of fetching a single person
  Future<Map<String, dynamic>> getPerson(
    int id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dioClient.get(
        'people/$id/',
        cancelToken: cancelToken,
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}
