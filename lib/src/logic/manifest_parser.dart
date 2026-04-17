import 'dart:convert';

import 'package:l10n_decompose/cli_constants.dart';
import 'package:l10n_decompose/src/logic/source_validator.dart';
import 'package:l10n_decompose/src/logic/yaml_validation_exception.dart';
import 'package:l10n_decompose/src/model/l10n_manifest.dart';
import 'package:yaml/yaml.dart';

const manifestParser = ManifestParser();

class ManifestParser extends Converter<YamlMap, L10nManifest> {
  const ManifestParser({this.validator = const ManifestParserValidator()});

  final SourceValidator<YamlMap> validator;

  @override
  L10nManifest convert(YamlMap input) {
    validator.validate(input);
    return L10nManifest(
      package: input[DefaultL10nManifest.package] as String,
      config: Map<String, Object?>.from(input[DefaultL10nManifest.wordKey]),
    );
  }
}

class ManifestParserValidator implements SourceValidator<YamlMap> {
  const ManifestParserValidator();

  @override
  void validate(YamlMap value) {
    if (value[DefaultL10nManifest.wordKey] == null) {
      throw YamlValidationException(
        message: '`${DefaultL10nManifest.wordKey}` is not found in `${DefaultL10nManifest.sourceFileName}`',
      );
    }

    if (value[DefaultL10nManifest.wordKey] case YamlMap map when map.isEmpty) {
      throw YamlValidationException(message: 'The `${DefaultL10nManifest.wordKey}` is empty');
    }
  }
}
