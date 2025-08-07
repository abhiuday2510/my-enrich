import 'package:flutter/material.dart';
import 'package:my_enrich/core/constants/custom_text_field.dart';
import 'package:my_enrich/core/constants/primary_button.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: h * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Create Account ✨',
                    style: TextStyle(
                      fontSize: w * 0.06,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Hero(
                    tag: 'app_logo',
                    flightShuttleBuilder: (_, anim, __, ___, ____) {
                      return ScaleTransition(
                        scale: anim.drive(Tween(begin: 0.7, end: 1.0)),
                        child: Image.asset("assets/icon/icon.png", height: 55),
                      );
                    },
                    child: Image.asset("assets/icon/icon.png", height: 55),
                  ),
                ],
              ),

              SizedBox(height: h * 0.01),
              Text(
                'Sign up to explore and earn rewards',
                style: TextStyle(
                  fontSize: w * 0.04,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              SizedBox(height: h * 0.025),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: w * 0.10,
                    backgroundColor: theme.colorScheme.surface,
                    child: Icon(Icons.camera_alt, size: w * 0.06),
                  ),
                ],
              ),
              SizedBox(height: h * 0.03),
              const CustomTextField(
                hintText: 'Full Name',
                icon: Icons.person,
              ),
              SizedBox(height: h * 0.02),
              Row(
                children: [
                  const Expanded(
                    child: CustomTextField(
                      hintText: 'Email',
                      icon: Icons.email,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Verify'),
                  ),
                ],
              ),
              SizedBox(height: h * 0.02),
              const CustomTextField(
                hintText: 'Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: h * 0.02),
              const CustomTextField(
                hintText: 'Confirm Password',
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              SizedBox(height: h * 0.03),
              PrimaryButton(
                text: 'Sign Up',
                onPressed: () {},
              ),
              SizedBox(height: h * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: TextStyle(fontSize: w * 0.035)),
                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: Text("Login", style: TextStyle(fontSize: w * 0.035)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}