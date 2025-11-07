import 'package:test/test.dart';
import 'package:l10n_decompose/src/logic/options_builder.dart';

void main() {
  group('L10nOption', () {
    test('arbDir should create correct option', () {
      final option = L10nOption.arbDir('lib/l10n');
      expect(option, '--arb-dir lib/l10n');
    });

    test('templateArbFile should create correct option', () {
      final option = L10nOption.templateArbFile('app_en.arb');
      expect(option, '--template-arb-file app_en.arb');
    });

    test('outputDir should create correct option', () {
      final option = L10nOption.outputDir('lib/localizations');
      expect(option, '--output-dir lib/localizations');
    });

    test('outputLocalizationFile should create correct option', () {
      final option = L10nOption.outputLocalizationFile('app_localizations.dart');
      expect(option, '--output-localization-file app_localizations.dart');
    });

    test('preferredSupportedLocales should create correct option with single locale', () {
      final option = L10nOption.preferredSupportedLocales(['en']);
      expect(option, '--preferred-supported-locales=en');
    });

    test('preferredSupportedLocales should create correct option with multiple locales', () {
      final option = L10nOption.preferredSupportedLocales(['en', 'ru', 'fr']);
      expect(option, '--preferred-supported-locales=en, ru, fr');
    });

    test('outputClass should create correct option', () {
      final option = L10nOption.outputClass('AppLocalizations');
      expect(option, '--output-class AppLocalizations');
    });

    test('noSyntheticPackage should create correct option', () {
      final option = L10nOption.noSyntheticPackage();
      expect(option, '--no-synthetic-package');
    });

    test('format should create correct option when true', () {
      final option = L10nOption.format(true);
      expect(option, '--format');
    });

    test('format should create correct option when false', () {
      final option = L10nOption.format(false);
      expect(option, '--no-format');
    });

    test('nullableGetter should create correct option when true', () {
      final option = L10nOption.nullableGetter(true);
      expect(option, '--nullable-getter');
    });

    test('nullableGetter should create correct option when false', () {
      final option = L10nOption.nullableGetter(false);
      expect(option, '--no-nullable-getter');
    });
  });

  group('OptionsBuilder', () {
    test('should initialize with noSyntheticPackage option by default', () {
      final builder = OptionsBuilder();
      final options = builder.build();
      expect(options, contains('--no-synthetic-package'));
      expect(options.length, 1);
    });

    test('should add options to buffer', () {
      final builder = OptionsBuilder();
      builder.addOption(L10nOption.arbDir('lib/l10n'));
      builder.addOption(L10nOption.outputClass('AppLocalizations'));

      final options = builder.build();
      expect(options, contains('--no-synthetic-package'));
      expect(options, contains('--arb-dir lib/l10n'));
      expect(options, contains('--output-class AppLocalizations'));
      expect(options.length, 3);
    });

    test('should build unmodifiable list', () {
      final builder = OptionsBuilder();
      final options = builder.build();

      expect(() => (options as dynamic).add('--test-option'), throwsUnsupportedError);
    });
  });
}
