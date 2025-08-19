import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_enrich/core/utils/logger.dart';


class FirebaseAuthService {

  final _log = getLogger('FirebaseAuthService');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //gets the current state of the user if signed in or not
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  //gets the current user info
  User? get currentUser => _auth.currentUser;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    _log.info('signInWithEmailAndPassword called');
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    _log.info('signInWithEmailAndPassword success for uid=${cred.user?.uid}');
    return cred.user;
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    _log.info('signUpWithEmailAndPassword called');
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    _log.info('signUpWithEmailAndPassword success for uid=${cred.user?.uid}, sending verification email');
    await cred.user?.sendEmailVerification();
    return cred.user;
  }

  Future<void> resendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user == null) {
      _log.warning('resendVerificationEmail called with no currentUser');
      return;
    }
    await user.sendEmailVerification();
    _log.info('Verification email re-sent to ${user.email}');
  }

  Future<void> reloadUser() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.reload();
    _log.info('User reloaded; emailVerified=${_auth.currentUser?.emailVerified}');
  }

  Future<void> signOut() async {
    _log.info('signOut called');
    await _auth.signOut();
  }

  Future<void> setDisplayName(fullName) async{
    await _auth.currentUser?.updateDisplayName(fullName);
  }


}
