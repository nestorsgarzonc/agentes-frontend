class TextFormValidator {
  static String? cellphonValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, igresa tú número de celular';
    } else if (value.length < 10) {
      return 'Ese número no es válido';
    }
    return null;
  }

  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu nombre';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    final validForm =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese un texto';
    } else if (!validForm.hasMatch(value)) {
      return 'Ese correo no es válido';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese una contraseña';
    } else if (value.length < 5) {
      return 'La contraseña debe tener mas de 5 caracteres.';
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
