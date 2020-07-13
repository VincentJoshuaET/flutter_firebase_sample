import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_sample/service/auth.dart';
import 'package:flutter_firebase_sample/util/widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  var _autoValidate = false;

  Future<void> _signOut() async {
    final dynamic result = await _auth.signOut();
    if (result == null) {
      Navigator.pop(context);
    } else if (result is PlatformException) {
      _scaffoldKey.currentState.showSnackBar(ActionSnackBar(
          label: result.message,
          onPressed: () async => _signOut(),
          text: 'Retry'));
    }
  }

  Future<void> _verifyEmail(FirebaseUser user) async {
    final dynamic result = await _auth.verifyEmail(user);
    if (result == null) {
      _signOut();
    } else if (result is PlatformException) {
      _scaffoldKey.currentState.showSnackBar(ActionSnackBar(
          label: result.message,
          onPressed: () async => _verifyEmail(user),
          text: 'Resend'));
    }
  }

  Future<void> _signIn() async {
    if (_formKey.currentState.validate()) {
      final dynamic result = await _auth.signIn(_email.text, _password.text);

      if (result is AuthResult) {
        if (result.user.isEmailVerified) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                      actions: [
                        SecondaryButton(
                            onPressed: () async => _verifyEmail(result.user),
                            text: 'Yes'),
                        SecondaryButton(
                            onPressed: () async => _signOut(), text: 'No')
                      ],
                      content: const Text(
                          'Email address is not verified. Resend email?'),
                      title: const Text('Email Not Verified')));
        }
      } else if (result is PlatformException) {
        _scaffoldKey.currentState.showSnackBar(ActionSnackBar(
            label: result.message,
            onPressed: () async => _signIn(),
            text: 'Retry'));
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  Future<void> _forgotPassword() async {
    final result = await Navigator.pushNamed(context, '/forgotPassword');
    if (result is String) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(result)));
    }
  }

  Future<void> _register() async {
    final result = await Navigator.pushNamed(context, '/register');
    if (result is String) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0.0,
            title: const Text('Login', style: TextStyle(color: Colors.blue))),
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Form(
                          autovalidate: _autoValidate,
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                EmailForm(controller: _email),
                                const SizedBox(height: 24.0),
                                PasswordForm(controller: _password),
                                const SizedBox(height: 24.0),
                                PrimaryButton(
                                    text: 'Log In',
                                    onPressed: () async => _signIn()),
                                SecondaryButton(
                                    onPressed: () async => _forgotPassword(),
                                    text: 'Forgot Password')
                              ]))),
                  SecondaryButton(
                      onPressed: () => _register(),
                      text: 'Register Here',
                      textStyle:
                          const TextStyle(decoration: TextDecoration.underline))
                ])));
  }
}
