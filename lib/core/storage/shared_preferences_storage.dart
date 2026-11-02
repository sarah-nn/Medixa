import 'package:shared_preferences/shared_preferences.dart';
import '../errors/exceptions.dart';
import 'local_storage.dart';

class SharedPreferencesStorage implements LocalStorage {
  SharedPreferencesStorage(this._preferences);
  final SharedPreferences _preferences;

  T _run<T>(T Function() action) {
    try {
      return action();
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  Future<String?> readString(String key) async =>
      _run(() => _preferences.getString(key));
  @override
  Future<void> writeString(String key, String value) async {
    await _run(() => _preferences.setString(key, value));
  }

  @override
  Future<bool?> readBool(String key) async =>
      _run(() => _preferences.getBool(key));
  @override
  Future<void> writeBool(String key, bool value) async {
    await _run(() => _preferences.setBool(key, value));
  }

  @override
  Future<int?> readInt(String key) async =>
      _run(() => _preferences.getInt(key));
  @override
  Future<void> writeInt(String key, int value) async {
    await _run(() => _preferences.setInt(key, value));
  }

  @override
  Future<double?> readDouble(String key) async =>
      _run(() => _preferences.getDouble(key));
  @override
  Future<void> writeDouble(String key, double value) async {
    await _run(() => _preferences.setDouble(key, value));
  }

  @override
  Future<List<String>?> readStringList(String key) async =>
      _run(() => _preferences.getStringList(key));
  @override
  Future<void> writeStringList(String key, List<String> value) async {
    await _run(() => _preferences.setStringList(key, value));
  }

  @override
  Future<void> remove(String key) async {
    await _run(() => _preferences.remove(key));
  }

  @override
  Future<void> clear(Iterable<String> keys) async {
    for (final key in keys) {
      await remove(key);
    }
  }
}
