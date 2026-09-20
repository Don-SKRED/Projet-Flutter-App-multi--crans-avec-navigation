import 'package:multi_screen_app_with_navigation/core/storage/secure_storage_service.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/dataSources/auth_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/model/auth_response_model.dart';
import 'package:multi_screen_app_with_navigation/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final RemoteAuthDataSource remoteAuthDataSource;
  final SecureStorageService secureStorage;

  AuthRepositoryImpl(this.remoteAuthDataSource, this.secureStorage);

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    final response = await remoteAuthDataSource.login(email, password);
    await secureStorage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken, // ← bug corrigé, manquait avant
    );
    return response;
  }

  @override
  Future<AuthResponseModel> register(
    String email,
    String password,
    String? username,
  ) async {
    final response = await remoteAuthDataSource.register(
      email,
      password,
      username,
    );
    await secureStorage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return response;
  }

  @override
  Future<void> logout() async {
    try {
      await remoteAuthDataSource.logout();
    } catch (_) {
      // Même si le serveur renvoie une erreur (ex: token déjà révoqué ou pas de réseau),
      // on nettoie toujours le stockage local.
    } finally {
      await secureStorage.clear();
    }
  }

  @override
  Future<AuthResponseModel?> restoreSession() async {
    final accessToken = await secureStorage.accessToken;
    if (accessToken == null) return null; // aucune session locale

    try {
      // getCurrentUser() passe par le Dio configuré avec l'intercepteur :
      // si l'access_token est expiré, le refresh automatique de DioClient
      // se déclenche tout seul AVANT que cette méthode ne reçoive une
      // erreur — donc ce chemin fonctionne même après expiration, tant
      // que le refresh_token est encore valide.
      final user = await remoteAuthDataSource.getCurrentUser();
      final refreshToken = await secureStorage.refreshToken;

      return AuthResponseModel(
        accessToken: accessToken,
        refreshToken: refreshToken ?? '',
        expiresIn: 3600,
        user: user,
      );
    } catch (_) {
      // access_token ET refresh_token invalides/expirés : vraie
      // session expirée, on nettoie pour repartir sur une base saine.
      await secureStorage.clear();
      return null;
    }
  }
}
