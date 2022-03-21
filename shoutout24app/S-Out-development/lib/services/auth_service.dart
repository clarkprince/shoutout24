import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static signInWithEmail({String email, String password}) async {
    final res = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final User user = res.user;
    return user;
  }

  static Future<UserCredential> signUpWithEmail(
      {String email, String password}) async {
    final res = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return res;
  }

  static logOut() {
    return _auth.signOut();
  }

  static Future<void> resetPassword({String email}) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }
}
