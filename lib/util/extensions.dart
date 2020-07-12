import 'package:email_validator/email_validator.dart';

extension DateTimeExtensions on DateTime {
  DateTime subtractYears(int years) {
    return DateTime(year - years, month, day, hour, minute, second, millisecond,
        microsecond);
  }
}

extension StringExtensions on String {
  bool isEmail() {
    return EmailValidator.validate(this);
  }

  bool isPassword() {
    return length > 8;
  }

  String toMobileFormat() {
    return contains('+63') ? this : replaceFirst('0', '+63');
  }

  bool isMobileFormat() {
    return contains('+63')
        ? length == 13
        : replaceFirst('0', '+63').length == 13;
  }
}
