import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.role = 'pharmacist',
  });
  final String id;
  final String email;
  final String? name;
  final String role;

  factory UserModel.fromJson(Map<String, Object?> json) {
    final id = json['id']?.toString();
    final email = json['email']?.toString();
    if (id == null || email == null) {
      throw const FormatException('User response is missing required fields');
    }
    return UserModel(
      id: id,
      email: email,
      name:
          json['name']?.toString() ??
          json['fullName']?.toString() ??
          json['displayName']?.toString(),
      role:
          json['role']?.toString() ??
          json['userRole']?.toString() ??
          'pharmacist',
    );
  }

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? <String, dynamic>{};
    return UserModel(
      id: document.id,
      email: data['email']?.toString() ?? '',
      name:
          data['name']?.toString() ??
          data['fullName']?.toString() ??
          data['displayName']?.toString(),
      role: data['role']?.toString() ?? data['userRole']?.toString() ?? 'pharmacist',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'email': email,
    'name': name,
    'role': role,
  };

  UserModel copyWith({String? id, String? email, String? name, String? role}) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        role: role ?? this.role,
      );

  User toEntity() => User(id: id, email: email, name: name, role: role);
}
