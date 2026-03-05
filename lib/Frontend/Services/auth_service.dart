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

  // -------------------
  // FORGOT PASSWORD (Send OTP to Email)
  // -------------------
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/forgot-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {"error": "Failed to send reset email: $e"};
    }
  }

  // -------------------
  // VERIFY OTP
  // -------------------
  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "token": otp,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {"error": "OTP verification failed: $e"};
    }
  }

  // -------------------
  // RESET PASSWORD
  // -------------------
  Future<Map<String, dynamic>> resetPassword(String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reset-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "new_password": newPassword,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {"error": "Password reset failed: $e"};
    }
  }
}