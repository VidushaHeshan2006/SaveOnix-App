import 'package:flutter/material.dart';
import 'signup_screen.dart';
import '../styles/welcome_style.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // App Icon
              const Icon (
                Icons.account_balance_wallet,
                size: 48,
                color: AppStyles.primaryGreen,
              ),

              const SizedBox(height: 10),

              // Title
              const Text("Welcome to SaveOnix!", style: AppStyles.titleText),

              const SizedBox(height: 6),

              // Subtitle
              const Text(
                "Discover everything you can do to manage\nyour finances smarter",
                textAlign: TextAlign.center,
                style: AppStyles.subtitleText,
              ),

              const SizedBox(height: 20),

              // Feature List
              Expanded(
                child: ListView(
                  children: const [
                    FeatureCard(
                      icon: Icons.smart_toy,
                      title: "AI Budget Coach",
                      subtitle:
                          "Get personalized advice, spending predictions, and helpful reminders",
                    ),
                    FeatureCard(
                      icon: Icons.savings,
                      title: "Smart Savings Vault",
                      subtitle:
                          "Set saving goals, track your progress, and stay motivated",
                    ),
                    FeatureCard(
                      icon: Icons.local_offer,
                      title: "Discount Finder",
                      subtitle:
                          "Find discounts at stores you frequently visit",
                    ),
                    FeatureCard(
                      icon: Icons.emoji_events,
                      title: "Badges & Motivation",
                      subtitle:
                          "Earn rewards and badges for reaching milestones",
                    ),
                    FeatureCard(
                      icon: Icons.receipt_long,
                      title: "Bill Reminder",
                      subtitle:
                          "Get timely alerts for your utility and phone bills",
                    ),
                    FeatureCard(
                      icon: Icons.category,
                      title: "Automatic Expense Categorization",
                      subtitle:
                          "Expenses sorted into food, bills, medicine, and more",
                    ),
                    FeatureCard(
                      icon: Icons.insights,
                      title: "Monthly Insights",
                      subtitle:
                          "Clear summaries of your financial activity",
                    ),
                    FeatureCard(
                      icon: Icons.edit,
                      title: "Smart Expense Input",
                      subtitle:
                          "Easily log expenses manually or using images",
                    ),
                  ],
                ),
              ),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to SignUpScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppStyles.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            // ignore: deprecated_member_use
            backgroundColor: AppStyles.primaryGreen.withOpacity(0.15),
            child: Icon(icon, color: AppStyles.primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.cardTitle),
                const SizedBox(height: 4),
                Text(subtitle, style: AppStyles.cardSubtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
