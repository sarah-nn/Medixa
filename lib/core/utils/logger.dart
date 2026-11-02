import 'dart:developer' as developer;

abstract final class Logger {
  static void info(String message, {String name = 'First'}) {
    developer.log(_redact(message), name: name);
  }

  static String _redact(String message) => message
      .replaceAll(
        RegExp(r'Bearer\s+\S+', caseSensitive: false),
        'Bearer [REDACTED]',
      )
      .replaceAll(
        RegExp(r'(password|token)=\S+', caseSensitive: false),
        r'$1=[REDACTED]',
      );
}
