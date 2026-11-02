import '../constants/storage_keys.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import 'session_data.dart';

class SessionManager {
  SessionManager(this._secureStorage, this._localStorage);
  final SecureStorage _secureStorage;
  final LocalStorage _localStorage;
  SessionData? _current;

  SessionData? get current => _current;
  String? get accessToken => _current?.accessToken;

  Future<void> save(SessionData session) async {
    await _secureStorage.write(StorageKeys.accessToken, session.accessToken);
    if (session.refreshToken != null) {
      await _secureStorage.write(
        StorageKeys.refreshToken,
        session.refreshToken!,
      );
    }
    if (session.expiresAt != null) {
      await _localStorage.writeInt(
        StorageKeys.expiresAt,
        session.expiresAt!.millisecondsSinceEpoch,
      );
    }
    if (session.userId != null) {
      await _localStorage.writeString(StorageKeys.userId, session.userId!);
    }
    if (session.userEmail != null) {
      await _localStorage.writeString(
        StorageKeys.userEmail,
        session.userEmail!,
      );
    }
    if (session.userName != null) {
      await _localStorage.writeString(StorageKeys.userName, session.userName!);
    }
    if (session.userRole != null) {
      await _localStorage.writeString(StorageKeys.userRole, session.userRole!);
    }
    _current = session;
  }

  Future<SessionData?> restore() async {
    final token = await _secureStorage.read(StorageKeys.accessToken);
    if (token == null || token.isEmpty) return null;
    final expiresAtMillis = await _localStorage.readInt(StorageKeys.expiresAt);
    final session = SessionData(
      accessToken: token,
      refreshToken: await _secureStorage.read(StorageKeys.refreshToken),
      expiresAt:
          expiresAtMillis == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(expiresAtMillis),
      userId: await _localStorage.readString(StorageKeys.userId),
      userEmail: await _localStorage.readString(StorageKeys.userEmail),
      userName: await _localStorage.readString(StorageKeys.userName),
      userRole: await _localStorage.readString(StorageKeys.userRole),
    );
    _current = session;
    return session;
  }

  Future<void> clear() async {
    await _secureStorage.delete(StorageKeys.accessToken);
    await _secureStorage.delete(StorageKeys.refreshToken);
    await _localStorage.clear([
      StorageKeys.expiresAt,
      StorageKeys.userId,
      StorageKeys.userEmail,
      StorageKeys.userName,
      StorageKeys.userRole,
    ]);
    _current = null;
  }
}
