import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_screen_app_with_navigation/core/network/dio_client.dart';
import 'package:multi_screen_app_with_navigation/core/storage/secure_storage_service.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(storage: ref.watch(secureStorageProvider));
});
final apiClientProvider = Provider<Dio>((ref) {
  return ref.watch(dioClientProvider).dio;
});
