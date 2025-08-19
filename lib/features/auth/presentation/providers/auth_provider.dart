import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_enrich/core/utils/logger.dart';
import 'package:my_enrich/features/auth/domain/repositories/auth_repository.dart';


class AuthProvider with ChangeNotifier {

  final _log = getLogger('AuthProvider');
  final AuthRepository _repo;

  AuthProvider(this._repo) {
    // Keep local state in sync with Firebase auth stream (persistent across restarts)
    _repo.authState.listen((user) {
      _log.info('authState changed; uid=${user?.uid}, emailVerified=${user?.emailVerified}');
      _user = user;
      notifyListeners();
    });
  }

  User? _user;
  User? get user => _user;

  bool get isSignedIn => _user != null;
  bool get isEmailVerified => _user?.emailVerified ?? false;

  // Sign-in with email & password; returns error message on failure (null on success)
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      _log.info('signIn start');
      final u = await _repo.signInWithEmailAndPassword(email, password);
      _user = u;
      notifyListeners();
      _log.info('signIn success; verified=${u?.emailVerified}');
      return null;
    } on FirebaseAuthException catch (e, st) {
      _log.severe('signIn failed: ${e.code}', e, st);
      return e.message;
    } catch (e, st) {
      _log.severe('signIn failed (unknown)', e, st);
      return 'Something went wrong. Please try again.';
    }
  }

  // Sign-up + send verification email; returns error message on failure (null on success)
  Future<String?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      _log.info('signUp start');
      final u = await _repo.signUpWithEmailAndPassword(email, password);
      _user = u;
      notifyListeners();
      _log.info('signUp success; verification sent to ${u?.email}');
      return null;
    } on FirebaseAuthException catch (e, st) {
      _log.severe('signUp failed: ${e.code}', e, st);
      return e.message;
    } catch (e, st) {
      _log.severe('signUp failed (unknown)', e, st);
      return 'Something went wrong. Please try again.';
    }
  }

  Future<void> resendVerificationEmail() async {
    _log.info('resendVerificationEmail');
    await _repo.resendVerificationEmail();
  }

  // Reload user from server to get the latest `emailVerified` value.
  Future<void> refreshEmailVerification() async {
    _log.info('refreshEmailVerification');
    await _repo.reloadUser();
    _user = _repo.currentUser; // pick reloaded instance
    notifyListeners();
  }

  Future<void> signOut() async {
    _log.info('signOut');
    await _repo.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> setDisplayName(String fullName) async{
    try {
        _log.fine('Attempting to set displayName to "$fullName"');
        await _repo.setDisplayName(fullName);
      } catch (e, st) {
        _log.warning('Display name update failed (non-fatal)', e, st);
      }

  }

}