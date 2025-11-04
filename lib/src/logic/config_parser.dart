import 'dart:collection';
import 'dart:convert';

import 'package:l10n_decompose/cli_constants.dart';
import 'package:l10n_decompose/src/model/l10n_decompose_config.dart';
import 'package:l10n_decompose/src/model/l10n_decompose_options.dart';
import 'package:yaml/yaml.dart';

typedef ValueGetter<T> = T Function();

typedef ConfigOptions = ({
  String dir,
  String arbDir,
  String outputDir,
  String outputLocalizationFile,
  String l10nConfig,
  String outputClass,
});

const configDecode = ConfigParser();

class ConfigParser with Converter<YamlMap, L10nDecomposeConfig> {
  const ConfigParser();

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
    throw YamlValidationFormatException(message: '$value is not a string');
  }

  String? _tryParseString(Object? value) {
    if (value is String) {
      return value;
    }
    return null;
  }

  Set<LocalizationPartialConfig> _parseParts(Object? value) {
    if (value is YamlList) {
      return UnmodifiableSetView(value.whereType<YamlMap>().map((part) => _parsePartialConfig(part)).toSet());
    }
    return const <LocalizationPartialConfig>{};
  }

  LocalizationPartialConfig _parsePartialConfig(YamlMap input) {
    return LocalizationPartialConfig(
      name: _parseStringOrThrow(input['name']),
      arbDir: _tryParseString(input['arbDir']),
      outputDir: _tryParseString(input['outputDir']),
      outputLocalizationFile: _tryParseString(input['outputLocalizationFile']),
      templateArbFile: _tryParseString(input['template-arb-file']),
      outputClass: _tryParseString(input['outputClass']),
    );
  }

  L10nDecomposeOptions parseOptions(YamlMap input) {
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

  @override
  L10nDecomposeConfig convert(YamlMap input) {
    final basicConfig = (
      dir: _parseString(input['dir'], DefaultL10nDecomposeConfig.defaultWorkDirectory),
      arbDir: _parseString(input['arb-dir'], DefaultL10nDecomposeConfig.arbDir),
      outputDir: _parseString(input['output-dir'], DefaultL10nDecomposeConfig.outputDir),
      outputLocalizationFile: _parseString(
        input['output-localization-file'],
        DefaultL10nDecomposeConfig.outputLocalizationFile,
      ),
      l10nConfig: _parseString('l10n-config', DefaultL10nDecomposeConfig.l10nConfig),
      outputClass: _parseString(input['output-class'], DefaultL10nDecomposeConfig.outputClass),
    );

    return L10nDecomposeConfig(
      dir: basicConfig.dir,
      arbDir: basicConfig.arbDir,
      outputDir: basicConfig.outputDir,
      outputLocalizationFile: basicConfig.outputLocalizationFile,
      outputClass: basicConfig.outputClass,
      templateArbFile: _parseString(input['template-arb-file'], DefaultL10nDecomposeConfig.templateArbFile),
      parts: _parseParts(input['parts']),
      options: parseOptions(input),
    );
  }
}

class YamlValidationFormatException implements Exception {
  YamlValidationFormatException({this.code = kCode, this.message = 'Invalid YAML format'});

  static const kCode = 'yaml_validation_error';

  final String code;
  final String message;

  @override
  String toString() {
    return 'YamlValidationFormatException($code: $message)';
  }
}

abstract final class YamlConfigValidator {
  static void validate(YamlMap config) {
    // Validate string collections
    void stringCollectionValidate(YamlList list, String target) {
      if (list.isEmpty || !list.every((element) => element is String && element.isNotEmpty)) {
        throw YamlValidationFormatException(message: 'A $target must be a list of strings');
      }
    }

    // Validate work directory
    if (!config.containsKey('dir')) {
      throw YamlValidationFormatException(message: 'A work directory is required');
    } else if (config['dir']! is! String || config['dir'] is String && config['dir'].isEmpty) {
      throw YamlValidationFormatException(message: 'pattern must be a string and not empty');
    }

    // Validate include and exclude
    final include = config['include'];
    if (include != null && include is! YamlList) {
      throw YamlValidationFormatException(message: 'include must be a list');
    } else if (include case final YamlList list) {
      stringCollectionValidate(list, 'include');
    }

    // Validate exclude
    final exclude = config['exclude'];
    if (exclude != null && exclude is! YamlList) {
      throw YamlValidationFormatException(message: 'exclude must be a list');
    } else if (exclude case final YamlList list) {
      stringCollectionValidate(list, 'exclude');
    }

    // Validate parts
    final parts = config['parts'];
    if (parts != null && parts is! YamlList) {
      throw YamlValidationFormatException(message: 'parts must be a list');
    }

    if (parts is YamlList) {
      bool partNameEvery(part) {
        if (part is YamlMap && part.containsKey('name')) {
          return part['name'] is String && part['name'].isNotEmpty;
        }
        return false;
      }

      if (!parts.every((part) => part is YamlMap && part.containsKey('name'))) {
        throw YamlValidationFormatException(message: 'Each part must have a name');
      } else if (!parts.every(partNameEvery)) {
        throw YamlValidationFormatException(message: 'Each part name must be a string and not empty');
      }
    }

    for (var option in L10nDecomposeOptionKey.all) {
      final rawValue = config[option];
      if (rawValue != null && rawValue is! bool) {
        throw YamlValidationFormatException(message: '$option is not a boolean');
      }
    }
  }
}
