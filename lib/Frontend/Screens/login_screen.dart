import 'package:flutter/material.dart';
import '../Styles/login_style.dart';
import "../Services/auth_service.dart";
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        "            Welcome Back",
                        style: AppTextStyle.heading,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "                      Log in to manage your finance",
                        style: AppTextStyle.subHeading,
                      ),
                      const SizedBox(height: 40),

                      const Text("Email / Username",
                          style: AppTextStyle.label),
                      const SizedBox(height: 8),
                      TextField(
                        controller: emailController,
                        decoration: AppInputStyle.inputDecoration(
                          hint: "Enter your email or username",
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Password", style: AppTextStyle.label),
                          Text(
                            "Forget password ?",
                            style: TextStyle(color: AppColors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: AppInputStyle.inputDecoration(
                          hint: "Enter your password",
                          suffixIcon:
                              Icon(Icons.visibility_off, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 30),

                      
                      // LOGIN BUTTON
                    
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: AppButtonStyle.greenButton,
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setState(() => isLoading = true);

                                  final email = emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();

                                  final result = await AuthService()
                                      .login(email, password);

                                  setState(() => isLoading = false);

                                  if (result == null ||
                                      result.containsKey("error") ||
                                      result["user"] == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            result?["error"] ?? "Login failed"),
                                      ),
                                    );
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            DashboardScreen(user: result["user"]),
                                      ),
                                    );
                                  }
                                },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        children: const [
                          Expanded(child: Divider(color: Colors.grey)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child:
                                Text("OR", style: TextStyle(color: Colors.grey)),
                          ),
                          Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.g_mobiledata,
                                color: Colors.white, size: 30),
                            SizedBox(width: 8),
                            Text(
                              "Login with Google",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}