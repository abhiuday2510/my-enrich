import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get authState;
  User? get currentUser;

  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> signUpWithEmailAndPassword(String email, String password);

  Future<void> resendVerificationEmail();
  Future<void> reloadUser();
  Future<void> signOut();
  Future<void> setDisplayName(String fullName);
}