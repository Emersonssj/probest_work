import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import 'exceptions/http_request_exception.dart';
import 'http_response.dart';

abstract class HttpService {
  AsyncResult<HttpResponse, HttpRequestException> get(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  });

  AsyncResult<HttpResponse, HttpRequestException> post(
    String path, {
    Duration? requestTimeout,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  });

  AsyncResult<HttpResponse, HttpRequestException> put(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  });

  AsyncResult<HttpResponse, HttpRequestException> delete(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  });

  AsyncResult<HttpResponse, HttpRequestException> download(
    String urlPath,
    String savePath, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    void Function(int, int)? onReceiveProgress,
  });

  AsyncResult<HttpResponse, HttpRequestException> upload(
    String path,
    FormData data, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  });
}
