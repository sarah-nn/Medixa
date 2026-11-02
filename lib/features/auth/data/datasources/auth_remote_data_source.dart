import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });
  Future<UserModel> getCurrentUser();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._auth, [FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const ServerException('No authenticated user returned.');
      }

      final mappedUser = await _buildUserModel(user);
      final token = await user.getIdToken() ?? '';

      return AuthResponseModel(
        user: mappedUser,
        accessToken: token,
        refreshToken: null,
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseAuthException(error);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const UnauthorizedException('No active Firebase session.');
    }

    return _buildUserModel(user);
  }

  @override
  Future<void> logout() => _auth.signOut();

  Future<UserModel> _buildUserModel(User user) async {
    final tokenResult = await user.getIdTokenResult();
    final roleClaim = tokenResult.claims?['role'];

    UserModel fallback = UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? user.email?.split('@').first ?? 'صيدلي',
      role: roleClaim?.toString() ?? 'pharmacist',
    );

    try {
      final profileDoc = await _firestore.collection('users').doc(user.uid).get();
      if (profileDoc.exists) {
        final profile = UserModel.fromFirestore(profileDoc);
        fallback = fallback.copyWith(
          name: profile.name ?? fallback.name,
          email: profile.email.isNotEmpty ? profile.email : fallback.email,
          role: profile.role.isNotEmpty ? profile.role : fallback.role,
        );
      }
    } catch (_) {
      // Fallback to Firebase Auth fields when the Firestore profile is unavailable.
    }

    return fallback;
  }

  Exception _mapFirebaseAuthException(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return const ValidationException('صيغة البريد الإلكتروني غير صحيحة.');
      case 'user-not-found':
        return const ValidationException('المستخدم غير موجود.');
      case 'wrong-password':
        return const ValidationException('كلمة المرور غير صحيحة.');
      case 'email-already-in-use':
        return const ValidationException('هذا البريد مستخدم بالفعل.');
      case 'too-many-requests':
        return const ValidationException('تم تجاوز عدد المحاولات. حاول لاحقًا.');
      case 'user-disabled':
        return const ValidationException('تم تعطيل حساب هذا المستخدم.');
      case 'network-request-failed':
        return const NetworkException('تأكد من اتصال الإنترنت وحاول مرة أخرى.');
      default:
        return ServerException(error.message ?? 'حدث خطأ غير متوقع.');
    }
  }
}
