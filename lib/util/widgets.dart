import 'package:flutter/material.dart';

import 'extensions.dart';

class EmailForm extends StatelessWidget {
  const EmailForm({@required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: 'Email Address'),
        keyboardType: TextInputType.emailAddress,
        validator: (value) =>
            value.isEmail() ? null : 'Please enter valid email address');
  }
}

class PasswordForm extends StatelessWidget {
  const PasswordForm({@required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: 'Password'),
        obscureText: true,
        validator: (value) =>
        value.isPassword() ? null : 'Please enter valid password');
  }
}

class ConfirmPasswordForm extends StatelessWidget {
  const ConfirmPasswordForm({@required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: 'Confirm Password'),
        obscureText: true,
        validator: (value) =>
        controller.text != value ? 'Passwords do not match' : null);
  }
}

class InputForm extends StatelessWidget {
  const InputForm({@required this.controller,
    this.error,
    @required this.label,
    this.validator});

  final TextEditingController controller;
  final String label, error;
  final String Function(String) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(), labelText: label),
        validator: validator ?? (value) => value.isEmpty ? error : null);
  }
}

class MobileForm extends StatelessWidget {
  const MobileForm({@required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: 'Mobile Number'),
        onChanged: (value) => controller.text = value.toMobileFormat(),
        validator: (value) =>
        value.isMobileFormat() ? null : 'Please enter valid mobile number');
  }
}

class DateForm extends StatelessWidget {
  const DateForm({@required this.controller, @required this.onTap});

  final TextEditingController controller;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        decoration: outlineInput('Date Of Birth'),
        onTap: onTap,
        readOnly: true,
        validator: (value) =>
        value.isEmpty ? 'Please enter date of birth' : null);
  }
}

class DropdownForm extends StatelessWidget {
  const DropdownForm({@required this.controller,
    @required this.error,
    @required this.items,
    @required this.label});

  final TextEditingController controller;
  final String error, label;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        decoration: outlineInput(label),
        items: items
            .map((value) => DropdownMenuItem(value: value, child: Text(value)))
            .toList(),
        onChanged: (String value) => controller.text = value,
        onTap: () => FocusManager.instance.primaryFocus.unfocus(),
        validator: (String value) => value == null ? error : null);
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({@required this.onPressed, @required this.text});

  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: Colors.blueAccent,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        textColor: Colors.white,
        child: Text(text));
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(
      {@required this.onPressed, @required this.text, this.textStyle});

  final TextStyle textStyle;
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: onPressed,
        textColor: Colors.blueAccent,
        child: Text(text.toUpperCase(), style: textStyle));
  }
}

void showSnackBar(
    {@required GlobalKey<ScaffoldState> key, @required String text}) {
  key.currentState.showSnackBar(SnackBar(content: Text(text)));
}

void showSnackBarAction({@required GlobalKey<ScaffoldState> key,
  @required String text,
  @required String label,
  @required Function() onPressed}) {
  key.currentState.showSnackBar(SnackBar(
      action: onPressed != null
          ? SnackBarAction(label: label, onPressed: onPressed)
          : null,
      content: Text(text)));
}

void showAlertDialog({@required BuildContext context,
  @required List<Widget> actions,
  @required String content,
  @required String title}) {
  showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
              actions: actions, content: Text(content), title: Text(title)));
}

InputDecoration outlineInput(String label) {
  return InputDecoration(border: const OutlineInputBorder(), labelText: label);
}
