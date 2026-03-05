import 'package:flutter/material.dart';
import '../Services/auth_service.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  void sendOtp() async {
    final email = emailController.text.trim();
    final result = await AuthService().sendOtp(email);

    if (result["error"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["error"])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP sent to email")));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OtpScreen(email: email)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Enter Email")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: sendOtp, child: const Text("Send OTP")),
          ],
        ),
      ),
    );
  }
}