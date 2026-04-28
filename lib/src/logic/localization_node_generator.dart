import 'dart:collection';
import 'package:l10n_decompose/src/logic/scanner/arb_scanner.dart';
import 'package:l10n_decompose/src/model/l10n_decompose_config.dart';
import 'package:l10n_decompose/src/model/localization_node.dart';
import 'package:l10n_decompose/src/utils/logger.dart';
import 'package:l10n_decompose/src/utils/path_utils.dart';
import 'package:l10n_decompose/src/utils/string_extension.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

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
    if (path.extension(template).isEmpty) {
      throw StateError('$template is not file name');
    }
    return template.replaceFirst('*', featureName);
  }

  @protected
  @visibleForTesting
  String generateClassFile(String template, String name) {
    final className = convertToClassName(name);

    return template.replaceFirst('*', className);
  }

  @protected
  @visibleForTesting
  String resolveOutputDir(String currentPath, String outputPath) {
    // // Обработка путей, начинающихся с '/', как относительных к корню проекта
    // if (outputPath.startsWith('/')) {
    //   // Убираем ведущий '/'
    //   outputPath = outputPath.substring(1);
    //   // Возвращаем как относительный путь (относительно корня проекта)
    //   // Не соединяем с currentPath, потому что путь уже абсолютен относительно корня
    //   return path.normalize(outputPath);
    // }

    final context = PathUtils(currentPath);
    if (path.isRootRelative(outputPath)) {
      return path.normalize(outputPath);
    }
    if (context.isRelative(outputPath)) {
      // Умное объединение путей для устранения дублирования
      String smartJoin(String base, String relative) {
        final baseComponents = path.split(base);
        final relativeComponents = path.split(relative);

        final hasMatch = baseComponents.any((segment) => segment == relativeComponents.first);

        if (hasMatch) {
          final matchSegmentIndex = baseComponents.indexOf(relativeComponents.first);
          if (matchSegmentIndex == -1) {
            throw StateError('Resolving output directory. Match segment index not found');
          }

          return path.normalize(
            path.joinAll(
              [
                ...baseComponents.sublist(0, matchSegmentIndex),
                ...relativeComponents,
              ],
            ),
          );
        } else {
          return path.normalize(path.join(base, relative));
        }
      }

      return smartJoin(currentPath, outputPath);
    }
    // Если путь не абсолютный и не относительный (например, начинается с разделителя, но не абсолютный?)
    return path.normalize(outputPath.replaceFirst(context.separator, ''));
  }

  @protected
  @visibleForTesting
  LocalizationNodeConfig generatePartialConfig(ArbEntry entry) {
    final arbDirectory = entry.directory.path;

    final outputFullPath = resolveOutputDir(arbDirectory, config.output);

    if (config.parts[entry.prefix] case LocalizationPartialConfig(:final output, :final outputClass)) {
      final outputResolved = output != null ? resolveOutputDir(arbDirectory, output) : outputFullPath;
      final outputDir = path.dirname(outputResolved);
      final outputLocalizationFile = output != null
          ? path.basename(outputResolved)
          : generateFileName(path.basename(outputFullPath), entry.prefix);

      return LocalizationNodeConfig(
        arbDir: path.normalize(arbDirectory),
        outputDir: outputDir,
        templateArbFile: entry.fileName,
        outputLocalizationFile: outputLocalizationFile,
        outputClass: outputClass ?? generateClassFile(config.outputClass, entry.prefix),
      );
    }

    return LocalizationNodeConfig(
      arbDir: path.normalize(arbDirectory),
      outputDir: path.dirname(outputFullPath),
      templateArbFile: entry.fileName,
      outputLocalizationFile: generateFileName(path.basename(outputFullPath), entry.prefix),
      outputClass: generateClassFile(config.outputClass, entry.prefix),
    );
  }

  List<LocalizationNode> generate(List<ArbEntry> forDirectories) {
    return UnmodifiableListView(
      forDirectories.map((arbFile) {
        final config = generatePartialConfig(arbFile);
        return LocalizationNode(
          name: arbFile.prefix,
          directory: arbFile.directory,
          config: config,
        );
      }),
    );
  }
}
