import 'dart:collection';
import 'dart:io';

import 'package:l10n_decompose/src/logic/file_system_tools.dart';
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

  test('throws DirectoryNotFoundException when directory does not exist', () {
    expect(() => scanByPath('non_existent_directory'), throwsA(isA<DirectoryNotFoundException>()));
  });

  test('returns all subdirectories when no filters are applied', () {
    final result = scanByPath(testDir.path);

    expect(result, isA<List<Directory>>());
    expect(result.length, 3);

    expect(
      UnmodifiableListView(result.map((dir) => p.basename(dir.path))),
      containsAll(['subdir1', 'subdir2', 'subdir3']),
    );
  });
}
