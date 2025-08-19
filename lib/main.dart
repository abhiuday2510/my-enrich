import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_enrich/core/constants/app_theme.dart';
import 'package:my_enrich/core/utils/logger.dart';
import 'package:my_enrich/features/auth/presentation/providers/auth_provider.dart';
import 'package:my_enrich/injection.dart';
import 'package:my_enrich/routes/app_router.dart';
import 'package:provider/provider.dart';

final log = getLogger('FirebaseInit');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLogging();

  try {
    await Firebase.initializeApp();
    log.info('✅ Firebase initialized successfully');
  } catch (e, stackTrace) {
    log.severe('❌ Firebase initialization failed', e, stackTrace);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: registerProviders(),
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final router = createRouter(auth);
          return MaterialApp.router(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

