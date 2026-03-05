import 'package:flutter/material.dart';
import '../Services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();

  void resetPassword() async {
    final result = await AuthService().resetPassword(
      widget.email,
      widget.otp,
      passwordController.text.trim(),
    );

    if (result["message"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password Updated")));
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (result["error"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["error"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "New Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: resetPassword, child: const Text("Update Password")),
          ],
        ),
      ),
    );
  }
}