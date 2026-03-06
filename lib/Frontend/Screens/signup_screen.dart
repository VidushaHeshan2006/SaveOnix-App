import 'package:flutter/material.dart';
import '../Styles/signup_style.dart';
import '../Services/auth_service.dart';
import 'dashboard.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
 
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final AuthService authService = AuthService();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool isLoading = false;
  String? errorMessage;

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
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      /// HEADER
                      const Text(
                        "           Create Your Account",
                        style: AppTextStyles.title,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "                      Start your smart budgeting journey",
                        style: AppTextStyles.subtitle,
                      ),
                      const SizedBox(height: 30),

                      /// FULL NAME
                      const Text("Full Name", style: AppTextStyles.inputText),
                      const SizedBox(height: 5),
                      TextField(
                        controller: fullNameController,
                        style: AppTextStyles.inputText,
                        decoration: AppInputDecorations.textFieldDecoration(
                            "Enter your full name"),
                      ),
                      const SizedBox(height: 20),

                      /// EMAIL
                      const Text("Email", style: AppTextStyles.inputText),
                      const SizedBox(height: 5),
                      TextField(
                        controller: emailController,
                        style: AppTextStyles.inputText,
                        decoration:
                            AppInputDecorations.textFieldDecoration(
                                "Enter your email"),
                      ),
                      const SizedBox(height: 20),

                      /// PASSWORD
                      const Text("Password", style: AppTextStyles.inputText),
                      const SizedBox(height: 5),
                      TextField(
                        controller: passwordController,
                        style: AppTextStyles.inputText,
                        obscureText: !passwordVisible,
                        decoration: AppInputDecorations
                            .textFieldDecoration("Enter your password")
                            .copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// CONFIRM PASSWORD
                      const Text("Confirm Password",
                          style: AppTextStyles.inputText),
                      const SizedBox(height: 5),
                      TextField(
                        controller: confirmPasswordController,
                        style: AppTextStyles.inputText,
                        obscureText: !confirmPasswordVisible,
                        decoration: AppInputDecorations
                            .textFieldDecoration("Confirm your password")
                            .copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              confirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                confirmPasswordVisible =
                                    !confirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            errorMessage = value != passwordController.text
                                ? "Passwords do not match"
                                : null;
                          });
                        },
                      ),

                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(errorMessage!,
                              style: AppTextStyles.error),
                        ),

                      const SizedBox(height: 30),

                      /// SIGNUP BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 15, 164, 110),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (passwordController.text !=
                                      confirmPasswordController.text) {
                                    setState(() {
                                      errorMessage = "Passwords do not match";
                                    });
                                    return;
                                  }

                                  setState(() {
                                    isLoading = true;
                                  });

                                  final result = await authService.signup(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                    fullNameController.text.trim(),
                                  );

                                  setState(() {
                                    isLoading = false;
                                  });

                                  if (result["error"] != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text(result["error"] ?? "Error")),
                                    );
                                  } else if (result["user"] == null) {
                                    // User exists but email not confirmed
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Signup successful! Please check your email to confirm your account."),
                                      ),
                                    );
                                  } else {
                                    // User is verified and can go to Dashboard
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DashboardScreen(
                                            user: result["user"]),
                                      ),
                                    );
                                  }
                                },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? ",
                              style: AppTextStyles.subtitle),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              "Log In",
                              style: AppTextStyles.link,
                            ),
                          ),
                        ],
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