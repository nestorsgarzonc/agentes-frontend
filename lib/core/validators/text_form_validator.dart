class TextFormValidator {
  static String? tableCodeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Debes ingresar el codigo de tu mesa';
    }
    return null;
  }
}
