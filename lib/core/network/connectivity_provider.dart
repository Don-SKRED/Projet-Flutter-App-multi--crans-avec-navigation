import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

/// StreamProvider qui émet `true` si l'appareil a une connexion réseau (WiFi, Mobile, Ethernet, etc.)
/// et `false` s'il est totalement déconnecté.
final isOnlineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = ref.watch(connectivityProvider);

  // État initial
  final initialResults = await connectivity.checkConnectivity();
  yield initialResults.any((result) => result != ConnectivityResult.none);

  // Écoute en direct des changements de connectivité
  await for (final results in connectivity.onConnectivityChanged) {
    yield results.any((result) => result != ConnectivityResult.none);
  }
});
