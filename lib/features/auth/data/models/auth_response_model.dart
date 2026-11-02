import 'user_model.dart';

class AuthResponseModel {
  const AuthResponseModel({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });
  final UserModel user;
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;

  factory AuthResponseModel.fromJson(Map<String, Object?> json) {
    final token = json['accessToken'] ?? json['access_token'];
    final userJson = json['user'];
    if (token is! String || userJson is! Map) {
      throw const FormatException('Login response is missing required fields');
    }
    final expires = json['expiresAt'] ?? json['expires_at'];
    return AuthResponseModel(
      user: UserModel.fromJson(Map<String, Object?>.from(userJson)),
      accessToken: token,
      refreshToken: (json['refreshToken'] ?? json['refresh_token'])?.toString(),
      expiresAt: expires is String ? DateTime.tryParse(expires) : null,
    );
  }
}
