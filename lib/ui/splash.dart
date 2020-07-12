import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_sample/service/auth.dart';

import 'auth/login.dart';
import 'home/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

Future _currentUser() async {
  final _auth = AuthService();
  final dynamic user = await _auth.currentUser();
  return user;
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final dynamic user = _currentUser();
    if (user is FirebaseUser && user.isEmailVerified) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
