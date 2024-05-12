class Validator {
  static bool emailFieldValidation(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static bool phoneNumerValidation(String phoneNumber) {
    return RegExp(r'^0[0-9]{9}$').hasMatch(phoneNumber);
  }

  static bool nationalIdValidation(String phoneNumber) {
    return RegExp(r'^[0-9]{9}$').hasMatch(phoneNumber);
  }

  static bool isNumericWithLength(String value, int length) {
    // Check if the value is numeric and has the specified length
    if (value.length != length) {
      return false;
    }

    // Check if all characters in the value are digits
    RegExp digitRegExp = RegExp(r'^[0-9]+$');
    return digitRegExp.hasMatch(value);
  }

  static bool isFullNameValid(String fullName) {
    RegExp regex = RegExp(r'^[a-zA-Z]+( [a-zA-Z]+)+$');
    return regex.hasMatch(fullName);
  }

  static bool validatePassword(String input){
    return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(input);
  }
}
