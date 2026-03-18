import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    debugPrint('API Base URL: ${ApiEndpoints.baseUrl}');
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    debugPrint('setAuthToken called with: Bearer $token');
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    final options = Options(
      headers: headers?.isNotEmpty == true ? headers : null,
    );
    return _dio.post(path, data: data, options: options);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final options = Options(
      headers: headers?.isNotEmpty == true ? headers : null,
    );
    return _dio.get(path, options: options, queryParameters: queryParameters);
  }

  Future<Response> put(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    final options = Options(
      headers: headers?.isNotEmpty == true ? headers : null,
    );
    return _dio.put(path, data: data, options: options);
  }

  Future<Response> delete(String path, {Map<String, dynamic>? headers}) async {
    final options = Options(
      headers: headers?.isNotEmpty == true ? headers : null,
    );
    return _dio.delete(path, options: options);
  }
}
