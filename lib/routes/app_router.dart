import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:my_enrich/features/auth/presentation/providers/auth_provider.dart';
import 'package:my_enrich/features/auth/presentation/page/login_screen.dart';
import 'package:my_enrich/features/auth/presentation/page/signup_screen.dart';
import 'package:my_enrich/features/home/presentation/page/home_screen.dart';
import 'package:my_enrich/features/splash/presentation/splash_screen.dart';
import 'package:my_enrich/features/auth/presentation/page/email_verification_screen.dart';


//TODO : UNDERSTAND THIS COMPLETE ROUTING METHOD

final _log = Logger('AppRouter');

GoRouter createRouter(AuthProvider auth) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: auth, // re-run redirect when auth changes
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => const EmailVerificationScreen(),
      ),
    ],
    redirect: (context, state) {
      final loggedIn = auth.isSignedIn;
      final verified = auth.isEmailVerified;
      final goingTo = state.uri.path;

      _log.fine('Redirect → to=$goingTo, loggedIn=$loggedIn, verified=$verified');

      // Not logged in → allow only splash, login, signup
      if (!loggedIn) {
        if (goingTo == '/' || goingTo == '/login' || goingTo == '/signup') return null;
        return '/login';
      }

      // Logged in but not verified → force /verify-email
      if (loggedIn && !verified) {
        if (goingTo == '/verify-email') return null;
        return '/verify-email';
      }

      // Logged in and verified → prevent going back to auth pages
      if (goingTo == '/login' || goingTo == '/signup' || goingTo == '/verify-email') {
        return '/home';
      }

      return null; // no redirect
    }
  );
}
