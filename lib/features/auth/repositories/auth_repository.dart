import 'package:api_client/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../api/api_client_provider.dart';
import '../models/auth_user.dart';
import '../services/auth_token_store.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    apiClient: ref.watch(apiClientProvider),
    tokenStore: ref.watch(authTokenStoreProvider),
  );
}

class AuthRepository {
  AuthRepository({
    required ApiClient apiClient,
    required AuthTokenStore tokenStore,
  }) : _apiClient = apiClient,
       _tokenStore = tokenStore;

  final ApiClient _apiClient;
  final AuthTokenStore _tokenStore;

  Future<bool> isAuthenticated() {
    return _tokenStore.hasTokens();
  }

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.getAuthApi().authTokenLoginCreate(
      loginRequestRequestDto: LoginRequestRequestDto(
        (builder) => builder
          ..email = email.trim().toLowerCase()
          ..password = password,
      ),
    );

    final tokenPair = response.data;
    if (tokenPair == null) {
      throw const FormatException('Missing token login response.');
    }

    await _tokenStore.saveTokens(
      accessToken: tokenPair.access,
      refreshToken: tokenPair.refresh,
    );
    return AuthUser(
      id: tokenPair.user.id,
      email: tokenPair.user.email,
      username: tokenPair.user.username ?? '',
    );
  }

  Future<void> logout() {
    return _tokenStore.deleteAllTokens();
  }
}
