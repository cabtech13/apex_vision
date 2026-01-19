import 'dart:developer' as developer;

class Logger {
  static void log(String message) {
    developer.log('[INFO] $message', name: 'ApexVision');
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    developer.log(
      '[ERROR] $message',
      name: 'ApexVision',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void debug(String message) {
    developer.log('[DEBUG] $message', name: 'ApexVision');
  }
}
