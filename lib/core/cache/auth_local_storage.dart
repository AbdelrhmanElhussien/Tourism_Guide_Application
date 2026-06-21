import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_app/domain/entities/response/auth/auth_response.dart';

class AuthLocalStorage {
  static const String tokenKey = 'auth_token';
  static const String emailKey = 'auth_email';
  static const String userNameKey = 'auth_user_name';
  static const String roleKey = 'auth_role';

  static Future<void> saveAuthResponse(Auth_response authResponse) async {
    final prefs = await SharedPreferences.getInstance();
    final token = authResponse.token;
    final email = authResponse.email;
    final userName = authResponse.userName;
    final role = authResponse.role;

    if (token != null && token.isNotEmpty) {
      await prefs.setString(tokenKey, token);
    }
    if (email != null && email.isNotEmpty) {
      await prefs.setString(emailKey, email);
    }
    if (userName != null && userName.isNotEmpty) {
      await prefs.setString(userNameKey, userName);
    }
    if (role != null && role.isNotEmpty) {
      await prefs.setString(roleKey, role);
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(emailKey);
    await prefs.remove(userNameKey);
    await prefs.remove(roleKey);
  }
}
