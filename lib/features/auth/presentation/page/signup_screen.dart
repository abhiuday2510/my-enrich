import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

import 'package:my_enrich/core/constants/custom_text_field.dart';
import 'package:my_enrich/core/constants/primary_button.dart';
import 'package:my_enrich/features/auth/presentation/providers/auth_provider.dart';
// If you created a helper like getLogger() in core/utils/logger.dart, you can import and use that instead.
import 'package:my_enrich/core/utils/logger.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Use a named logger so logs are easy to filter
  final _log = Logger('SignUpScreen');

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSignUpPressed(BuildContext context) async {
    // Guard against double-taps
    if (_submitting) return;

    // Validate inputs first
    if (!(_formKey.currentState?.validate() ?? false)) {
      _log.fine('Validation failed');
      return;
    }

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final fullName = _nameCtrl.text.trim();

    setState(() => _submitting = true);
    try {
      _log.info('Sign up start for $email');

      // Call provider → creates user & sends verification email
      final err = await context.read<AuthProvider>().signUpWithEmailAndPassword(email, password);

      if (err != null) {
        _log.warning('Sign up failed: $err');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
        return;
      }

      // Optional: set display name (safe to ignore if not needed)
      await context.read<AuthProvider>().setDisplayName(fullName);

      if (!mounted) return;

      // Tell user what’s next. Router redirect logic will take user to /verify-email.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification link sent. Please check your email.')),
      );

      // You *don’t* need to navigate manually; your GoRouter redirect() will send
      // them to /verify-email when logged in but not verified.
      // If you still want a hard navigation, uncomment:
      // context.go('/verify-email');

    } catch (e, st) {
      _log.severe('Sign up threw unexpected error', e, st);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter your full name';
    if (v.trim().length < 2) return 'Name looks too short';
    return null;
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Minimum 6 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Confirm your password';
    if (v != _passwordCtrl.text) return 'Passwords do not match';
    return null;
  }

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
          child: Form(
            key: _formKey, // <-- enable validation
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

                // Avatar placeholder (keep your UI)
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

                // NOTE: This assumes your CustomTextField supports a `controller` & `validator`.
                // If it doesn’t yet, either add those props to your widget,
                // or replace with a TextFormField here.
                CustomTextField(
                  hintText: 'Full Name',
                  icon: Icons.person,
                  controller: _nameCtrl,
                  validator: _validateName,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: h * 0.02),
                CustomTextField(
                  hintText: 'Email',
                  icon: Icons.email,
                  controller: _emailCtrl,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: h * 0.02),
                CustomTextField(
                  hintText: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                  controller: _passwordCtrl,
                  validator: _validatePassword,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: h * 0.02),
                CustomTextField(
                  hintText: 'Confirm Password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  controller: _confirmCtrl,
                  validator: _validateConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _onSignUpPressed(context),
                ),

                SizedBox(height: h * 0.03),

                PrimaryButton(
                  text: _submitting ? 'Signing Up...' : 'Sign Up',
                  isLoading: _submitting,
                  onPressed: _submitting
                      ? null
                      : () async {
                          await _onSignUpPressed(context);
                        },
                ),
                SizedBox(height: h * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: TextStyle(fontSize: w * 0.035)),
                    TextButton(
                      onPressed: _submitting ? null : () => context.go('/login'),
                      child: Text("Login", style: TextStyle(fontSize: w * 0.035)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
