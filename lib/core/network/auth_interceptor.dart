import 'package:dio/dio.dart';
import '../session/session_manager.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._sessionManager);
  final SessionManager _sessionManager;
  static const _publicPaths = {'/auth/login', '/auth/register'};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!_publicPaths.contains(options.path)) {
      final token = _sessionManager.accessToken;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
