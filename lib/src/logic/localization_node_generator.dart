import 'dart:collection';
import 'dart:io';

import 'package:l10n_decompose/src/model/l10n_decompose_config.dart';
import 'package:l10n_decompose/src/model/localization_node.dart';
import 'package:l10n_decompose/src/utils/logger.dart';
import 'package:l10n_decompose/src/utils/path_utils.dart';
import 'package:l10n_decompose/src/utils/string_extension.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

class LocalizationNodeGenerator {
  LocalizationNodeGenerator({required this.config});

  final L10nDecomposeConfig config;
  final logger = AppLogger.named('LocalizationNodeGenerator');

  @protected
  @visibleForTesting
  String convertToClassName(String name) {
    if (name.isEmpty) {
      throw StateError('Name cannot be empty');
    }
    return name.split('_').map((part) => part.capitalize()).join('');
  }

  @protected
  @visibleForTesting
  String generateFileName(String template, String featureName) {
    if (extension(template).isEmpty) {
      throw StateError('$template is not file name');
    }

    return template.replaceFirst('%', featureName);
  }

  @protected
  @visibleForTesting
  String generateClassFile(String template, String directoryName) {
    final className = convertToClassName(directoryName);

    return template.replaceFirst('%', className);
  }

  @protected
  @visibleForTesting
  String resolveOutputDir(String currentPath, String outputPath) {
    final context = PathUtils(currentPath);

    if (context.isRelative(outputPath)) {
      return join(currentPath, outputPath);
    }
    return outputPath.replaceFirst(context.separator, '');
  }

  @protected
  @visibleForTesting
  LocalizationNodeConfig generatePartialConfig(Directory directory) {
    final partPath = directory.path;
    final directoryName = basename(directory.path);

    final partsConfig = config.parts;

    for (var part in partsConfig) {
      if (part.name == directoryName) {
        // Обработка абсолютных путей для outputDir
        return LocalizationNodeConfig(
          arbDir: join(partPath, part.arbDir ?? config.arbDir),
          outputDir: resolveOutputDir(directory.path, part.outputDir ?? config.outputDir),
          templateArbFile: generateFileName(
            part.templateArbFile ?? config.templateArbFile,
            directoryName,
          ),
          outputLocalizationFile: generateFileName(
            part.outputLocalizationFile ?? config.outputLocalizationFile,
            directoryName,
          ),
          outputClass: generateClassFile(part.outputClass ?? config.outputClass, directoryName),
        );
      }
    }

    return LocalizationNodeConfig(
      arbDir: join(partPath, config.arbDir),
      outputDir: resolveOutputDir(directory.path, config.outputDir),
      templateArbFile: generateFileName(config.templateArbFile, directoryName),
      outputLocalizationFile: generateFileName(config.outputLocalizationFile, directoryName),
      outputClass: generateClassFile(config.outputClass, directoryName),
    );
  }

  List<LocalizationNode> generate(List<Directory> forDirectories) {
    final configParts = config.parts;

    final nodes = UnmodifiableListView(
      forDirectories.map((directory) {
        final config = generatePartialConfig(directory);
        return LocalizationNode(name: basename(directory.path), directory: directory, config: config);
      }),
    );

    for (var part in configParts) {
      if (!nodes.any((node) => part.name == node.name)) {
        logger.w('Part ${part.name} is not found in directories');
      }
    }

    return nodes;
  }
}
