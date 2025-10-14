import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/models/auth_model.dart';

/// Service for managing JWT token storage and retrieval
class JwtStorageService {
  static const String _tokenKey = 'jwt_token';
  static const String _authDataKey = 'auth_data';

  final SharedPreferences _prefs;

  JwtStorageService(this._prefs);

  /// Store authentication data
  Future<void> storeAuthData(AuthModel authModel) async {
    final authDataJson = authModel.toJson();
    await _prefs.setString(_authDataKey, jsonEncode(authDataJson));
    await _prefs.setString(_tokenKey, authModel.token);
  }

  /// Get stored authentication data
  Future<AuthModel?> getAuthData() async {
    try {
      final authDataString = _prefs.getString(_authDataKey);
      if (authDataString == null) return null;

      final authDataJson = jsonDecode(authDataString) as Map<String, dynamic>;
      return AuthModel.fromJson(authDataJson);
    } catch (e) {
      return null;
    }
  }

  /// Get stored JWT token
  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  /// Check if user has valid stored authentication
  Future<bool> hasValidAuth() async {
    final authData = await getAuthData();
    if (authData == null) return false;
    
    return authData.isValid;
  }

  /// Clear all authentication data
  Future<void> clearAuthData() async {
    await _prefs.remove(_authDataKey);
    await _prefs.remove(_tokenKey);
  }

  /// Update stored token
  Future<void> updateToken(String newToken) async {
    final authData = await getAuthData();
    if (authData != null) {
      final updatedAuth = AuthModel(
        token: newToken,
        userId: authData.userId,
        email: authData.email,
        name: authData.name,
        expiresAt: authData.expiresAt,
        isAuthenticated: authData.isAuthenticated,
      );
      await storeAuthData(updatedAuth);
    }
  }

  /// Check if token is expired
  Future<bool> isTokenExpired() async {
    final authData = await getAuthData();
    if (authData == null) return true;
    
    return authData.isTokenExpired;
  }
}
