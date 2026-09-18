import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_screen_app_with_navigation/core/network/dio_client.dart';
import 'package:multi_screen_app_with_navigation/core/storage/secure_storage_service.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/dataSources/auth_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/model/auth_response_model.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:multi_screen_app_with_navigation/features/auth/domain/repositories/auth_repository.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(storage: ref.watch(secureStorageProvider));
});
final apiClientProvider = Provider<Dio>((ref) {
  return ref.watch(dioClientProvider).dio;
});
final remoteAuthDataSourceProvider = Provider<RemoteAuthDataSource>((ref) {
  final Dio dio = ref.watch(apiClientProvider);
  return RemoteAuthDataSourceImpl(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteAuthDataSource = ref.watch(remoteAuthDataSourceProvider);
  final secureStorage = ref.watch(
    secureStorageProvider,
  ); // ← déjà déclaré plus haut dans ton fichier
  return AuthRepositoryImpl(remoteAuthDataSource, secureStorage);
});

class AuthProvider extends AsyncNotifier<AuthResponseModel?> {
  @override
  FutureOr<AuthResponseModel?> build() {
    return null;
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
}

final authProvider = AsyncNotifierProvider<AuthProvider, AuthResponseModel?>(
  AuthProvider.new,
);
