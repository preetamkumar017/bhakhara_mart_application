import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'token';
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  static Future<String?> readAccessToken() async {
    return await _storage.read(key: _tokenKey) ??
        await _storage.read(key: _accessTokenKey);
  }

  static Future<String?> readRefreshToken() =>
      _storage.read(key: _refreshTokenKey);

  static Future<void> writeAccessToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _accessTokenKey, value: token);
  }

  static Future<void> writeRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  static Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
