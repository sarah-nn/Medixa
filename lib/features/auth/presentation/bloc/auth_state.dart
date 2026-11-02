import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.initial, this.user, this.message});
  final AuthStatus status;
  final User? user;
  final String? message;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? message,
    bool clearUser = false,
  }) => AuthState(
    status: status ?? this.status,
    user: clearUser ? null : user ?? this.user,
    message: message,
  );

  @override
  List<Object?> get props => [status, user, message];
}
