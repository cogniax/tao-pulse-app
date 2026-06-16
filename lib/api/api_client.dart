import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/app_constants.dart';

part 'api_client.g.dart';

@riverpod
ApiClient apiClient(Ref ref) {
  return ApiClient();
}

class ApiClient {
  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConstants.apiBaseUrl,
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
