import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/user_model.dart';

class AuthService {
  Future<AuthResponse> login(String email, String password) async {
    try {
      // 1. Obtener tokens
      final url = Uri.parse('${ApiConfig.baseUrl}/api/token/');
      print('🔐 Logging in to: $url');
      print('📧 Email: $email');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('📡 Login response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody);
        print('✅ Tokens received');
        
        final accessToken = data['access'] ?? '';
        final refreshToken = data['refresh'] ?? '';

        // 2. Obtener datos del usuario con el token
        final userUrl = Uri.parse('${ApiConfig.baseUrl}/api/usuarios/me/');
        print('� Fetching user data from: $userUrl');
        
        final userResponse = await http.get(
          userUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
        );

        print('📡 User data response status: ${userResponse.statusCode}');
        print('📦 User data body: ${userResponse.body}');

        if (userResponse.statusCode == 200) {
          final userDecodedBody = utf8.decode(userResponse.bodyBytes);
          final userData = json.decode(userDecodedBody);
          print('✅ Login successful with user data');
          
          // Construir respuesta completa
          return AuthResponse(
            accessToken: accessToken,
            refreshToken: refreshToken,
            user: User.fromJson(userData),
          );
        } else {
          throw Exception('Error al obtener datos del usuario');
        }
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        print('❌ Login failed: $errorBody');
        throw Exception('Credenciales inválidas');
      }
    } catch (e) {
      print('❌ Error in login: $e');
      rethrow;
    }
  }

  Future<AuthResponse> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/api/usuarios/registro/');
      print('📝 Registering user at: $url');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'email': email,
          'password': password,
          'password2': password,
          'first_name': firstName,
          'last_name': lastName,
        }),
      );

      print('📡 Register response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Registration successful');
        
        // Después del registro exitoso, hacer login automático
        return await login(email, password);
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        print('❌ Registration failed: $errorBody');
        throw Exception('Error al registrar usuario');
      }
    } catch (e) {
      print('❌ Error in register: $e');
      rethrow;
    }
  }
}
