// ignore_for_file: avoid_print

class Logger {
  static void log(String message) {
    print(message);
  }

  static void logError(String message, StackTrace stackTrace) {
    print('Error: $message');
    print('StackTrace: $stackTrace');
  }
}
