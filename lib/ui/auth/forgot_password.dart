import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_sample/service/auth.dart';
import 'package:flutter_firebase_sample/util/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _email = TextEditingController();

  var _autoValidate = false;

  Future<void> _resetPassword() async {
    if (_formKey.currentState.validate()) {
      final dynamic result = await _auth.resetPassword(_email.text);

      if (result == null) {
        Navigator.pop(context, 'Password reset email sent!');
      } else if (result is PlatformException) {
        _scaffoldKey.currentState.showSnackBar(ActionSnackBar(
            label: result.message,
            onPressed: () async => _resetPassword(),
            text: 'Retry'));
      }
    } else {
      setState(() => _autoValidate = true);
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
            title: const Text('Reset Password',
                style: TextStyle(color: Colors.blue))),
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
                                PrimaryButton(
                                    text: 'Send Email',
                                    onPressed: () async => _resetPassword())
                              ]))),
                  SecondaryButton(
                      onPressed: () => Navigator.pop(context),
                      text: 'Log In',
                      textStyle:
                          const TextStyle(decoration: TextDecoration.underline))
                ])));
  }
}
