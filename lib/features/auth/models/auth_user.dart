import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

@freezed
sealed class AuthUser with _$AuthUser {
  const factory AuthUser({
    required int id,
    required String email,
    required String username,
  }) = _AuthUser;
}
