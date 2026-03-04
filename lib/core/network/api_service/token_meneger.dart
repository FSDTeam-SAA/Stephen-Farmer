import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = "access_token";
  static const _refreshKey = "refresh_key";
  static const _role = "user_role";
  static const _category = "user_category";

  static Future<void> saveToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  static Future<void> accessToken(String token) async {
    debugPrint("Saving access token");
    await _storage.write(key: _accessTokenKey, value: token);
  }

  static Future<void> saveRole(String role) async {
    await _storage.write(key: _role, value: role);
  }

  static Future<void> saveCategory(String category) async {
    await _storage.write(key: _category, value: category);
  }

  static Future<void> refreshToken(String token) async {
    await _storage.write(key: _refreshKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshKey);
  }

  static Future<String?> getRole() async {
    return await _storage.read(key: _role);
  }

  static Future<String?> getCategory() async {
    return await _storage.read(key: _category);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshKey);
    await _storage.delete(key: _role);
    await _storage.delete(key: _category);
  }

  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _accessTokenKey);
    return token != null && token.isNotEmpty;
  }
}
