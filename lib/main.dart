import 'package:flutter/material.dart';
import 'package:flutter_firebase_sample/ui/auth/forgot_password.dart';
import 'package:flutter_firebase_sample/ui/auth/login.dart';
import 'package:flutter_firebase_sample/ui/auth/register.dart';
import 'package:flutter_firebase_sample/ui/home/home.dart';
import 'package:flutter_firebase_sample/ui/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sample Firebase Flutter App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/forgotPassword': (context) => ForgotPasswordScreen(),
          '/home': (context) => HomeScreen()
        });
  }
}
