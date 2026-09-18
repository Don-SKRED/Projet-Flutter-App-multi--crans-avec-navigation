import 'package:multi_screen_app_with_navigation/features/auth/data/model/auth_response_model.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/model/supabase_user_model.dart';
//pour le cas ou confirmation par email est activé

class RegisterOutcomeModel {
  final SupabaseUserModel user;
  final AuthResponseModel? session;

  const RegisterOutcomeModel({required this.user, this.session});

  bool get requiresEmailConfirmation => session == null;

  factory RegisterOutcomeModel.fromJson(Map<String, dynamic> json) {
    return RegisterOutcomeModel(
      user: SupabaseUserModel.fromJson(
        json['user'] as Map<String, dynamic>? ?? json,
      ),
      session: json['access_token'] != null
          ? AuthResponseModel.fromJson(json)
          : null,
    );
  }
}
