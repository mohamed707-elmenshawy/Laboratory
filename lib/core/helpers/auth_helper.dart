import 'package:shared_preferences/shared_preferences.dart';

import '../networking/dio_factory.dart';

class AuthHelper {
  AuthHelper._();

  static const String _tokenKey = 'userToken';
  static const String _loggedInKey = 'isUserLoggedIn';
  static const String _tenantKey = 'tenantId';
  static const String _branchKey = 'branchId';

  static Future<bool> restoreSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_loggedInKey) != true) return false;

    final String? token = prefs.getString(_tokenKey);
    if (token == null || token.isEmpty) return false;

    final String? tenantId = prefs.getString(_tenantKey);

    _apply(
      token: token,
      tenantId: (tenantId == null || tenantId.isEmpty) ? null : tenantId,
    );
    return true;
  }

  static Future<void> openSession({
    required String token,
    required String? tenantId,
    required int? branchId,
    required bool persist,
  }) async {
    if (token.isEmpty) return;

    _apply(token: token, tenantId: tenantId);

    if (!persist) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_tenantKey, tenantId ?? '');
    await prefs.setInt(_branchKey, branchId ?? 0);
  }

  static Future<void> closeSession() async {
    DioFactory.clearSessionHeaders();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_loggedInKey);
    await prefs.remove(_tenantKey);
    await prefs.remove(_branchKey);
  }

  static void _apply({required String token, required String? tenantId}) {
    DioFactory.setSessionHeaders(token: token, tenantId: tenantId);
  }
}
