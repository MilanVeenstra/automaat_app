import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Service voor het monitoren van netwerk connectiviteit
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  StreamController<bool>? _connectivityController;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Stream van connectiviteit status (true = online, false = offline)
  Stream<bool> get connectivityStream {
    _connectivityController ??= StreamController<bool>.broadcast(
      onListen: _startListening,
      onCancel: _stopListening,
    );
    return _connectivityController!.stream;
  }

  /// Controleer huidige connectiviteit status
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  void _startListening() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final isConnected = _hasConnection(results);
        _connectivityController?.add(isConnected);
      },
    );

    // Controleer direct en verstuur huidige status
    isConnected.then((connected) {
      _connectivityController?.add(connected);
    });
  }

  void _stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    // Geen connectie als none of alleen bluetooth
    if (results.isEmpty) return false;
    if (results.length == 1 && results.first == ConnectivityResult.none) {
      return false;
    }
    if (results.length == 1 &&
        results.first == ConnectivityResult.bluetooth) {
      return false;
    }

    // Heeft connectie als een van: mobile, wifi, ethernet, vpn
    return results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn);
  }

  /// Ruim resources op
  void dispose() {
    _subscription?.cancel();
    _connectivityController?.close();
  }
}
