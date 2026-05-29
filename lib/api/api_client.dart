import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_exception.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _resolveBaseUrl(),
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          contentType: 'application/json',
        ),
      );

  final Dio _dio;
  String? _token;
  Future<String>? _tokenFuture;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final options = await _authorizedOptions();
    final response = await _request(
      () => _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: options,
      ),
    );
    return _unwrap(response.data);
  }

  Future<Map<String, dynamic>> post(String path, {Object? data}) async {
    final options = await _authorizedOptions();
    final response = await _request(
      () => _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        options: options,
      ),
    );
    return _unwrap(response.data);
  }

  Future<Map<String, dynamic>> put(String path, {Object? data}) async {
    final options = await _authorizedOptions();
    final response = await _request(
      () => _dio.put<Map<String, dynamic>>(
        path,
        data: data,
        options: options,
      ),
    );
    return _unwrap(response.data);
  }

  Future<Map<String, dynamic>> patch(String path, {Object? data}) async {
    final options = await _authorizedOptions();
    final response = await _request(
      () => _dio.patch<Map<String, dynamic>>(
        path,
        data: data,
        options: options,
      ),
    );
    return _unwrap(response.data);
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final options = await _authorizedOptions();
    final response = await _request(
      () => _dio.delete<Map<String, dynamic>>(path, options: options),
    );
    return _unwrap(response.data);
  }

  /// Runs a `dio` request and maps any [DioException] to a typed,
  /// user-facing [ApiException] so screens never surface raw `dio` strings.
  Future<Response<T>> _request<T>(Future<Response<T>> Function() send) async {
    try {
      return await send();
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<Options> _authorizedOptions() async {
    final token = await _getToken();
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<String> _getToken() async {
    if (_token != null) {
      return _token!;
    }

    if (_tokenFuture != null) {
      return _tokenFuture!;
    }

    _tokenFuture = _login();
    try {
      final token = await _tokenFuture!;
      _token = token;
      return token;
    } finally {
      _tokenFuture = null;
    }
  }

  Future<String> _login() async {
    final response = await _request(
      () => _dio.post<Map<String, dynamic>>(
        '/api/v1/auth/login',
        data: {'email': 'flutter-demo@taopulse.app'},
      ),
    );
    final data = _unwrap(response.data);
    final token = data['token'];
    if (token is! String || token.isEmpty) {
      throw const ApiException("We couldn't sign you in. Please try again.");
    }
    return token;
  }

  static String _resolveBaseUrl() {
    const configuredBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      // defaultValue: '',
      defaultValue: 'https://icodex.space',
    );
    if (configuredBaseUrl.isNotEmpty) {
      return configuredBaseUrl;
    }

    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:5000';
    }
    return 'http://127.0.0.1:5000';
  }

  Map<String, dynamic> _unwrap(Map<String, dynamic>? body) {
    if (body == null) {
      throw const ApiException('The server returned an empty response.');
    }
    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw const ApiException('The server returned unexpected data.');
    }
    return data;
  }

  ApiException _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException('The request timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const ApiException(
          'No internet connection. Check your network and try again.',
        );
      case DioExceptionType.badCertificate:
        return const ApiException(
          "Couldn't establish a secure connection.",
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return ApiException(
          _messageForStatus(statusCode),
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return const ApiException('The request was cancelled.');
      case DioExceptionType.unknown:
        return const ApiException(
          'Something went wrong. Please try again.',
        );
    }
  }

  String _messageForStatus(int? statusCode) {
    if (statusCode == null) {
      return 'Something went wrong. Please try again.';
    }
    if (statusCode == 401 || statusCode == 403) {
      return "You're not authorized to do that. Please sign in again.";
    }
    if (statusCode == 404) {
      return "We couldn't find what you were looking for.";
    }
    if (statusCode >= 500) {
      return 'The server ran into a problem. Please try again later.';
    }
    return 'The request failed (error $statusCode). Please try again.';
  }
}
