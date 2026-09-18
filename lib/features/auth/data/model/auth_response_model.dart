import 'package:multi_screen_app_with_navigation/features/auth/data/model/supabase_user_model.dart';

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final int expiresIn; // secondes avant expiration de l'access_token
  final SupabaseUserModel user;

  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: json['expires_in'] as int? ?? 3600,
      user: SupabaseUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
// Format de réponse typique du login
// json
// {
//   "access_token": "eyJhbGciOi...",
//   "token_type": "bearer",
//   "expires_in": 3600,
//   "refresh_token": "xxxxxx",
//   "user": {
//     "id": "uuid-...",
//     "email": "user@example.com",
//     "email_confirmed_at": "2026-09-01T...",
//     ...
//   }
// }