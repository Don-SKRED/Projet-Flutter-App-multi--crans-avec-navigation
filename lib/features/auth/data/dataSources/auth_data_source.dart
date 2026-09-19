import 'package:dio/dio.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/dio_error_mapper.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/model/auth_response_model.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/model/supabase_user_model.dart';

abstract class RemoteAuthDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> register(
    String email,
    String password,
    String? username,
  );
  Future<void> logout();

  /// Récupère le profil de l'utilisateur actuellement authentifié via
  /// `/auth/v1/user`. Le token est injecté automatiquement par
  /// l'intercepteur onRequest de DioClient (via SecureStorageService),
  /// donc aucun paramètre à passer ici.
  Future<SupabaseUserModel> getCurrentUser();
}

class RemoteAuthDataSourceImpl implements RemoteAuthDataSource {
  final Dio dio;
  RemoteAuthDataSourceImpl(this.dio);

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/v1/token?grant_type=password',
        data: {'email': email, 'password': password},
      );
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(
        e,
      ); // ← corrigé : on lance l'exception, pas .message
    }
  }

  @override
  Future<AuthResponseModel> register(
    String email,
    String password,
    String? username,
  ) async {
    try {
      final response = await dio.post(
        '/auth/v1/signup',
        data: {
          'email': email,
          'password': password,
          'data': {if (username != null) 'username': username},
        },
      );
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post('/auth/v1/logout');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<SupabaseUserModel> getCurrentUser() async {
    try {
      final response = await dio.get('/auth/v1/user');
      // Supabase renvoie directement l'objet user (pas d'enveloppe),
      // exactement comme le cas "signup sans session" vu précédemment.
      return SupabaseUserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
