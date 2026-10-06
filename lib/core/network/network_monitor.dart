import 'dart:async';

/// Estado de conectividad detectado a partir de las respuestas HTTP.
///
/// La app no depende de un plugin de conectividad: cada éxito o fallo de red
/// alimenta este monitor, y la UI muestra el banner de "sin conexión" cuando
/// corresponde.
final class NetworkMonitor {
  NetworkMonitor({bool initialOnline = true})
      : _isOnline = initialOnline,
        _controller = StreamController<bool>.broadcast();

  final StreamController<bool> _controller;
  bool _isOnline;

  bool get isOnline => _isOnline;

  Stream<bool> get stream => _controller.stream;

  void reportSuccess() => _set(true);

  void reportFailure(Object error) {
    if (error is Exception) {
      final bool isConnectionIssue = _looksLikeConnectionIssue(error);
      if (isConnectionIssue) _set(false);
    }
  }

  void setOnline(bool value) => _set(value);

  void dispose() => _controller.close();

  void _set(bool value) {
    if (_isOnline == value) return;
    _isOnline = value;
    if (!_controller.isClosed) _controller.add(value);
  }

  bool _looksLikeConnectionIssue(Object error) =>
      error.toString().toLowerCase().contains('socket') ||
      error.toString().toLowerCase().contains('connection') ||
      error.toString().toLowerCase().contains('timed out');
}
