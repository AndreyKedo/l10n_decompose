import 'dart:collection';
import 'dart:io';

import 'package:l10n_decompose/cli_constants.dart';
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
    return name.split('_').map((part) => part.capitalizalize()).join('');
  }

  @protected
  @visibleForTesting
  String replaceByPattern(String pattern, String value) {
    return pattern.replaceFirst('%', value);
  }

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
    final partName = basename(directory.path);

    final partsConfig = config.parts;

    for (var part in partsConfig) {
      if (part.name == partName) {
        // Обработка абсолютных путей для outputDir
        return LocalizationNodeConfig(
          arbDir: join(partPath, part.arbDir ?? config.arbDir),
          outputDir: resolveOutputDir(directory.path, part.outputDir ?? config.outputDir),
          templateArbFile: replaceByPattern(
            part.templateArbFile ?? DefaultL10nDecomposeConfig.templateArbFile,
            partName,
          ),
          outputLocalizationFile: replaceByPattern(
            part.outputLocalizationFile ?? config.outputLocalizationFile,
            partName,
          ),
          outputClass: replaceByPattern(part.outputClass ?? config.outputClass, convertToClassName(partName)),
        );
      }
    }

    final className = convertToClassName(partName);

    return LocalizationNodeConfig(
      arbDir: join(partPath, config.arbDir),
      outputDir: resolveOutputDir(directory.path, config.outputDir),
      templateArbFile: replaceByPattern(DefaultL10nDecomposeConfig.templateArbFile, partName),
      outputLocalizationFile: replaceByPattern(config.outputLocalizationFile, partName),
      outputClass: replaceByPattern(config.outputClass, className),
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
