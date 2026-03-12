// App FormFields Validators

class Validators {
  Validators._();

  static bool isNameValid(String name) {
    return name.trim().length >= 5;
  }

  static bool isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  static bool isPasswordValid(String password) {
    return password.trim().length >= 6;
  }

  static bool isConfirmPasswordValid(String password, String confirmPassword) {
    return password == confirmPassword;
  }
}
