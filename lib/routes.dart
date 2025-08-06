import 'package:go_router/go_router.dart';
import 'package:my_enrich/features/auth/presentation/page/login_screen.dart';
import 'package:my_enrich/features/auth/presentation/page/signup_screen.dart';
import 'package:my_enrich/features/splash/presentation/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
  ],
);