import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color.from(alpha: 0.906, red: 0.098, green: 0.098, blue: 0.098); // Dark background
  static const Color primaryGreen = Color.fromARGB(255, 15, 164, 110);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color white = Colors.white;
  static const Color error = Color(0xFFE53935);
  static const Color inputFill = Color.fromARGB(121, 63, 63, 63);
}

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.grey,
  );

  static const TextStyle link = TextStyle(
    fontSize: 14,
    color: AppColors.primaryGreen,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle error = TextStyle(
    fontSize: 12,
    color: AppColors.error,
  );

  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );
  
}

class AppInputDecorations {
  static InputDecoration textFieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.grey),
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

  static InputDecoration errorDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.grey),
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      errorText: "Password does not match",
      errorStyle: const TextStyle(color: AppColors.error),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
