class TextFormValidator {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese un texto';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese un texto';
    } else if(value.length < 8){
      return 'Esta constraseña no es válida';
    }
    return null;
  }

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
