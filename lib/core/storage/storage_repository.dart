import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyAccessToken = 'KEY_ACCESS_TOKEN';
const _keyRefreshToken = 'KEY_REFRESH_TOKEN';

abstract class StorageRepository {
  Future<String?> get accessToken;

  Future<String?> get refreshToken;

  Future<void> storeAccessToken(String accessToken);

  Future<void> storeRefreshToken(String refreshToken);

  Future<void> clearAllStorage();
}

@Singleton(as: StorageRepository)
class StorageRepositoryImpl extends StorageRepository {
  StorageRepositoryImpl({
    required FlutterSecureStorage storage,
    required SharedPreferences pref,
  })  : _pref = pref,
        _storage = storage {
    _validateFirstInstall();
  }

  final FlutterSecureStorage _storage;
  final SharedPreferences _pref;

  Future<void> _validateFirstInstall() async {
    if (_pref.getBool('first_run') ?? true) {
      await clearAllStorage();
      _pref.setBool('first_run', false);
    }
  }

  @override
  Future<String?> get accessToken => _storage.read(key: _keyAccessToken);

  @override
  Future<String?> get refreshToken => _storage.read(key: _keyRefreshToken);

  @override
  Future<void> storeAccessToken(String accessToken) {
    return _storage.write(key: _keyAccessToken, value: accessToken);
  }

  @override
  Future<void> storeRefreshToken(String refreshToken) {
    return _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  @override
  Future<void> clearAllStorage() {
    return _storage.deleteAll();
  }
}
