/// A typed, user-facing error raised at the [ApiClient] boundary.
///
/// Network and server failures from `dio` are caught in the client and mapped
/// to one of these with a calm, human-readable [message]. Screens render the
/// error via `'$error'`, so [toString] intentionally returns the bare
/// [message] — no `Exception:` prefix or stack noise leaks to the user.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  /// Human-readable message that is safe to show to the user.
  final String message;

  /// The HTTP status code, when the failure came from a server response.
  final int? statusCode;

  @override
  String toString() => message;
}
