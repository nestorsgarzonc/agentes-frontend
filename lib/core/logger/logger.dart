// ignore_for_file: avoid_print

import 'dart:developer' as dev;

class Logger {
  static void log(String message) {
    dev.log(message);
  }

  static void logError(String message, StackTrace stackTrace) {
    log('Error: $message');
    log('StackTrace: $stackTrace');
  }
}
