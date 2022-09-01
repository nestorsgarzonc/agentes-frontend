class TextFormValidator {
  static String? tableCodeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Debes ingresar el codigo de tu mesa.';
    }
    if (!isValidMongoId(value)) {
      return 'El codigo de tu mesa no es valido.';
    }
    return null;
  }

  static bool isValidMongoId(String value) {
    final regex = RegExp('^[a-fA-F0-9]{24}');
    return regex.hasMatch(value);
  }
}
