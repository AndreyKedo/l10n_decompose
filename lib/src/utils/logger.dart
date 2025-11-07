import 'dart:async';

import 'package:l10n_decompose/src/utils/console_utils.dart';
import 'package:logging/logging.dart';

extension type AppLogger._(Logger _logger) {
  factory AppLogger.named(String name) => AppLogger._(Logger(name));

  /// Root logger
  static final r = AppLogger._(Logger.root);
  static StreamSubscription? _loggerSub;

  static void enableLogger() {
    final logger = r._logger;
    logger.level = Level.CONFIG;
    _loggerSub = logger.onRecord.listen((record) {
      switch (record.level) {
        case Level.INFO:
          ConsolePrinter.i(record.message);
        case Level.WARNING:
          ConsolePrinter.w(record.message);
        case Level.SEVERE:
          ConsolePrinter.e(record.message);
        case Level.FINER:
          ConsolePrinter.s(record.message);
      }
    });
  }

  String get name => _logger.name;

  /// Pause log sequence
  static void pause() => _loggerSub?.pause();

  /// Resume log sequence
  static void resume() => _loggerSub?.resume();

  void setLogLevel(Level value) => _logger.level = value;

  /// Info
  void i(Object? message, [Object? error, StackTrace? stackTrace]) => _logger.info(message, error, stackTrace);

  /// Debug
  void d(Object? message, [Object? error, StackTrace? stackTrace]) => _logger.finer(message, error, stackTrace);

  /// Error
  void e(Object? message, [Object? error, StackTrace? stackTrace]) => _logger.severe(message, error, stackTrace);

  /// Warning
  void w(Object? message, [Object? error, StackTrace? stackTrace]) => _logger.warning(message, error, stackTrace);
}
