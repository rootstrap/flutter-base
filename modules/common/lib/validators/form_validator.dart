class FormValidator {
  static bool isEmail(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(value);
  }

  /// // At least 8 characters, one uppercase, one lowercase, one number and one special character
  static bool isStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    // At least 8 characters, one uppercase, one lowercase, one number and one special character
    final passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegex.hasMatch(value);
  }
}
