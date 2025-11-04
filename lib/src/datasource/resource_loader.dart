import 'dart:io';

import 'package:yaml/yaml.dart';

abstract class ResourceLoader<T> {
  const ResourceLoader();

  T load(String path);
}

/// Exception thrown when resource to load is fail.
sealed class ResourceLoaderException implements Exception {
  const ResourceLoaderException({required this.code, required this.message});

  final String code;
  final String message;

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceLoaderException &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          message == other.message;
}

/// Exception thrown when a resource is not found.
final class ResourceNotFoundException extends ResourceLoaderException {
  const ResourceNotFoundException() : super(code: kCode, message: 'Resource not found');

  static const kCode = 'resource_not_found';
}

/// Exception thrown when a resource is not in the correct format.
final class ResourceFormatException extends ResourceLoaderException {
  const ResourceFormatException([String? message])
    : super(code: kCode, message: message ?? 'Resource format exception');

  static const kCode = 'resource_format_exception';
}

/// Loads a YAML configuration file.
class YamlConfigurationLoader extends ResourceLoader<YamlMap> {
  const YamlConfigurationLoader();

  /// Loads a YAML configuration file.
  ///
  /// Throws a [ResourceNotFoundException] if the file does not exist.
  /// Throws a [ResourceFormatException] if the file is not a valid YAML file.
  @override
  YamlMap load(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      throw ResourceNotFoundException();
    }
    final content = file.readAsStringSync();
    try {
      return loadYaml(content) as YamlMap;
    } on YamlException catch (e) {
      throw ResourceFormatException(e.message);
    } on ArgumentError catch (e) {
      throw ResourceFormatException(e.message);
    } on Exception catch (e) {
      throw ResourceFormatException(e.toString());
    }
  }
}
