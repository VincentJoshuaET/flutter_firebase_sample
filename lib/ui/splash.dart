import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_sample/service/auth.dart';

import 'auth/login.dart';
import 'home/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _auth = AuthService();

  Future _currentUser() async {
    final dynamic user = await _auth.currentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    final dynamic user = _currentUser();
    if (user is FirebaseUser) {
      if (user.isEmailVerified) {
        return HomeScreen();
      } else {
        _auth.signOut();
        return LoginScreen();
      }
    } else {
      return LoginScreen();
    }
  }
}
