import 'dart:io';

import 'package:ansi_styles/ansi_styles.dart';
import 'package:meta/meta.dart';

extension type const ConsolePrinter._(Stdout out) {
  /// Prints a error message to the console.
  static final e = ErrorConsolePrinter();

  /// Prints a info message to the console.
  static final i = InfoConsolePrinter();

  /// Prints a warning message to the console.
  static final w = WarningConsolePrinter();

  /// Prints a standard message to the console.
  static final s = ConsolePrinter._(stdout);

  /// Prints a message to the console.
  void call(String message) => out.writeln(message);
}

/// Prints a error message to the console.
extension type const ErrorConsolePrinter._(Stdout out) implements ConsolePrinter {
  /// Creates a new instance of the ConsolePrinterError extension.
  factory ErrorConsolePrinter() => ErrorConsolePrinter._(stderr);

  @redeclare
  void call(String message) {
    out.writeln(AnsiStyles.red('${AnsiStyles.bold('Error:')} $message'));
  }
}

extension type const InfoConsolePrinter._(Stdout out) implements ConsolePrinter {
  factory InfoConsolePrinter() => InfoConsolePrinter._(stdout);

  @redeclare
  void call(String message) {
    out.writeln(AnsiStyles.blue('Info: $message'));
  }
}

extension type const WarningConsolePrinter._(Stdout out) implements ConsolePrinter {
  factory WarningConsolePrinter() => WarningConsolePrinter._(stdout);

  @redeclare
  void call(String message) {
    out.writeln(AnsiStyles.yellow('Warning: $message'));
  }
}
