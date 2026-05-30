import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(onError: _onError),
    );
  }

  /// Marks a request that has already been retried after a 401 so the
  /// clear-and-relogin path runs at most once per request.
  static const String _retriedFlag = 'taopulse.retried401';

  final Dio _dio;
  String? _token;
  Future<String>? _tokenFuture;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
      options: await _authorizedOptions(),
    );
    return _unwrap(response.data);
  }

  Future<Map<String, dynamic>> post(String path, {Object? data}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: data,
      options: await _authorizedOptions(),
    );
    return _unwrap(response.data);
  }

  Future<Map<String, dynamic>> put(String path, {Object? data}) async {
    final response = await _dio.put<Map<String, dynamic>>(
      path,
      data: data,
      options: await _authorizedOptions(),
    );
    return _unwrap(response.data);
  }

  Future<Map<String, dynamic>> patch(String path, {Object? data}) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      path,
      data: data,
      options: await _authorizedOptions(),
    );
    return _unwrap(response.data);
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      path,
      options: await _authorizedOptions(),
    );
    return _unwrap(response.data);
  }

  Future<Options> _authorizedOptions() async {
    final token = await _getToken();
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  /// On a `401 Unauthorized`, clears the cached token, re-logs in once and
  /// transparently retries the original request. Guarded by [_retriedFlag] so
  /// a genuinely-rejected login cannot loop forever, and skipped for the login
  /// request itself.
  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final request = error.requestOptions;
    final isUnauthorized = error.response?.statusCode == 401;
    final isLogin = request.path == '/api/v1/auth/login';
    final alreadyRetried = request.extra[_retriedFlag] == true;

    if (!isUnauthorized || isLogin || alreadyRetried) {
      return handler.next(error);
    }

    // The cached token is dead — drop it and force a fresh login.
    _token = null;

    try {
      final token = await _getToken();
      request.extra[_retriedFlag] = true;
      request.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.fetch<dynamic>(request);
      return handler.resolve(response);
    } on DioException catch (retryError) {
      return handler.next(retryError);
    } catch (_) {
      // Re-login failed (e.g. network/login error) — surface the original 401.
      return handler.next(error);
    }
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
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/auth/login',
      data: {'email': 'flutter-demo@taopulse.app'},
    );
    final data = _unwrap(response.data);
    final token = data['token'];
    if (token is! String || token.isEmpty) {
      throw Exception('API login failed: token missing.');
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
      throw Exception('API returned an empty response.');
    }
    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw Exception('API returned an unexpected payload.');
    }
    return data;
  }
}
