import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = "access_token";
  static const _refreshKey = "refresh_key";
  static const _role = "user_role";
  static const _category = "user_category";
  static const _rememberMe = "remember_me";
  static const _rememberedEmail = "remembered_email";
  static const _rememberedPassword = "remembered_password";

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

  static Future<void> saveRememberedLogin({
    required bool enabled,
    required String scopeKey,
    String? email,
    String? password,
  }) async {
    final scope = _normalizeScope(scopeKey);
    await _storage.write(
      key: _rememberMeKey(scope),
      value: enabled ? "true" : "false",
    );

    if (!enabled) {
      await clearRememberedLogin(scopeKey: scope);
      return;
    }

    await _storage.write(key: _rememberedEmailKey(scope), value: email ?? "");
    await _storage.write(
      key: _rememberedPasswordKey(scope),
      value: password ?? "",
    );
  }

  static Future<void> clearRememberedLogin({required String scopeKey}) async {
    final scope = _normalizeScope(scopeKey);
    await _storage.delete(key: _rememberedEmailKey(scope));
    await _storage.delete(key: _rememberedPasswordKey(scope));
  }

  static Future<bool> isRememberMeEnabled({required String scopeKey}) async {
    final scope = _normalizeScope(scopeKey);
    final value = await _storage.read(key: _rememberMeKey(scope));
    return value == "true";
  }

  static Future<String?> getRememberedEmail({required String scopeKey}) async {
    final scope = _normalizeScope(scopeKey);
    return await _storage.read(key: _rememberedEmailKey(scope));
  }

  static Future<String?> getRememberedPassword({
    required String scopeKey,
  }) async {
    final scope = _normalizeScope(scopeKey);
    return await _storage.read(key: _rememberedPasswordKey(scope));
  }

  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  static String _normalizeScope(String scope) {
    final normalized = scope.trim().toLowerCase();
    return normalized.isEmpty ? 'default' : normalized;
  }

  static String _rememberMeKey(String scope) => "${_rememberMe}_$scope";
  static String _rememberedEmailKey(String scope) =>
      "${_rememberedEmail}_$scope";
  static String _rememberedPasswordKey(String scope) =>
      "${_rememberedPassword}_$scope";
}
