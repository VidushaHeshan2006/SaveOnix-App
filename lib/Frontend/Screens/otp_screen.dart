import 'package:flutter/material.dart';
import '../Services/auth_service.dart';
import 'reset_password_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();

  void verifyOtp() async {
    final result = await AuthService().verifyOtp(widget.email, otpController.text.trim());

    if (result["error"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["error"])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP Verified")));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(email: widget.email, otp: otpController.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              decoration: const InputDecoration(labelText: "Enter OTP"),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: verifyOtp, child: const Text("Verify")),
          ],
        ),
      ),
    );
  }
}