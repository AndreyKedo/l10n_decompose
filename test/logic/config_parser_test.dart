import 'package:l10n_decompose/src/datasource/resource_loader.dart';
import 'package:l10n_decompose/src/logic/manifest_parser.dart';
import 'package:test/test.dart';
import 'package:l10n_decompose/src/logic/config_parser.dart';
import 'package:l10n_decompose/src/model/l10n_decompose_options.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('ConfigParser', () {
    late ResourceLoader<YamlMap> loader;

    setUp(() {
      loader = const YamlConfigurationLoader();
    });

    test('should parse template configuration file', () {
      final file = loader.load('l10n-decompose.template.yaml');

      final config = manifestParser.fuse(configDecode).convert(file);

      expect(config.dir, equals('lib/feature'));
      expect(config.arbDir, equals('l10n'));
      expect(config.outputDir, equals('localization'));
      expect(config.outputLocalizationFile, equals('%_localization.dart'));
      expect(config.outputClass, equals('%Localizations'));
      expect(config.templateArbFile, equals('%_en.arb'));
      expect(config.parts, hasLength(1));
      final part = config.parts.first;
      expect(part.name, equals('home'));
      expect(part.templateArbFile, equals('home_en.arb'));
      expect(part.arbDir, equals('l10n'));
      expect(part.outputDir, equals('localization'));
      expect(part.outputLocalizationFile, equals('main_locale.dart'));
      expect(part.outputClass, equals('MainLocale'));
      expect(config.options.isEnabled(L10nDecomposeOptionKey.nullableGetter), isTrue);
      expect(config.options.isEnabled(L10nDecomposeOptionKey.format), isFalse);
    });
  });
}
