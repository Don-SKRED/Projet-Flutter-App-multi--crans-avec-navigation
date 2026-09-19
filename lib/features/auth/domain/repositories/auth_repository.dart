import 'package:multi_screen_app_with_navigation/features/auth/data/model/auth_response_model.dart';

abstract class AuthRepository {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> register(
    String email,
    String password,
    String? username,
  );
  Future<void> logout();

  /// Tente de restaurer une session existante depuis le stockage local
  /// (utilisé au démarrage de l'app). Retourne `null` si aucune session
  /// valide n'existe (pas de token, ou refresh_token expiré/révoqué).
  Future<AuthResponseModel?> restoreSession();
}
// {
//   "email": "test@example.com",
//   "password": "motdepasse123",
//   "data": {
//     "username": "jean_dupont"
//   }
// }