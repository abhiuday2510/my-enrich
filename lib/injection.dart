import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/services/firebase_auth_service.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

/// Industry-standard: register low-level services first → repos → providers.
/// Keep creation simple & testable.
List<SingleChildWidget> registerProviders() => [
  Provider<FirebaseAuthService>(create: (_) => FirebaseAuthService()),
  ProxyProvider<FirebaseAuthService, AuthRepository>(
    update: (_, svc, __) => AuthRepositoryImpl(svc),
  ),
  ChangeNotifierProvider<AuthProvider>(
    create: (ctx) => AuthProvider(ctx.read<AuthRepository>()),
  ),
];
