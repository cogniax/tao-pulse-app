import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/auth_state.dart';
import '../models/auth_user.dart';
import '../repositories/auth_repository.dart';
import '../services/logout_command_bus.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<AuthState> build() async {
    final repository = ref.read(authRepositoryProvider);
    final logoutSubscription = LogoutCommandBus.instance.stream.listen((
      _,
    ) async {
      await repository.logout();
      state = const AsyncData(AuthState.unauthenticated());
    });
    ref.onDispose(logoutSubscription.cancel);

    final authenticated = await repository.isAuthenticated();
    return authenticated
        ? const AuthState.authenticated()
        : const AuthState.unauthenticated();
  }

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .login(email: email, password: password);
      state = const AsyncData(AuthState.authenticated());
      return user;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(AuthState.unauthenticated());
  }
}
