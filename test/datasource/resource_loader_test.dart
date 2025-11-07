import 'package:l10n_decompose/src/datasource/resource_loader.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('ResourceLoader', () {
    final configFile = 'l10n-decompose.yaml';
    late ResourceLoader<YamlMap> loader;

    setUp(() {
      loader = const YamlConfigurationLoader();
    });

    test('loads YAML config file', () {
      final yamlMap = loader.load(configFile);
      expect(yamlMap, isA<YamlMap>());
    });
    test('throws exception for non-existent file', () {
      expect(() => loader.load('non-existent.yaml'), throwsA(isA<ResourceNotFoundException>()));
    });
  });
}
