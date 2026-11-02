import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../session/session_manager.dart';
import 'auth_interceptor.dart';

class DioClient {
  DioClient(SessionManager sessionManager)
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: ApiConstants.connectTimeout,
          receiveTimeout: ApiConstants.receiveTimeout,
          sendTimeout: ApiConstants.sendTimeout,
          responseType: ResponseType.json,
        ),
      )..interceptors.add(AuthInterceptor(sessionManager));
  final Dio dio;
}
