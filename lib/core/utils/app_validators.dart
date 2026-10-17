class AppValidators {
  AppValidators._();

  static final RegExp _egyptianPhoneRegex = RegExp(r'^01[0125][0-9]{8}$');

  static bool isValidEgyptianPhone(String phone) {
    final cleaned = phone.trim().replaceAll(RegExp(r'[\s-]'), '');
    return _egyptianPhoneRegex.hasMatch(cleaned);
  }
}