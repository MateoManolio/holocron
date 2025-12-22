import 'package:dio/dio.dart';
import '../error/exceptions.dart';
import 'app_cancellation_token.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio
      ..options.baseUrl =
          'https://cdn.jsdelivr.net/gh/akabab/starwars-api@0.2.1/api/'
      ..options.connectTimeout = const Duration(seconds: 15)
      ..options.receiveTimeout = const Duration(seconds: 15)
      ..options.responseType = ResponseType.json;

    _dio.interceptors.addAll([
      _getErrorInterceptor(),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  Interceptor _getErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException e, handler) {
        // Log to crashlytics or analytics if needed
        return handler.next(e);
      },
    );
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    AppCancellationToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      // Evitar CORS cache y preflight simple
      final cleanOptions = options ?? Options();
      cleanOptions.headers = {}; // Forzar headers vacíos

      // Cache busting para evitar que el navegador use políticas CORS viejas
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final separator = url.contains('?') ? '&' : '?';
      final finalUrl = '$url${separator}t=$timestamp';

      final Response response = await _dio.get(
        finalUrl,
        queryParameters: queryParameters,
        options: cleanOptions,
        cancelToken: cancelToken?.token as CancelToken?,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    AppCancellationToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken?.token as CancelToken?,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    AppCancellationToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken?.token as CancelToken?,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  Future<Response> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    AppCancellationToken? cancelToken,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken?.token as CancelToken?,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    if (CancelToken.isCancel(e)) {
      return RequestCancelledException(message: 'Request was cancelled');
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'Network timeout: ${e.message}');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        return ServerException(
          message: data?['detail'] ?? 'Server error',
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return RequestCancelledException(message: 'Request was cancelled');
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection: ${e.message}',
        );
      default:
        return ServerException(message: 'Something went wrong: ${e.message}');
    }
  }
}

