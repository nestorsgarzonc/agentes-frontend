import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(num value, {int decimalDigits = 0}) {
    return NumberFormat.currency(locale: 'es_CO', symbol: '', decimalDigits: decimalDigits)
        .format(value);
  }
}
