import 'package:l10n_decompose/src/model/l10n_decompose_options.dart';

/// Configuration for the l10n-decompose.
///
/// Configure the l10n-decompose with the following options from the l10n-decompose.yaml file:
///```yaml
///```
class L10nDecomposeConfig {
  L10nDecomposeConfig({
    required this.dir,
    required this.arbDir,
    required this.outputDir,
    required this.outputLocalizationFile,
    required this.outputClass,
    required this.templateArbFile,
    required this.parts,
    required this.options,
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

  final L10nDecomposeOptions options;

  @override
  int get hashCode =>
      Object.hash(runtimeType, dir, arbDir, outputDir, outputLocalizationFile, outputClass, Object.hashAll(parts));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is L10nDecomposeConfig &&
          runtimeType == other.runtimeType &&
          dir == other.dir &&
          arbDir == other.arbDir &&
          outputDir == other.outputDir &&
          outputLocalizationFile == other.outputLocalizationFile &&
          outputClass == other.outputClass &&
          parts == other.parts;

  @override
  String toString() {
    return 'L10nDecomposeConfig(pattern: $dir, '
        'arbDir: $arbDir, '
        'outputDir: $outputDir, '
        'outputLocalizationFile: $outputLocalizationFile, '
        'outputClass: $outputClass, '
        'parts: $parts)';
  }
}

/// The partial config for a feature.
///
/// ```yaml
/// ```
class LocalizationPartialConfig {
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
  int get hashCode =>
      Object.hash(runtimeType, name, arbDir, outputDir, outputLocalizationFile, outputClass, templateArbFile);

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
