import 'package:equatable/equatable.dart';

class SessionData extends Equatable {
  const SessionData({
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.userId,
    this.userEmail,
    this.userName,
    this.userRole,
  });
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final String? userId;
  final String? userEmail;
  final String? userName;
  final String? userRole;

  bool get isExpired =>
      expiresAt != null && expiresAt!.isBefore(DateTime.now());

  @override
  List<Object?> get props => [
    accessToken,
    refreshToken,
    expiresAt,
    userId,
    userEmail,
    userName,
    userRole,
  ];
}
