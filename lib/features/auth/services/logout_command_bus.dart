import 'dart:async';

/// Global bus that carries a "log the user out" command across the app.
///
/// The token refresh interceptor calls [requestLogout] when authentication can
/// no longer be renewed, and `AuthNotifier` listens on [stream] to perform the
/// logout. It's a broadcast channel so multiple listeners can react.
class LogoutCommandBus {
  LogoutCommandBus._();

  static final LogoutCommandBus instance = LogoutCommandBus._();

  final StreamController<void> _controller = StreamController<void>.broadcast();

  Stream<void> get stream => _controller.stream;

  void requestLogout() {
    _controller.add(null);
  }
}
