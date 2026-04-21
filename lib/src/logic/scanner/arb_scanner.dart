import 'dart:io';

import 'package:path/path.dart' as path;

/// The pattern of the arb file name.
final templateFilePattern = RegExp(r'^(.+)_([a-z]{2})(?:_([A-Z]{2}))?\.arb$');

/// The result of the arb file name.
typedef ArbFileInfo = ({String name, String locale, String? country});

/// {@template arb_scanner.entry}
/// The arb file entry.
/// {@endtemplate}
class ArbEntry {
  /// {@macro arb_scanner.entry}
  ///
  /// - [file] - file system entry.
  ArbEntry(this.file);

  /// .arb file name parser.
  static ArbFileInfo? parseArbFileName(String fileName) {
    final match = templateFilePattern.firstMatch(fileName);
    if (match == null) return null;

    final name = match.group(1);
    final locale = match.group(2);
    final country = match.group(3);

    // name и locale обязательны
    if (name == null || locale == null) return null;

    return (name: name, locale: locale, country: country);
  }

  static bool matches(String fileName) {
    return templateFilePattern.hasMatch(fileName);
  }

  /// The file system entry.
  final File file;

  /// The directory of the file.
  late final directory = file.parent;

  String get fileName {
    return path.basename(file.path);
  }

  String get prefix {
    final fileName = path.basename(file.path);
    final info = ArgumentError.checkNotNull(parseArbFileName(fileName), 'Invalid arb file name: $fileName');
    return info.name;
  }

  @override
  String toString() {
    return 'Arb(file: ${path.basename(file.path)}, directory: ${directory.path})';
  }
}

abstract interface class ArbScanner {
  List<ArbEntry> scan();
}
