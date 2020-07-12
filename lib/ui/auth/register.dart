import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _middleName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _dateOfBirth = TextEditingController();

  bool _autoValidate = false;

  final DateFormat _dateFormat = DateFormat('MMMM d, yyyy');
  final DateTime _maxDate = DateTime.now().subtractYears(18);
  DateTime _birthDate = DateTime.now().subtractYears(18);

  Future _selectDate(BuildContext context) async {
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
    } else {
      showSnackBarAction(
          key: _scaffoldKey,
          text: result.message as String,
          label: 'Try Again',
          onPressed: () async => _signOut());
    }
  }

  Future<void> _verifyEmail(FirebaseUser firebaseUser) async {
    final dynamic result = await _auth.verifyEmail(firebaseUser);
    if (result == null) {
      _signOut();
    } else {
      showSnackBarAction(
          key: _scaffoldKey,
          text: result.message as String,
          label: 'Resend',
          onPressed: () async => _verifyEmail(firebaseUser));
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
    } else {
      showSnackBarAction(
          key: _scaffoldKey,
          text: result.message as String,
          label: 'Retry',
          onPressed: () async => _setUserData(firebaseUser));
    }
  }

  Future<void> _createUser() async {
    final dynamic result = await _auth.createUser(_email.text, _password.text);

    if (result is AuthResult) {
      _setUserData(result.user);
    } else {
      showSnackBarAction(
          key: _scaffoldKey,
          text: result.message as String,
          label: 'Retry',
          onPressed: () async => _createUser());
    }
  }

  Future<void> _checkUsername() async {
    if (_formKey.currentState.validate()) {
      final dynamic result = await _firestore.checkUsername(_username.text);

      if (result is QuerySnapshot) {
        if (result.documents.isEmpty) {
          _createUser();
        } else {
          showSnackBar(key: _scaffoldKey, text: 'Username already exists!');
        }
      } else {
        showSnackBarAction(
            key: _scaffoldKey,
            text: result.message as String,
            label: 'Retry',
            onPressed: () async => _checkUsername());
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
                          error: 'Please enter username',
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
                          controller: _dateOfBirth,
                          onTap: () => _selectDate(context)),
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
