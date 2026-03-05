import 'package:flutter/material.dart';
import '../Services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final passwordController = TextEditingController();

  void resetPassword() async {

    final result = await AuthService()
        .resetPassword(passwordController.text);

    if(result["message"] != null){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password Updated")),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
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
              decoration: const InputDecoration(
                  labelText: "New Password"
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: resetPassword,
              child: const Text("Update Password"),
            )
          ],
        ),
      ),
    );
  }
}