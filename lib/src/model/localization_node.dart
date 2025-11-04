import 'dart:io';

/// A localization node.
class LocalizationNode {
  const LocalizationNode({required this.name, required this.directory, required this.config});

  /// The name of the localization node.
  final String name;

  /// The directory of the localization node.
  final Directory directory;

  /// The configuration of the localization node.
  final LocalizationNodeConfig config;

  @override
  String toString() {
    return 'LocalizationNode(name: $name, directory: ${directory.path}, config: $config)';
  }
}

class LocalizationNodeConfig {
  const LocalizationNodeConfig({
    required this.arbDir,
    required this.outputDir,
    required this.outputLocalizationFile,
    required this.outputClass,
    required this.templateArbFile,
  });

  final String arbDir;
  final String outputDir;
  final String outputLocalizationFile;
  final String outputClass;
  final String templateArbFile;

  @override
  String toString() {
    return 'LocalizationNodeConfig(arbDir: $arbDir, '
        'outputDir: $outputDir, '
        'outputLocalizationFile: $outputLocalizationFile, '
        'outputClass: $outputClass, '
        'templateArbFile: $templateArbFile)';
  }
}
