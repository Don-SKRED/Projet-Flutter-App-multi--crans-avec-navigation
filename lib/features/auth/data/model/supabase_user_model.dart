class SupabaseUserModel {
  final String id; // UUID, pas un int comme DummyJSON
  final String email;
  final String? phone;
  final DateTime? emailConfirmedAt;
  final DateTime createdAt;
  final Map<String, dynamic>?
  userMetadata; // données custom (nom, avatar, etc.)

  const SupabaseUserModel({
    required this.id,
    required this.email,
    this.phone,
    this.emailConfirmedAt,
    required this.createdAt,
    this.userMetadata,
  });

  factory SupabaseUserModel.fromJson(Map<String, dynamic> json) {
    return SupabaseUserModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      emailConfirmedAt: json['email_confirmed_at'] != null
          ? DateTime.tryParse(json['email_confirmed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      userMetadata: json['user_metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'email_confirmed_at': emailConfirmedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'user_metadata': userMetadata,
    };
  }

  bool get isEmailConfirmed => emailConfirmedAt != null;
}
