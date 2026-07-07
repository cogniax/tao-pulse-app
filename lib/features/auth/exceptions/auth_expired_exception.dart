/// Thrown when the user's authentication can no longer be renewed — the access
/// token expired and the refresh token is missing or rejected — so they must
/// sign in again. Raised by the token refresh interceptor.
class AuthExpiredException implements Exception {
  const AuthExpiredException([
    this.message = 'Your session has expired. Please log in again.',
  ]);

  final String message;

  @override
  String toString() => message;
}
