import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_sample/model/user.dart';
import 'package:flutter_firebase_sample/service/auth.dart';
import 'package:flutter_firebase_sample/service/firestore.dart';
import 'package:flutter_firebase_sample/util/extensions.dart';
import 'package:flutter_firebase_sample/util/widgets.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = AuthService();
  final _firestore = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _firstName = TextEditingController();
  final _middleName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _mobile = TextEditingController();
  final _location = TextEditingController();
  final _gender = TextEditingController();
  final _dateOfBirth = TextEditingController();

  var _autoValidate = false;

  final _dateFormat = DateFormat('MMMM d, yyyy');
  final _maxDate = DateTime.now().subtractYears(18);
  var _birthDate = DateTime.now().subtractYears(18);

  Future<void> _selectDate() async {
    final _selectedDate = await showDatePicker(
        context: context,
        initialDate: _birthDate,
        firstDate: DateTime(1900),
        lastDate: _maxDate);
    if (_selectedDate != null) {
      setState(() => _dateOfBirth.text = _dateFormat.format(_selectedDate));
      _birthDate = _selectedDate;
    }
  }

  Future<void> _signOut() async {
    final dynamic result = await _auth.signOut();
    if (result == null) {
      Navigator.pop(context, 'Verification email sent!');
    } else if (result is PlatformException) {
      _scaffoldKey.currentState.showSnackBar(ActionSnackBar(
          label: result.message,
          onPressed: () async => _signOut(),
          text: 'Retry'));
    }
  }

  Future<void> _verifyEmail(FirebaseUser firebaseUser) async {
    final dynamic result = await _auth.verifyEmail(firebaseUser);
    if (result == null) {
      _signOut();
    } else if (result is PlatformException) {
      _scaffoldKey.currentState.showSnackBar(ActionSnackBar(
          label: result.message,
          onPressed: () async => _verifyEmail(firebaseUser),
          text: 'Resend'));
    }
  }

  Future<void> _setUserData(FirebaseUser firebaseUser) async {
    final user = User(
        uid: firebaseUser.uid,
        firstName: _firstName.text,
        middleName: _middleName.text,
        lastName: _lastName.text,
        username: _username.text,
        mobile: _mobile.text,
        location: _location.text,
        gender: _gender.text,
        dateOfBirth: Timestamp.fromDate(_birthDate));
    final dynamic result = await _firestore.setUserData(user);
    if (result == null) {
      _verifyEmail(firebaseUser);
    } else if (result is PlatformException) {
      _scaffoldKey.currentState.showSnackBar(ActionSnackBar(
          label: result.message,
          onPressed: () async => _setUserData(firebaseUser),
          text: 'Retry'));
    }
  }

  Future<void> _createUser() async {
    final dynamic result = await _auth.createUser(_email.text, _password.text);

    if (result is AuthResult) {
      _setUserData(result.user);
    } else if (result is PlatformException) {
      _scaffoldKey.currentState.showSnackBar(ActionSnackBar(
          label: result.message,
          onPressed: () async => _createUser(),
          text: 'Retry'));
    }
  }

  Future<void> _checkUsername() async {
    if (_formKey.currentState.validate()) {
      final dynamic result = await _firestore.checkUsername(_username.text);

      if (result is QuerySnapshot) {
        if (result.documents.isEmpty) {
          _createUser();
        } else {
          _scaffoldKey.currentState.showSnackBar(
              const SnackBar(content: Text('Username already exists!')));
        }
      } else if (result is PlatformException) {
        _scaffoldKey.currentState.showSnackBar(ActionSnackBar(
            label: result.message,
            onPressed: () async => _checkUsername(),
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
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0.0,
            title:
                const Text('Register', style: TextStyle(color: Colors.blue))),
        body: Container(
            alignment: Alignment.center,
            child: Form(
                autovalidate: _autoValidate,
                key: _formKey,
                child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 64.0),
                    child: Column(children: [
                      const SizedBox(height: 8.0),
                      InputForm(
                          controller: _firstName,
                          error: 'Please enter first name',
                          label: 'First Name'),
                      const SizedBox(height: 24.0),
                      InputForm(
                          controller: _middleName,
                          error: 'Please enter middle name',
                          label: 'Middle Name'),
                      const SizedBox(height: 24.0),
                      InputForm(
                          controller: _lastName,
                          error: 'Please enter last name',
                          label: 'Last Name'),
                      const SizedBox(height: 24.0),
                      InputForm(
                          controller: _username,
                          label: 'Username',
                          validator: (value) => value.length < 8
                              ? 'Please enter valid username'
                              : null),
                      const SizedBox(height: 24.0),
                      EmailForm(controller: _email),
                      const SizedBox(height: 24.0),
                      PasswordForm(controller: _password),
                      const SizedBox(height: 24.0),
                      ConfirmPasswordForm(controller: _password),
                      const SizedBox(height: 24.0),
                      MobileForm(controller: _mobile),
                      const SizedBox(height: 24.0),
                      DropdownForm(
                          controller: _location,
                          error: 'Please select province',
                          items: const ['Metro Manila', 'Bulacan'],
                          label: 'Province'),
                      const SizedBox(height: 24.0),
                      DropdownForm(
                          controller: _gender,
                          error: 'Please select gender',
                          items: const ['Male', 'Female'],
                          label: 'Gender'),
                      const SizedBox(height: 24.0),
                      DateForm(
                          controller: _dateOfBirth, onTap: () => _selectDate()),
                      const SizedBox(height: 24.0),
                      PrimaryButton(
                          onPressed: () async => _checkUsername(),
                          text: 'Register'),
                      SecondaryButton(
                          onPressed: () => Navigator.pop(context),
                          text: 'Already Have An Account?'.toUpperCase(),
                          textStyle: const TextStyle(
                              decoration: TextDecoration.underline))
                    ])))));
  }
}
