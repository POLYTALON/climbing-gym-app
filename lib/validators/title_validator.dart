class TitleFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Title cannot be empty' : null;
  }
}
