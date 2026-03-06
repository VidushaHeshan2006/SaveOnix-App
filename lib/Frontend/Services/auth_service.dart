import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {

  final String baseUrl = "http://10.0.2.2:8000";

  // SIGNUP
  Future<Map<String, dynamic>> signup(String email, String password, String? fullName) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "full_name": fullName
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  // LOGIN
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  // SEND OTP
  Future<Map<String, dynamic>> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/send-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  // VERIFY OTP
  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  // RESET PASSWORD
  Future<Map<String, dynamic>> resetPassword(String email, String otp, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reset-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
          "new_password": newPassword
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"error": e.toString()};
    }
  }
}