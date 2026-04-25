import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();
  Stream<List<ConnectivityResult>> get connectivityStream => _connectivity.onConnectivityChanged;
}
final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService();
});

final networkStatusProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(networkServiceProvider);

  return service.connectivityStream.map(
        (result) => result.first != ConnectivityResult.none,
  );
});