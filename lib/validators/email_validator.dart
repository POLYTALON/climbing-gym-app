class EmailFieldValidator {
  static String validate(String value) {
    if (!isValidEmail(value) || value.isEmpty) {
      return 'Email is invalid';
    }
    return null;
  }

  static bool isValidEmail(String email) {
    String p = r"^[a-zA-Z0-9.]+@[a-zA-Z0-9\-]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(email);
  }
}
