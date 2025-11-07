import 'dart:collection';

// flutter gen-110n \
// --arb-dir <path> \
// --template-arb-file <name_en.arb> \
// --output-dir <path> \
// --output-localization-file <name_localizations.dart> \
// --preferred-supported-locales=ru \
// --output-class <NameLocalizations> \
// --no-synthetic-package -no-nullable-getter --no-format;
extension type L10nOption._(String value) implements String {
  factory L10nOption.arbDir(String value) => L10nOption._('--arb-dir $value');

  factory L10nOption.templateArbFile(String value) => L10nOption._('--template-arb-file $value');

  factory L10nOption.outputDir(String value) => L10nOption._('--output-dir $value');

  factory L10nOption.outputLocalizationFile(String value) => L10nOption._('--output-localization-file $value');

  factory L10nOption.preferredSupportedLocales(List<String> value) =>
      L10nOption._('--preferred-supported-locales=${value.join(', ')}');

  factory L10nOption.outputClass(String value) => L10nOption._('--output-class $value');

  factory L10nOption.noSyntheticPackage() => L10nOption._('--no-synthetic-package');

  factory L10nOption.format(bool value) => L10nOption._(value ? '--format' : '--no-format');

  factory L10nOption.nullableGetter(bool value) => L10nOption._(value ? '--nullable-getter' : '--no-nullable-getter');
}

class OptionsBuilder {
  // By default add L10nOption.noSyntheticPackage()
  OptionsBuilder() : buffer = [L10nOption.noSyntheticPackage()];

  final List<String> buffer;

  void addOption(L10nOption option) => buffer.add(option);

  List<String> build() => UnmodifiableListView(buffer);
}
