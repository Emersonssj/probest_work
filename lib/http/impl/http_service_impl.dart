import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import '../exceptions/handle_http_exception.dart';
import '../exceptions/http_request_exception.dart';
import '../exceptions/http_unhandled_exception.dart';
import '../http_response.dart';
import '../http_service.dart';

class HttpServiceImpl implements HttpService {
  HttpServiceImpl({
    required String baseUrl,
    List<Interceptor> interceptors = const [],
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.addAll(interceptors);
  }

  late final Dio _dio;

  @override
  AsyncResult<HttpResponse, HttpRequestException> get(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
      );
      return Success(HttpResponse(response.data));
    } on DioException catch (e) {
      return _handleHttpException(e);
    }
  }

  @override
  AsyncResult<HttpResponse, HttpRequestException> post(
    String path, {
    Duration? requestTimeout,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParams,
        options: Options(
          sendTimeout: requestTimeout,
          receiveTimeout: requestTimeout,
        ),
      );
      return Success(HttpResponse(response.data));
    } on DioException catch (e) {
      return _handleHttpException(e);
    }
  }

  @override
  AsyncResult<HttpResponse, HttpRequestException> put(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParams,
      );
      return Success(HttpResponse(response.data));
    } on DioException catch (e) {
      return _handleHttpException(e);
    }
  }

  @override
  AsyncResult<HttpResponse, HttpRequestException> delete(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParams,
      );
      return Success(HttpResponse(response.data));
    } on DioException catch (e) {
      return _handleHttpException(e);
    }
  }

  @override
  AsyncResult<HttpResponse, HttpRequestException> download(
    String urlPath,
    String savePath, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.download(
        urlPath,
        savePath,
        queryParameters: queryParams,
        options: Options(headers: headers),
        onReceiveProgress: onReceiveProgress,
      );
      return Success(HttpResponse(response.data));
    } on DioException catch (e) {
      return _handleHttpException(e);
    }
  }

  @override
  AsyncResult<HttpResponse, HttpRequestException> upload(
    String path,
    FormData data, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParams,
      );
      return Success(HttpResponse(response.data));
    } on DioException catch (e) {
      return _handleHttpException(e);
    }
  }

  Failure<HttpResponse, HttpRequestException> _handleHttpException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return Failure(
        handleHttpException(
          status: 408,
          title: 'Connection Timeout',
          userMessage: 'Connection Timeout',
          timestamp: DateTime.now(),
        ),
      );
    }

    try {
      final exception = handleHttpException(
        status: e.response!.data['status'] ?? 0,
        title: e.response!.data['title'] ?? 'Error',
        userMessage: e.response!.data['userMessage'] ?? 'Internal Server Error',
        timestamp: DateTime.now(),
        detail: e.response!.data['detail'],
        type: e.response!.data['type'],
        objects: ObjectErrors.fromJson(e.response!.data['objects']),
      );
      return Failure(exception);
    } catch (e) {
      return Failure(HttpUnhandledException.unknown());
    }
  }
}
