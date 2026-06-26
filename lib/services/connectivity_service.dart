import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  Stream<bool> get onConnectivityChanged => _controller.stream;
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  Future<bool> checkNow() async {
    final results = await _connectivity.checkConnectivity();
    _isOnline = !results.contains(ConnectivityResult.none);
    _controller.add(_isOnline);
    return _isOnline;
  }

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  void initialize() {
    checkNow();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _isOnline = !results.contains(ConnectivityResult.none);
      _controller.add(_isOnline);
    });
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
