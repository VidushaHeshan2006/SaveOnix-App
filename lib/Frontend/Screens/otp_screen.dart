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

    final result = await AuthService()
        .verifyOtp(widget.email, otpController.text);

    if(result["message"] != null){

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ResetPasswordScreen(),
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
              decoration: const InputDecoration(
                  labelText: "Enter OTP"
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: verifyOtp,
              child: const Text("Verify"),
            )
          ],
        ),
      ),
    );
  }
}