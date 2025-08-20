import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_enrich/core/services/firebase_auth_service.dart';
import 'package:my_enrich/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _service;

  AuthRepositoryImpl(this._service);

  @override
  Stream<User?> get authState => _service.authStateChanges;

  @override
  User? get currentUser => _service.currentUser;

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) => _service.signInWithEmailAndPassword(email, password);

  @override
  Future<User?> signInWithGoogle() => _service.signInWithGoogle();

  @override
  Future<User?> signUpWithEmailAndPassword(String email, String password) => _service.signUpWithEmailAndPassword(email, password);

  @override
  Future<void> resendVerificationEmail() => _service.resendVerificationEmail();

  @override
  Future<void> reloadUser() => _service.reloadUser();

  @override
  Future<void> signOut() => _service.signOut();

  @override
  Future<void> setDisplayName(String fullName) => _service.setDisplayName(fullName);
}