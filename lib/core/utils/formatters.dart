import 'package:intl/intl.dart';

class Formatters {
  static String dateFormatter(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy hh:mm a');
    return formatter.format(date);
  }
}
