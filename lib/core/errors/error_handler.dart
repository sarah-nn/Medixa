import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'exceptions.dart';
import 'failures.dart';

abstract final class ErrorHandler {
  static Failure map(Object error) {
    if (error is UnauthorizedException) {
      return UnauthorizedFailure(error.message ?? '');
    }
    if (error is NetworkException) {
      return NetworkFailure(error.message ?? '');
    }
    if (error is CacheException) {
      return CacheFailure(error.message ?? '');
    }
    if (error is ParsingException) {
      return ParsingFailure(error.message ?? '');
    }
    if (error is ValidationException) {
      return ValidationFailure(error.message ?? '');
    }
    if (error is ServerException) {
      return ServerFailure(error.message ?? '');
    }
    if (error is FirebaseAuthException) {
      return _mapFirebaseAuth(error);
    }
    if (error is DioException) {
      return _mapDio(error);
    }
    return const UnexpectedFailure();
  }

  static Failure _mapDio(DioException error) {
    if (error.type == DioExceptionType.cancel) {
      return const NetworkFailure('The request was cancelled.');
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    if (error.response?.statusCode == 401) {
      return const UnauthorizedFailure();
    }
    if (error.response?.statusCode != null) {
      return const ServerFailure();
    }
    return const UnexpectedFailure();
  }

  static Failure _mapFirebaseAuth(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return const ValidationFailure('صيغة البريد الإلكتروني غير صحيحة.');
      case 'user-not-found':
        return const ValidationFailure('المستخدم غير موجود.');
      case 'wrong-password':
        return const ValidationFailure('كلمة المرور غير صحيحة.');
      case 'email-already-in-use':
        return const ValidationFailure('هذا البريد مستخدم بالفعل.');
      case 'too-many-requests':
        return const ValidationFailure('تم تجاوز عدد المحاولات. حاول لاحقًا.');
      case 'user-disabled':
        return const ValidationFailure('تم تعطيل حساب هذا المستخدم.');
      case 'network-request-failed':
        return const NetworkFailure('تأكد من اتصال الإنترنت وحاول مرة أخرى.');
      default:
        return ValidationFailure(error.message ?? 'حدث خطأ غير متوقع.');
    }
  }
}
