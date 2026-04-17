import 'package:l10n_decompose/src/datasource/resource_loader.dart';
import 'package:l10n_decompose/src/logic/manifest_parser.dart';
import 'package:l10n_decompose/src/logic/source_validator.dart';
import 'package:l10n_decompose/src/logic/yaml_validation_exception.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  late ResourceLoader<YamlMap> loader;

  setUp(() {
    loader = const YamlConfigurationLoader();
  });
  group('ManifestParser', () {
    test('should parse valid manifest with package name and l10n_decompose config', () {
      final file = loader.load('l10n-decompose.template.yaml');
      final manifest = manifestParser.convert(file);

      expect(manifest.package, equals('package_name'));
      expect(manifest.config, isA<Map<String, Object?>>());
      expect(manifest.config, isNotEmpty);
    });

    test('should throw when `l10n_decompose` config is empty', () {
      final file = Map.from(loader.load('l10n-decompose.template.yaml'));
      file['l10n_decompose'] = null;

      expect(
        () => manifestParser.convert(YamlMap.wrap(file)),
        throwsA(isA<YamlValidationException>()),
      );
    });

    test('should throw when `l10n_decompose` config `Map` is empty', () {
      final file = Map.from(loader.load('l10n-decompose.template.yaml'));
      file['l10n_decompose'] = {};

      expect(
        () => manifestParser.convert(YamlMap.wrap(file)),
        throwsA(isA<YamlValidationException>()),
      );
    });
  });

  group('ManifestParserValidator', () {
    final parserWithCustomValidator = ManifestParser(
      validator: _ThrowingValidator(),
    );

    const validator = ManifestParserValidator();

    test('should throw when `l10n_decompose` config `Map` is empty', () {
      final file = Map.from(loader.load('l10n-decompose.template.yaml'));
      file['l10n_decompose'] = null;

      expect(
        () => validator.validate(YamlMap.wrap(file)),
        throwsA(isA<YamlValidationException>()),
      );
    });

    test('should use custom validator when provided', () {
      final yamlMap = loader.load('l10n-decompose.template.yaml');

      expect(
        () => parserWithCustomValidator.convert(yamlMap),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Custom validator error'),
        )),
      );
    });
  });
}

class _ThrowingValidator implements SourceValidator<YamlMap> {
  @override
  void validate(YamlMap value) {
    throw Exception('Custom validator error');
  }
}
