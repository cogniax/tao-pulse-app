import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/app_constants.dart';
import 'interceptors/logging_interceptor.dart';
import '../services/app_logger.dart';

part 'api_client_provider.g.dart';

@riverpod
ApiClient apiClient(Ref ref) {
  final logger = ref.watch(appLoggerProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ),
  );
  // Pass a non-null (empty) interceptors list so the generated client skips the
  // OAuth/Basic/Bearer/ApiKey interceptors it would otherwise auto-add.
  final client = ApiClient(
    dio: dio,
    basePathOverride: AppConstants.apiBaseUrl,
    interceptors: const <Interceptor>[],
  );
  client.dio.interceptors.add(LoggingInterceptor(logger));
  return client;
}
