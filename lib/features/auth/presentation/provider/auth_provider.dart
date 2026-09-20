import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_screen_app_with_navigation/core/providers/core_provider.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/dataSources/auth_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/model/auth_response_model.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:multi_screen_app_with_navigation/features/auth/domain/repositories/auth_repository.dart';

final remoteAuthDataSourceProvider = Provider<RemoteAuthDataSource>((ref) {
  final Dio dio = ref.watch(apiClientProvider);
  return RemoteAuthDataSourceImpl(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteAuthDataSource = ref.watch(remoteAuthDataSourceProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(remoteAuthDataSource, secureStorage);
});

class AuthProvider extends AsyncNotifier<AuthResponseModel?> {
  @override
  FutureOr<AuthResponseModel?> build() async {
    // Appelé automatiquement au tout premier accès à authProvider
    // (typiquement au démarrage de l'app, via goRouterProvider qui
    // le lit dans son redirect). Tant que cette Future n'est pas
    // résolue, authState.isLoading vaut true et !authState.hasValue
    // aussi — le guard ne redirige pas encore (voir routes.dart).
    final repository = ref.read(authRepositoryProvider);
    return repository.restoreSession();
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      return repository.login(email, password);
    });
  }

  Future<void> signUp(String email, String password, String username) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      return repository.register(email, password, username);
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
      return null; // ← état repassé à null : le guard redirige vers /login
    });
  }
}

final authProvider = AsyncNotifierProvider<AuthProvider, AuthResponseModel?>(
  AuthProvider.new,
);
