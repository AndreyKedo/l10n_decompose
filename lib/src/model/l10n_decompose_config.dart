import 'package:l10n_decompose/src/model/l10n_decompose_options.dart';

/// {@template l10n_decompose_config}
/// Configuration for the l10n-decompose.
///
/// Configure the l10n-decompose with the following options from the l10n-decompose.yaml file:
///```yaml
///  # Required
///  dir: lib/feature
///
///  # Optional; Use pattern %_en.arb or static name.
///  template-arb-file: "%_en.arb"
///
///  #Optional; By default l10n
///  arb-dir: l10n
///
///  #Optional; By default, the directory name "localization" is used, which will be created relative to.
///  # To place in an absolute directory, use / at the beginning of the path. For example /lib/core/localization
///  output-dir: localization
///
///  #Optional; By default use pattern %_localization.dart or static name.
///  output-localization-file: "%_localization.dart"
///
///  #Optional; By default use pattern %Localizations or static name.
///  output-class: "%Localizations"
///
///  #Optional; By default false inherited from flutter gen-l10n
///  format: false
///
///  #Optional; By default true inherited from flutter gen-l10n
///  nullable-getter: true
///
///  composite:
///    # Required;
///    enabled: true
///    # Optional; By default relative to lib directory.
///    outputFile: lib/composite_localizations.dart
///    # Optional; By default CompositeLocalizations
///    outputClass: CompositeLocalizations
///
///  # Optional;
///  parts:
///    # Required;
///    - name: home
///      # Optional; Use pattern %_en.arb or static name.
///      template-arb-file: home_en.arb
///      # Optional; By default use Global settings
///      arbDir: l10n
///      # Optional; By default use Global settings
///      outputDir: localization
///      # Optional; By default use Global settings
///      outputLocalizationFile: main_locale.dart
///      # Optional; By default use Global settings
///      outputClass: MainLocale
///```
/// {@endtemplate}
class L10nDecomposeConfig {
  /// {@macro l10n_decompose_config}
  L10nDecomposeConfig({
    required this.dir,
    required this.arbDir,
    required this.outputDir,
    required this.outputLocalizationFile,
    required this.outputClass,
    required this.templateArbFile,
    required this.parts,
    required this.options,
    required this.composite,
  });

  /// The directory where the features are located.
  final String dir;

  /// The directory where the arb files are located.
  final String arbDir;

  /// The directory where the output files are located.
  final String outputDir;

  /// The name of the output localization file.
  final String outputLocalizationFile;

  /// The name of the output class.
  final String outputClass;

  /// The name of the template arb file.
  final String templateArbFile;

  /// The partial configurations for features.
  final Set<LocalizationPartialConfig> parts;

  /// The options for the l10n-decompose.
  final L10nDecomposeOptions options;

  /// The composite config for the features.
  final CompositeFileConfig? composite;

  @override
  String toString() {
    return 'L10nDecomposeConfig(\n'
        '\tpattern: $dir,\n'
        '\tarbDir: $arbDir,\n'
        '\toutputDir: $outputDir,\n'
        '\toutputLocalizationFile: $outputLocalizationFile,\n'
        '\toutputClass: $outputClass,\n'
        '\tcomposite: $composite,\n'
        '\tparts: $parts)';
  }
}

/// {@template l10n_decompose_config.partial_config}
/// The partial config for a feature.
///
/// ```yaml
/// # Required;
/// - name: home
///   # Optional; Use pattern %_en.arb or static name.
///   template-arb-file: home_en.arb
///   # Optional; By default use Global settings
///   arbDir: l10n
///   # Optional; By default use Global settings
///   outputDir: localization
///   # Optional; By default use Global settings
///   outputLocalizationFile: main_locale.dart
///   # Optional; By default use Global settings
///   outputClass: MainLocale
/// ```
/// {@endtemplate}
class LocalizationPartialConfig {
  /// {@macro l10n_decompose_config.partial_config}
  LocalizationPartialConfig({
    required this.name,
    required this.arbDir,
    required this.outputDir,
    required this.outputLocalizationFile,
    required this.outputClass,
    required this.templateArbFile,
  });

  /// The name of the feature.
  final String name;

  /// The directory where the arb files are located.
  final String? arbDir;

  /// The directory where the output files are located.
  final String? outputDir;

  /// The name of the output localization file.
  final String? outputLocalizationFile;

  /// The name of the output class.
  final String? outputClass;

  /// The name of the template arb file.
  final String? templateArbFile;

  @override
  int get hashCode => Object.hash(
        runtimeType,
        name,
        arbDir,
        outputDir,
        outputLocalizationFile,
        outputClass,
        templateArbFile,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalizationPartialConfig &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          arbDir == other.arbDir &&
          outputDir == other.outputDir &&
          outputLocalizationFile == other.outputLocalizationFile &&
          outputClass == other.outputClass &&
          templateArbFile == other.templateArbFile;

  @override
  String toString() {
    return 'LocalizationPartialConfig('
        'name: $name, '
        'arbDir: $arbDir, '
        'outputDir: $outputDir, '
        'outputLocalizationFile: $outputLocalizationFile, '
        'outputClass: $outputClass, '
        'templateArbFile: $templateArbFile)';
  }
}

/// {@template l10n_decompose_config.composition_config}
///
/// ```yaml
/// composite:
///    # Required;
///    enabled: true
///    # Optional; By default relative to lib directory.
///    outputFile: lib/composite_localizations.dart
///    # Optional; By default CompositeLocalizations
///    outputClass: CompositeLocalizations
/// ```
/// {@endtemplate}
class CompositeFileConfig {
  /// {@macro l10n_decompose_config.composition_config}
  CompositeFileConfig({
    required this.filePath,
    required this.outputClass,
  });

  final String filePath;
  final String outputClass;

  @override
  String toString() {
    return 'CompositeFileConfig(filePath: $filePath, outputClass: $outputClass)';
  }
}
