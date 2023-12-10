import 'package:logger/logger.dart';

class Logs {
  static late Logger _logger;

  static error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(
      message,
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static info(String message) {
    _logger.i(message, time: DateTime.now());
  }

  static initialize() {
    _logger = Logger(
      printer: PrettyPrinter(
          methodCount: 2,
          // Number of method calls to be displayed
          errorMethodCount: 8,
          // Number of method calls if stacktrace is provided
          lineLength: 120,
          // Width of the output
          colors: true,
          // Colorful log messages
          printEmojis: true,
          // Print an emoji for each log message
          printTime: false // Should each log print contain a timestamp
          ),
    );
  }
}
