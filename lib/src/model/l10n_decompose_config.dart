import 'package:l10n_decompose/src/model/l10n_decompose_options.dart';

/// {@template l10n_decompose_config}
/// Configuration for the l10n-decompose.
///
/// Configure the l10n-decompose with the following options from the l10n-decompose.yaml file:
///```yaml
///  # Optional;
///  enabled: true
///
///  # Optional; By default `lib/**/*_en.arb`
///  # Available patterns for template file:
///  # - *_en.arb
///  # - *_en_US.arb
///  # The prefix style can be any, but it is recommended to use the `snake_case` style.
///  input: "**_en.arb"
///
///  #Optional; By default `gen/*_localization.dart`
///  output: gen/*_localization.dart
///
///  #Optional; By default use pattern *Localizations or static name.
///  output-class: "*Localizations"
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
///  # Optional; Customize output
///  parts:
///    # Required;
///    - name: core
///      # Optional; By default use Global settings
///      # Relative - dir/app_locale.dart OR ./dir/app_locale.dart
///      # Absolute - /lib/app_locale.dart or lib/app_locale.dart
///      output: lib/core/localization/app_locale.dart
///      # Optional; By default use Global settings
///      outputClass: AppLocale
///```
/// {@endtemplate}
class L10nDecomposeConfig {
  /// {@macro l10n_decompose_config}
  L10nDecomposeConfig({
    required this.enabled,
    required this.inputPattern,
    required this.output,
    required this.outputClass,
    required this.templateArbFile,
    required this.parts,
    required this.options,
    required this.composite,
  });

  /// Whether the l10n-decompose is enabled.
  final bool enabled;

  /// Pattern for input template arb file.
  final String inputPattern;

  /// Pattern for output localization files.
  final String output;

  /// The name of the output class.
  final String outputClass;

  /// The name of the template arb file.
  final String templateArbFile;

  /// The partial configurations for features.
  final Map<String, LocalizationPartialConfig> parts;

  /// The options for the l10n-decompose.
  final L10nDecomposeOptions options;

  /// The composite config for the features.
  final DelegatesClassConfig? composite;

  @override
  String toString() {
    return 'L10nDecomposeConfig(\n'
        '\tenabled: $enabled,\n'
        '\tinputPattern: $inputPattern,\n'
        '\toutputPattern: $output,\n'
        '\toutputClass: $outputClass,\n'
        '\tcomposite: $composite,\n'
        '\tparts: ${parts.values.toList(growable: false)})';
  }
}

/// {@template l10n_decompose_config.partial_config}
/// The partial config for a feature.
///
/// ```yaml
///# Required;
///- name: core
///   # Optional; By default use Global settings
///   output: lib/core/localization/app_locale.dart
///   # Optional; By default use Global settings
///   outputClass: AppLocale
/// ```
/// {@endtemplate}
class LocalizationPartialConfig {
  /// {@macro l10n_decompose_config.partial_config}
  LocalizationPartialConfig({
    required this.name,
    required this.output,
    required this.outputClass,
  });

  /// The name of the feature.
  final String name;

  /// The directory where the output files are located.
  final String? output;

  /// The name of the output class.
  final String? outputClass;

  @override
  int get hashCode => Object.hash(
        runtimeType,
        name,
        outputClass,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalizationPartialConfig &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          outputClass == other.outputClass;

  @override
  String toString() {
    return 'LocalizationPartialConfig('
        'name: $name, '
        'outputClass: $outputClass, '
        'output: $output)';
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
class DelegatesClassConfig {
  /// {@macro l10n_decompose_config.composition_config}
  DelegatesClassConfig({
    required this.filePath,
    required this.outputClass,
  });

  final String filePath;
  final String outputClass;

  @override
  String toString() {
    return 'DelegatesClassConfig(filePath: $filePath, outputClass: $outputClass)';
  }
}
