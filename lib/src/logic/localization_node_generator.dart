import 'dart:collection';
import 'dart:io';

import 'package:l10n_decompose/cli_constants.dart';
import 'package:l10n_decompose/src/model/l10n_decompose_config.dart';
import 'package:l10n_decompose/src/model/localization_node.dart';
import 'package:l10n_decompose/src/utils/console_utils.dart';
import 'package:l10n_decompose/src/utils/string_extension.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

class LocalizationNodeGenerator {
  LocalizationNodeGenerator({required this.config});

  final L10nDecomposeConfig config;

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

  // {Set<String> exclude = const {}, Set<String> include = const {}}
  //  final useFilter = include.isNotEmpty || exclude.isNotEmpty;
  // if (useFilter) {
  //   // Проверка пересечений
  //   final intersection = include.intersection(exclude);
  //   if (intersection.isNotEmpty) {
  //     ConsolePrinter.w('Features $intersection are both included and excluded. Exclude takes precedence.');
  //   }

  //   entrees = entrees.where((entry) {
  //     final dirName = pathUtils.basename(entry.path);

  //     if (exclude.contains(dirName)) return false;

  //     if (include.isEmpty) return true;

  //     return include.contains(dirName);
  //   });
  // }

  @protected
  @visibleForTesting
  LocalizationNodeConfig generatePartialConfig(Directory directory) {
    final partPath = directory.path;
    final partName = basename(directory.path);

    final partsConfig = config.parts;

    for (var part in partsConfig) {
      if (part.name == partName) {
        return LocalizationNodeConfig(
          arbDir: join(partPath, part.arbDir),
          outputDir: join(partPath, part.outputDir),
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
      outputDir: join(partPath, config.outputDir),
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
        ConsolePrinter.w('Part ${part.name} is not found in directories');
      }
    }

    return nodes;
  }
}
