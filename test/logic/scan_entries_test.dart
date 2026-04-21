import 'dart:collection';
import 'dart:io';

import 'package:l10n_decompose/src/logic/scanner/arb_scanner.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory testDir;
  late Directory subDir1;
  late Directory subDir2;
  late Directory subDir3;

  setUp(() {
    // Создаем временную директорию для тестов
    testDir = Directory.systemTemp.createTempSync('directory_scanner_test');
    subDir1 = Directory('${testDir.path}/subdir1')..createSync();
    subDir2 = Directory('${testDir.path}/subdir2')..createSync();
    subDir3 = Directory('${testDir.path}/subdir3')..createSync();

    // Проверяем, что директории созданы
    expect(subDir1.existsSync(), isTrue);
    expect(subDir2.existsSync(), isTrue);
    expect(subDir3.existsSync(), isTrue);
  });

  tearDown(() {
    // Удаляем временную директорию после тестов
    if (testDir.existsSync()) {
      testDir.deleteSync(recursive: true);
    }
  });
}
