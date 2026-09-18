import 'package:multi_screen_app_with_navigation/core/storage/secure_storage_service.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/dataSources/auth_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/model/auth_response_model.dart';
import 'package:multi_screen_app_with_navigation/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final RemoteAuthDataSource remoteAuthDataSource;
  final SecureStorageService secureStorage; // ← ajouté

  AuthRepositoryImpl(this.remoteAuthDataSource, this.secureStorage);

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    final response = await remoteAuthDataSource.login(email, password);
    await secureStorage.saveTokens(
      accessToken: response.accessToken,
    ); // ← sauvegarde ici
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
    await remoteAuthDataSource.logout();
    await secureStorage.clear(); // ← nettoyage à la déconnexion
  }
}
