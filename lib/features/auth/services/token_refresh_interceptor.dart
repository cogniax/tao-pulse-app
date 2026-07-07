import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/app_constants.dart';
import '../exceptions/auth_expired_exception.dart';
import 'auth_token_store.dart';
import 'logout_command_bus.dart';

part 'token_refresh_interceptor.g.dart';

@Riverpod(keepAlive: true)
TokenRefreshInterceptor tokenRefreshInterceptor(Ref ref) {
  return TokenRefreshInterceptor(ref.watch(authTokenStoreProvider));
}

class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor(this._tokenStore);

  static const _hasRetried = 'taopulse.auth.tokenRefresh.hasRetried';
  static const _loginPath = '/api/auth/token/login/';
  static const _refreshPath = '/api/auth/token/refresh/';

  final AuthTokenStore _tokenStore;
  final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ),
  );

  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isAuthEndpoint(options.path)) {
      handler.next(options);
      return;
    }

    final accessToken = await _tokenStore.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 ||
        _isAuthEndpoint(err.requestOptions.path)) {
      handler.next(err);
      return;
    }

    if (err.requestOptions.extra[_hasRetried] == true) {
      handler.next(_wrapAuthExpired(err.requestOptions));
      return;
    }

    if (_isRefreshing) {
      await _waitForActiveRefresh(err, handler);
      return;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      final refreshedAccessToken = await _refreshAccessToken(err);
      if (!_refreshCompleter!.isCompleted) {
        _refreshCompleter!.complete();
      }

      final response = await _retryOriginalRequest(
        err.requestOptions,
        refreshedAccessToken,
      );
      handler.resolve(response);
    } catch (error) {
      await _forceLogout();
      final authExpiredError = _wrapAuthExpired(
        err.requestOptions,
        cause: error,
      );
      _completeRefreshWithError(authExpiredError);
      handler.next(authExpiredError);
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  Future<void> _waitForActiveRefresh(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      await _refreshCompleter?.future;
    } catch (_) {
      handler.next(_wrapAuthExpired(err.requestOptions));
      return;
    }

    final latestAccessToken = await _tokenStore.getAccessToken();
    if (latestAccessToken == null || latestAccessToken.isEmpty) {
      handler.next(_wrapAuthExpired(err.requestOptions));
      return;
    }

    try {
      final response = await _retryOriginalRequest(
        err.requestOptions,
        latestAccessToken,
      );
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<String> _refreshAccessToken(DioException err) async {
    final refreshToken = await _tokenStore.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const _RefreshUnavailable();
    }

    final response = await _refreshDio.post<Map<String, dynamic>>(
      _refreshPath,
      data: <String, dynamic>{'refresh': refreshToken},
    );
    final accessToken = response.data?['access'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw DioException(
        requestOptions: err.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }

    // Honor refresh-token rotation if the backend returns a new one; otherwise
    // keep the current token.
    final rotatedRefreshToken =
        response.data?['refresh'] as String? ?? refreshToken;
    await _tokenStore.saveTokens(
      accessToken: accessToken,
      refreshToken: rotatedRefreshToken,
    );
    return accessToken;
  }

  Future<Response<dynamic>> _retryOriginalRequest(
    RequestOptions requestOptions,
    String accessToken,
  ) {
    final headers = Map<String, dynamic>.from(requestOptions.headers);
    headers['Authorization'] = 'Bearer $accessToken';
    final extra = Map<String, dynamic>.from(requestOptions.extra)
      ..[_hasRetried] = true;
    return _refreshDio.fetch<dynamic>(
      requestOptions.copyWith(headers: headers, extra: extra),
    );
  }

  bool _isAuthEndpoint(String path) {
    return path.contains(_loginPath) || path.contains(_refreshPath);
  }

  Future<void> _forceLogout() {
    return _tokenStore.deleteAllTokens();
  }

  DioException _wrapAuthExpired(
    RequestOptions requestOptions, {
    Object? cause,
  }) {
    LogoutCommandBus.instance.requestLogout();
    return DioException(
      requestOptions: requestOptions,
      error: const AuthExpiredException(),
      message: cause == null
          ? null
          : 'Auth refresh failed: ${cause.runtimeType}',
    );
  }

  void _completeRefreshWithError(Object error) {
    final refreshCompleter = _refreshCompleter;
    if (refreshCompleter != null && !refreshCompleter.isCompleted) {
      refreshCompleter.future.ignore();
      refreshCompleter.completeError(error);
    }
  }
}

/// Internal signal that a refresh cannot proceed (e.g. no stored refresh token).
class _RefreshUnavailable implements Exception {
  const _RefreshUnavailable();
}
