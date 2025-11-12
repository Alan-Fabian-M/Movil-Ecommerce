import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _accessToken;
  String? _refreshToken;
  bool _isLoggedIn = false;

  User? get user => _user;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final userId = prefs.getInt('user_id');
      final email = prefs.getString('user_email');
      final firstName = prefs.getString('user_first_name');
      final lastName = prefs.getString('user_last_name');

      if (token != null && userId != null && email != null) {
        _accessToken = token;
        _refreshToken = prefs.getString('refresh_token');
        _user = User(
          id: userId,
          email: email,
          firstName: firstName ?? '',
          lastName: lastName ?? '',
        );
        _isLoggedIn = true;
        notifyListeners();
      }
    } catch (e) {
      print('Error loading user from prefs: $e');
    }
  }

  Future<void> setAuthData(AuthResponse authResponse) async {
    try {
      _user = authResponse.user;
      _accessToken = authResponse.accessToken;
      _refreshToken = authResponse.refreshToken;
      _isLoggedIn = true;

      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', authResponse.accessToken);
      await prefs.setString('refresh_token', authResponse.refreshToken);
      await prefs.setInt('user_id', authResponse.user.id);
      await prefs.setString('user_email', authResponse.user.email);
      await prefs.setString('user_first_name', authResponse.user.firstName);
      await prefs.setString('user_last_name', authResponse.user.lastName);

      notifyListeners();
    } catch (e) {
      print('Error saving auth data: $e');
    }
  }

  Future<void> logout() async {
    try {
      _user = null;
      _accessToken = null;
      _refreshToken = null;
      _isLoggedIn = false;

      // Limpiar SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      await prefs.remove('user_id');
      await prefs.remove('user_email');
      await prefs.remove('user_first_name');
      await prefs.remove('user_last_name');

      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
