/// Constants for the l10n-decompose.
abstract final class CliConstants {
  static const configFileName = 'l10n-decompose.yaml';

  static const flutter = 'flutter';
  static const l10nCommand = 'gen-l10n';
}

/// Default values for the l10n-decompose.
extension type const DefaultL10nDecomposeConfig(String value) implements String {
  static const configFileName = DefaultL10nDecomposeConfig('l10n-decompose.yaml');
  static const l10nConfig = DefaultL10nDecomposeConfig('l10n.yaml');
  static const defaultWorkDirectory = DefaultL10nDecomposeConfig('lib/feature');
  static const arbDir = DefaultL10nDecomposeConfig('l10n');
  static const outputDir = DefaultL10nDecomposeConfig('localization');
  static const outputLocalizationFile = DefaultL10nDecomposeConfig('%_localization.dart');
  static const outputClass = DefaultL10nDecomposeConfig('%Localizations');
  static const preferredLocale = DefaultL10nDecomposeConfig('en');
  static const templateArbFile = DefaultL10nDecomposeConfig('%_$preferredLocale.arb');
}
