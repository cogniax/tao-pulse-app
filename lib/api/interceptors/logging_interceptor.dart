import 'package:dio/dio.dart';

import '../../services/app_logger.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._logger);

  static const _sensitiveHeaders = {'authorization', 'cookie'};
  // Body field names redacted from request/response logs. TaoPulse's auth
  // payloads use `access`/`refresh`, and login sends `password`.
  static const _sensitiveFields = {'password', 'access', 'refresh'};

  final AppLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.debug('REQUEST ${options.method} ${options.uri}', tag: 'HTTP');

    final headers = _redactHeaders(options.headers);
    if (headers.isNotEmpty) {
      _logger.debug('Headers: $headers', tag: 'HTTP');
    }

    if (options.queryParameters.isNotEmpty) {
      _logger.debug(
        'Query: ${_redactData(options.queryParameters)}',
        tag: 'HTTP',
      );
    }

    if (options.data != null) {
      _logger.debug('Body: ${_redactData(options.data)}', tag: 'HTTP');
    }

    _logger.debug('curl: ${_generateCurlCommand(options)}', tag: 'HTTP');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.debug(
      'RESPONSE ${response.statusCode} ${response.requestOptions.uri}',
      tag: 'HTTP',
    );
    _logger.debug('Data: ${_redactData(response.data)}', tag: 'HTTP');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    if (_isClientError(statusCode)) {
      _logger.warning(
        'CLIENT ERROR $statusCode ${err.requestOptions.uri}',
        tag: 'HTTP',
      );
      _logger.warning('Type: ${err.type}', tag: 'HTTP');
      _logger.warning('Message: ${err.message}', tag: 'HTTP');

      final responseData = err.response?.data;
      if (responseData != null) {
        _logger.warning('Response: ${_redactData(responseData)}', tag: 'HTTP');
      }
    } else {
      _logger.error(
        'ERROR ${statusCode ?? '-'} ${err.requestOptions.uri}',
        error: err,
        stackTrace: err.stackTrace,
        tag: 'HTTP',
      );
      _logger.error('Type: ${err.type}', tag: 'HTTP');
      _logger.error('Message: ${err.message}', tag: 'HTTP');

      final responseData = err.response?.data;
      if (responseData != null) {
        _logger.error('Response: ${_redactData(responseData)}', tag: 'HTTP');
      }
    }

    handler.next(err);
  }

  bool _isClientError(int? statusCode) {
    return statusCode != null && statusCode >= 400 && statusCode < 500;
  }

  String _generateCurlCommand(RequestOptions options) {
    final buffer = StringBuffer('curl -X ${options.method}');

    _redactHeaders(options.headers).forEach((key, value) {
      buffer.write(' \\\n  -H "${_escape('$key: $value')}"');
    });

    if (options.data != null) {
      buffer.write(' \\\n  -d "${_escape(_redactData(options.data))}"');
    }

    buffer.write(' \\\n  "${_escape(options.uri.toString())}"');
    return buffer.toString();
  }

  Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) {
    return headers.map((key, value) {
      final normalizedKey = key.toLowerCase();
      return MapEntry(
        key,
        _sensitiveHeaders.contains(normalizedKey) ? '[REDACTED]' : value,
      );
    });
  }

  String _redactData(Object? data) {
    if (data == null) {
      return 'null';
    }
    if (data is FormData) {
      return '[FormData]';
    }
    if (data is Map) {
      return _redactMap(data).toString();
    }
    if (data is Iterable) {
      return data.map(_redactData).toList().toString();
    }
    return data.toString();
  }

  Map<dynamic, dynamic> _redactMap(Map<dynamic, dynamic> data) {
    return data.map((key, value) {
      final shouldRedact = key is String && _sensitiveFields.contains(key);
      if (shouldRedact) {
        return MapEntry(key, '[REDACTED]');
      }
      if (value is Map) {
        return MapEntry(key, _redactMap(value));
      }
      if (value is Iterable) {
        return MapEntry(
          key,
          value.map((item) => item is Map ? _redactMap(item) : item).toList(),
        );
      }
      return MapEntry(key, value);
    });
  }

  String _escape(String value) {
    return value.replaceAll('\\', r'\\').replaceAll('"', r'\"');
  }
}
