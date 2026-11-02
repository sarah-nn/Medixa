import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    this.name,
    this.role = 'pharmacist',
  });
  final String id;
  final String email;
  final String? name;
  final String role;

  String get displayName => name ?? email.split('@').first;

  @override
  List<Object?> get props => [id, email, name, role];
}
