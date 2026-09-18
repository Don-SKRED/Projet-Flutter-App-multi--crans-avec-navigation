import 'package:dio/dio.dart';
import 'package:multi_screen_app_with_navigation/core/network/env.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/dio_error_mapper.dart';
import 'package:multi_screen_app_with_navigation/core/storage/secure_storage_service.dart';

class DioClient {
  final SecureStorageService
  storage; // ← reçu de l'extérieur, plus créé en interne

  DioClient({
    required this.storage,
  }); // constructeur normal, plus de singleton codé en dur

  late final Dio dio = _createDio();

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'apikey': Env.apiKey,
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.accessToken;

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            print("token présent");
          } else {
            print("token absent");
          }

          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            throw mapDioException(error);
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
