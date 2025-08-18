import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_enrich/features/auth/presentation/providers/auth_provider.dart';
import 'package:logging/logging.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _log = Logger('EmailVerificationPage');
  bool _busy = false;
  String? _snack;

  Future<void> _resend(BuildContext context) async {
    setState(() => _busy = true);
    try {
      await context.read<AuthProvider>().resendVerificationEmail();
      setState(() => _snack = 'Verification email sent.');
      _log.info('Verification re-sent.');
    } catch (e) {
      setState(() => _snack = 'Failed to send email. Try again.');
      _log.severe('Resend failed', e);
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _refresh(BuildContext context) async {
    setState(() => _busy = true);
    try {
      await context.read<AuthProvider>().refreshEmailVerification();
      _log.info('Refreshed user state.');
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final verified = context.select<AuthProvider, bool>((p) => p.isEmailVerified);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_snack != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_snack!)));
        _snack = null;
      }
    });

    if (verified) {
      // As soon as verified is true, the AuthGate will redirect to HomePage
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Verify your email')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'We’ve sent a verification link to your email.\n'
                  'Please verify and then tap Refresh.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: _busy ? null : () => _resend(context),
                      child: const Text('Resend email'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: _busy ? null : () => _refresh(context),
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
                if (_busy) const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
