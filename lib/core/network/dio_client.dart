import 'package:dio/dio.dart';
import 'package:multi_screen_app_with_navigation/core/network/env.dart';
import 'package:multi_screen_app_with_navigation/core/storage/secure_storage_service.dart';

class DioClient {
  final SecureStorageService
  storage; // ← reçu de l'extérieur, plus créé en interne

  DioClient({
    required this.storage,
  }); // constructeur normal, plus de singleton codé en dur

  bool _isRefreshing = false;

  // Dio "nu", SANS intercepteur, dédié uniquement à l'appel de refresh.
  // Indispensable pour éviter que le refresh lui-même, s'il échoue en 401,
  // ne redéclenche cet intercepteur en boucle infinie.
  late final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      headers: {'Content-Type': 'application/json', 'apikey': Env.apiKey},
    ),
  );

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
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          final isUnauthorized = error.response?.statusCode == 401;
          final alreadyRetried = error.requestOptions.extra['retried'] == true;

          if (isUnauthorized && !alreadyRetried) {
            if (_isRefreshing) {
              // Un refresh est déjà en cours pour une autre requête :
              // on abandonne celle-ci plutôt que de relancer un 2e refresh.
              return handler.next(error);
            }

            _isRefreshing = true;
            try {
              final refreshToken = await storage.refreshToken;
              if (refreshToken == null) {
                _isRefreshing = false;
                return handler.next(error);
              }

              final response = await _refreshDio.post(
                '/auth/v1/token?grant_type=refresh_token',
                data: {'refresh_token': refreshToken},
              );

              final newAccessToken = response.data['access_token'] as String;
              final newRefreshToken = response.data['refresh_token'] as String;

              await storage.saveTokens(
                accessToken: newAccessToken,
                refreshToken: newRefreshToken,
              );

              _isRefreshing = false;

              // On rejoue la requête d'origine avec le nouveau token.
              final retryOptions = error.requestOptions;
              retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
              retryOptions.extra['retried'] = true;

              final cloned = await _refreshDio.fetch(retryOptions);
              return handler.resolve(cloned);
            } on DioException catch (_) {
              // Le refresh_token lui-même est invalide/expiré :
              // vraie session expirée, on efface tout localement.
              _isRefreshing = false;
              await storage.clear();
              return handler.next(error);
            }
          }

          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
