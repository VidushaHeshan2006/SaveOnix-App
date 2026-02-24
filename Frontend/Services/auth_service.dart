import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://10.0.2.2:8000";

  // -------------------
  // LOGIN
  // -------------------
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      ).timeout(const Duration(seconds: 20));

      return jsonDecode(response.body);
    } catch (e) {
      return {"error": "Unable to login: $e"};
    }
  }

  // -------------------
  // SIGNUP
  // -------------------
  Future<Map<String, dynamic>> signup(
      String email, String password, String fullName) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "full_name": fullName,
        }),
      ).timeout(const Duration(seconds: 20));

      return jsonDecode(response.body);
    } catch (e) {
      return {"error": "Unable to signup: $e"};
    }
  }
}