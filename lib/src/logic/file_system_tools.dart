import 'dart:collection';
import 'dart:io';

sealed class DirectoryScannerException implements Exception {
  const DirectoryScannerException({required this.code, required this.message});

  final String code;
  final String message;
}

final class DirectoryNotFoundException extends DirectoryScannerException {
  const DirectoryNotFoundException() : super(code: kCode, message: 'Directory not found');

  static const kCode = 'directory_not_found';
}

List<Directory> scanByPath(String path) {
  final directory = Directory(path);
  if (!directory.existsSync()) {
    throw DirectoryNotFoundException();
  }
  return UnmodifiableListView(directory.listSync(followLinks: false).whereType<Directory>());
}
