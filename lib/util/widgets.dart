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
  const InputForm(
      {@required this.controller,
      @required this.label,
      this.error,
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
        validator: validator ?? ((value) => value.isEmpty ? error : null));
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
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: 'Date Of Birth'),
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
        decoration: InputDecoration(
            border: const OutlineInputBorder(), labelText: label),
        items: items
            .map((value) => DropdownMenuItem(value: value, child: Text(value)))
            .toList(),
        onChanged: (String value) => controller.text = value,
        onTap: () => FocusManager.instance.primaryFocus.unfocus(),
        validator: (value) => value == null ? error : null);
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

class ActionSnackBar extends SnackBar {
  const ActionSnackBar(
      {@required this.label, @required this.onPressed, @required this.text});

  final String label, text;
  final Function() onPressed;

  Widget build(BuildContext context) {
    return SnackBar(
        action: SnackBarAction(label: label, onPressed: onPressed),
        content: Text(text));
  }
}
