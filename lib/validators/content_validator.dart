class ContentFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Content cannot be empty' : null;
  }
}
