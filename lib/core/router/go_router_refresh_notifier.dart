// TODO Implement this library.
// core/router/go_router_refresh_notifier.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_screen_app_with_navigation/features/auth/presentation/provider/auth_provider.dart';

/// Transforme les changements de authProvider en notifications
/// écoutables par GoRouter, pour que le redirect soit ré-évalué
/// automatiquement après un login/logout — sans que l'utilisateur
/// ait besoin de naviguer manuellement pour déclencher la vérification.
class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(Ref ref) {
    ref.listen(authProvider, (previous, next) {
      notifyListeners();
    });
  }
}
