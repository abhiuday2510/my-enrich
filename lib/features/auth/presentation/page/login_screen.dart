import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'package:my_enrich/core/constants/circular_avatar_button.dart';
import 'package:my_enrich/core/constants/custom_text_field.dart';
import 'package:my_enrich/core/constants/primary_button.dart';
import 'package:my_enrich/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _log = Logger('LoginScreen');

  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Email is required';
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!re.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Minimum 6 characters';
    return null;
  }

  Future<void> _onLoginPressed(BuildContext context) async {
    if (_submitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) {
      _log.fine('Validation failed');
      return;
    }

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    setState(() => _submitting = true);
    try {
      _log.info('Login start for $email');

      final err = await context.read<AuthProvider>().signInWithEmailAndPassword(email, password);

      if (err != null) {
        _log.warning('Login failed: $err');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
        return;
      }

      // Don’t navigate manually; GoRouter redirect() will send:
      // - unverified users → /verify-email
      // - verified users → /home
      _log.info('Login success');
    } catch (e, st) {
      _log.severe('Login threw unexpected error', e, st);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _onForgotPassword(BuildContext context) async {
    // Optional UX: open a dialog to collect email and trigger password reset.
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email above, then tap Forgot Password')),
      );
      return;
    }
    try {
      // If you want a clean abstraction, add `sendPasswordResetEmail` in your repo/service.
      // For now we can call FirebaseAuth directly in your service, but keeping it simple here:
      // await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset link sent if the email exists.')),
      );
      _log.info('Password reset requested for $email');
    } catch (e, st) {
      _log.severe('Password reset failed', e, st);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send reset link. Try again later.')),
      );
    }
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.08),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: h * 0.06),
                  Center(
                    child: Hero(
                      tag: 'app_logo',
                      child: Image.asset("assets/icon/icon.png", scale: w * 0.017),
                    ),
                  ),
                  SizedBox(height: h * 0.04),
                  Text(
                    'Welcome 👋',
                    style: TextStyle(
                      fontSize: w * 0.07,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    'Please login to your account',
                    style: TextStyle(
                      fontSize: w * 0.04,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: h * 0.04),

                  // Email
                  CustomTextField(
                    hintText: 'Email',
                    icon: Icons.email,
                    controller: _emailCtrl,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: h * 0.02),

                  // Password
                  CustomTextField(
                    hintText: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                    controller: _passwordCtrl,
                    validator: _validatePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) async {
                      if (!_submitting) {
                        await _onLoginPressed(context);
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            onPressed: _submitting ? null : () => context.go('/signup'),
                            style: TextButton.styleFrom(padding: EdgeInsets.zero),
                            child: Text(
                              "Sign Up!",
                              style: TextStyle(fontSize: w * 0.03),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _submitting ? null : () => _onForgotPassword(context),
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
                    text: _submitting ? 'Logging in...' : 'Login',
                    isLoading: _submitting,
                    onPressed: _submitting
                        ? null
                        : () async {
                            await _onLoginPressed(context);
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
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                          // TODO: Google login logic (later)
                          _log.info('Google login tapped');
                        },
                      ),
                      SizedBox(width: w * 0.06),
                      CicularAvatarButton(
                        assetPath: 'assets/social/facebook.png',
                        iconSize: w * 0.07,
                        onTap: () {
                          // TODO: Facebook login logic (later)
                          _log.info('Facebook login tapped');
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
      ),
    );
  }
}
