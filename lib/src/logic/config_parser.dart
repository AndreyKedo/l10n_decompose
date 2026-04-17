import 'dart:collection';
import 'dart:convert';

import 'package:l10n_decompose/cli_constants.dart';
import 'package:l10n_decompose/src/logic/source_validator.dart';
import 'package:l10n_decompose/src/logic/yaml_validation_exception.dart';
import 'package:l10n_decompose/src/model/l10n_decompose_config.dart';
import 'package:l10n_decompose/src/model/l10n_decompose_options.dart';
import 'package:l10n_decompose/src/model/l10n_manifest.dart';
import 'package:yaml/yaml.dart';

/// The global entry to config parser.
const configDecode = ConfigParser();

/// {@template config_parser}
/// The parser of `l10n_decompose` configuration.
/// {@endtemplate}
class ConfigParser with Converter<L10nManifest, L10nDecomposeConfig> {
  /// {@macro config_parser}
  const ConfigParser({this.validator = const ConfigParserValidator()});

  /// The validator of `l10n_decompose` configuration.
  final SourceValidator<Map<String, Object?>> validator;

  String _parseString(Object? value, String defaultValue) {
    if (value is String) {
      return value;
    }
    return defaultValue;
  }

  String _parseStringOrThrow(Object? value) {
    if (value is String) {
      return value;
    }
    throw YamlValidationException(message: '$value is not a string');
  }

  String? _tryParseString(Object? value) {
    if (value is String) {
      return value;
    }
    return null;
  }

  Set<LocalizationPartialConfig> _parseParts(Object? value) {
    LocalizationPartialConfig parsePartialConfig(YamlMap input) {
      return LocalizationPartialConfig(
        name: _parseStringOrThrow(input['name']),
        arbDir: _tryParseString(input['arbDir']),
        outputDir: _tryParseString(input['outputDir']),
        outputLocalizationFile: _tryParseString(input['outputLocalizationFile']),
        templateArbFile: _tryParseString(input['template-arb-file']),
        outputClass: _tryParseString(input['outputClass']),
      );
    }

    if (value is YamlList) {
      return UnmodifiableSetView(value.whereType<YamlMap>().map((part) => parsePartialConfig(part)).toSet());
    }
    return const <LocalizationPartialConfig>{};
  }

  L10nDecomposeOptions _parseOptions(Map<String, Object?> input) {
    var options = <L10nDecomposeOptionKey, bool>{};
    for (var option in L10nDecomposeOptionKey.all) {
      final rawValue = input[option];
      if (rawValue == null) continue;
      if (rawValue is bool) {
        options[option] = rawValue;
      }
    }
    return L10nDecomposeOptions(options);
  }

  CompositeFileConfig? _parseComposite(Object? input) {
    if (input == null) return null;
    if (input is! Map) return null;

    if (input['enabled'] case false) return null;

    return CompositeFileConfig(
      filePath: _parseString(input['outputFile'], DefaultL10nDecomposeConfig.compositeFilePath),
      outputClass: _parseString(input['outputClass'], DefaultL10nDecomposeConfig.compositeClassName),
    );
  }

  @override
  L10nDecomposeConfig convert(L10nManifest input) {
    final configSource = input.config;
    validator.validate(configSource);

    return L10nDecomposeConfig(
      dir: _parseString(configSource['dir'], DefaultL10nDecomposeConfig.defaultWorkDirectory),
      arbDir: _parseString(configSource['arb-dir'], DefaultL10nDecomposeConfig.arbDir),
      outputDir: _parseString(configSource['output-dir'], DefaultL10nDecomposeConfig.outputDir),
      outputLocalizationFile: _parseString(
        configSource['output-localization-file'],
        DefaultL10nDecomposeConfig.outputLocalizationFile,
      ),
      composite: _parseComposite(configSource['composite']),
      outputClass: _parseString(configSource['output-class'], DefaultL10nDecomposeConfig.outputClass),
      templateArbFile: _parseString(configSource['template-arb-file'], DefaultL10nDecomposeConfig.templateArbFile),
      parts: _parseParts(configSource['parts']),
      options: _parseOptions(configSource),
    );
  }
}

/// {@template config_parser}
/// The validator for [ConfigParser].
/// {@endtemplate}
class ConfigParserValidator implements SourceValidator<Map<String, Object?>> {
  /// {@macro config_parser}
  const ConfigParserValidator();

  @override
  void validate(Map<String, Object?> config) {
    // Validate work directory
    if (!config.containsKey('dir')) {
      throw YamlValidationException(message: 'A work directory is required');
    } else if (config['dir'] is! String || (config['dir'] is String && (config['dir'] as String).isEmpty)) {
      throw YamlValidationException(message: 'pattern must be a string and not empty');
    }

    // Validate composite
    if (config['composite'] case YamlMap composite when !composite.containsKey('enabled')) {
      throw YamlValidationException(message: 'A key `composite`  must be contain `enabled` param');
    }

    // Validate parts
    final parts = config['parts'];
    if (parts != null && parts is! YamlList) {
      throw YamlValidationException(message: 'parts must be a list');
    }

    if (parts is YamlList) {
      bool partNameEvery(part) {
        if (part is YamlMap && part.containsKey('name')) {
          return part['name'] is String && part['name'].isNotEmpty;
        }
        return false;
      }

      if (!parts.every((part) => part is YamlMap && part.containsKey('name'))) {
        throw YamlValidationException(message: 'Each part must have a name');
      } else if (!parts.every(partNameEvery)) {
        throw YamlValidationException(message: 'Each part name must be a string and not empty');
      }
    }

    for (var option in L10nDecomposeOptionKey.all) {
      final rawValue = config[option];
      if (rawValue != null && rawValue is! bool) {
        throw YamlValidationException(message: '$option is not a boolean');
      }
    }
  }
}
