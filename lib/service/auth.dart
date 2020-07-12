import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final AuthService _instance = AuthService._constructor();

  factory AuthService() {
    return _instance;
  }

  AuthService._constructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future currentUser() async {
    try {
      return await _auth.currentUser();
    } catch (error) {
      return error;
    }
  }

  Future signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      return error;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      return error;
    }
  }

  Future createUser(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      return error;
    }
  }

  Future verifyEmail(FirebaseUser user) async {
    try {
      return await user.sendEmailVerification();
    } catch (error) {
      return error;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      return error;
    }
  }
}
