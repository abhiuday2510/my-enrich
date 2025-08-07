import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_enrich/core/constants/circular_avatar_button.dart';
import 'package:my_enrich/core/constants/custom_text_field.dart';
import 'package:my_enrich/core/constants/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: h * 0.06),
                Center(
                  child: Hero(
                      tag: 'app_logo',
                      child: Image.asset("assets/icon/icon.png", scale: w * 0.017)
                    ),
                ),
                SizedBox(height: h * 0.04),
                Text(
                  'Welcome 👋',
                  style: TextStyle(
                    fontSize: w * 0.07,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                SizedBox(height: h * 0.01),
                Text(
                  'Please login to your account',
                  style: TextStyle(
                    fontSize: w * 0.04,
                    color: theme.colorScheme.onBackground.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: h * 0.04),

                // email field
                const CustomTextField(
                  hintText: 'Email',
                  icon: Icons.email,
                ),

                SizedBox(height: h * 0.02),

                // password field
                const CustomTextField(
                  hintText: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                SizedBox(height: h * 0.015),

                // Sign up and Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Not yet Registered? ",
                          style: TextStyle(fontSize: w * 0.03),
                        ),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).go('/signup');
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Text(
                            "Sign Up!",
                            style: TextStyle(fontSize: w * 0.03),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Forgot password logic
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(fontSize: w * 0.03),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: h * 0.015),

                // Login Button
                PrimaryButton(
                  text: 'Login',
                  onPressed: () {
                    GoRouter.of(context).go('/home');
                  },
                ),

                SizedBox(height: h * 0.035),

                // Or separator
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                      child: Text(
                        'or sign in with',
                        style: TextStyle(
                          fontSize: w * 0.035,
                          color: theme.colorScheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: h * 0.02),

                // Social Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CicularAvatarButton(
                      assetPath: 'assets/social/google.png',
                      iconSize: w * 0.08,
                      onTap: () {
                        // Google login logic
                      },
                    ),
                    SizedBox(width: w * 0.06),
                    CicularAvatarButton(
                      assetPath: 'assets/social/facebook.png',
                      iconSize: w * 0.07,
                      onTap: () {
                        // Facebook login logic
                      },
                    ),
                  ],
                ),
                SizedBox(height: h * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
