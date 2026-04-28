class YamlValidationException implements Exception {
  YamlValidationException({this.code = kCode, this.message = kMessage});

  static const kCode = 'yaml_validation_error';
  static const kMessage = 'Invalid YAML format';

  final String code;
  final String message;

  @override
  String toString() {
    return 'YamlValidationFormatException($code: $message)';
  }
}
