import '../../../../core/session/session_data.dart';
import '../../../../core/session/session_manager.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveSession(SessionData session);
  Future<SessionData?> getSession();
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._sessionManager);
  final SessionManager _sessionManager;

  @override
  Future<void> saveSession(SessionData session) =>
      _sessionManager.save(session);
  @override
  Future<SessionData?> getSession() => _sessionManager.restore();
  @override
  Future<void> clearSession() => _sessionManager.clear();
}
