import 'dart:io';

import 'package:args/args.dart';
import 'package:l10n_decompose/cli_constants.dart';
import 'package:l10n_decompose/src/datasource/resource_loader.dart';
import 'package:l10n_decompose/src/logic/delegates_class_builder.dart';
import 'package:l10n_decompose/src/logic/manifest_parser.dart';
import 'package:l10n_decompose/src/logic/options_builder.dart';
import 'package:l10n_decompose/src/logic/config_parser.dart';
import 'package:l10n_decompose/src/logic/directory_scanner.dart';
import 'package:l10n_decompose/src/logic/localization_node_generator.dart';
import 'package:l10n_decompose/src/logic/yaml_validation_exception.dart';
import 'package:l10n_decompose/src/model/l10n_decompose_options.dart';
import 'package:l10n_decompose/src/utils/logger.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

/// Implementation the `l10n-decompose` command.
class L10nDecomposeCommand {
  L10nDecomposeCommand({required this.resourceLoader, required this.logger});

  final ResourceLoader<YamlMap> resourceLoader;
  final AppLogger logger;

  String l10nConfig = DefaultL10nDecomposeConfig.l10nConfig;
  String newName = DefaultL10nDecomposeConfig.l10nConfig;

  File? getL10nConfigIfExist([String? name]) {
    final config = File(name ?? l10nConfig);
    if (!config.existsSync()) return null;
    return config;
  }

  void muteL10nConfig() {
    if (getL10nConfigIfExist() case final file when file != null) {
      final name = basename(file.path);
      newName = '$name.lock';
      file.renameSync(newName);
    }
  }

  void unMiteL10nConfig() {
    if (getL10nConfigIfExist(newName) case final file when file != null) {
      final name = basename(file.path);
      newName = name.replaceAll('.lock', '');
      file.renameSync(newName);
    }
  }

  void execute(ArgResults _) {
    bool completedWithError = true;
    String message = '';
    try {
      final manifestSource = resourceLoader.load(DefaultL10nManifest.sourceFileName);

      final configuration = manifestParser.fuse(configDecode).convert(manifestSource);

      final directories = scanByPath(configuration.dir);
      logger.d('Scanned directories: ${directories.map((e) => e.path).toList(growable: false)}');

      final nodeGenerator = LocalizationNodeGenerator(config: configuration);

      final nodes = nodeGenerator.generate(directories);

      // Утилита `flutter gen-l10n` по умолчанию ищет файл `l10n.yaml` в текущей директории.
      // Если она его находит, то игнорирует все переданные параметры и устанавливает его в качестве основного файла конфигурации.
      muteL10nConfig();

      for (var node in nodes) {
        final options = OptionsBuilder()
          ..addOption(L10nOption.arbDir(node.config.arbDir))
          ..addOption(L10nOption.templateArbFile(node.config.templateArbFile))
          ..addOption(L10nOption.outputDir(node.config.outputDir))
          ..addOption(L10nOption.outputLocalizationFile(node.config.outputLocalizationFile))
          ..addOption(L10nOption.outputClass(node.config.outputClass));

        final configOptions = configuration.options;
        for (var option in L10nDecomposeOptionKey.all) {
          if (!configOptions.isContains(option)) continue;
          final value = configOptions.isEnabled(option);
          switch (option) {
            case L10nDecomposeOptionKey.format:
              options.addOption(L10nOption.format(value));
            case L10nDecomposeOptionKey.nullableGetter:
              options.addOption(L10nOption.nullableGetter(value));
          }
        }

        final optionsList = options.build();
        logger.d("Command options $optionsList");

        final result = Process.runSync(CliConstants.flutter, [
          CliConstants.l10nCommand,
          ...optionsList.expand((option) => option.split(' ')),
        ]);

        if (result.exitCode != 0) {
          logger.e("l10n command exit with code ${result.exitCode}");
          message = result.stderr;
          break;
        } else {
          logger.d("Node ${node.name} is completed localization");
          completedWithError = false;
        }
      }

      // Generate composite delegates file
      if (!completedWithError) {
        // Generate composite delegates file
        if (configuration.composite case final composite when composite != null) {
          final manifest = manifestParser.convert(manifestSource);
          final compositeFileBuilder = DelegatesClassBuilder(
            package: manifest.package,
            nodes: nodes,
            className: composite.outputClass,
          );

          File(composite.filePath).writeAsStringSync(compositeFileBuilder.build());
        }
      }
    } on ResourceLoaderException catch (e) {
      message = e.message;
    } on YamlValidationException catch (e) {
      message = e.message;
    } on Exception catch (e) {
      message = e.toString();
    }
    unMiteL10nConfig();

    if (completedWithError) {
      logger.e(message);
      exit(1);
    } else {
      logger.i('Localization is completed');
    }
  }
}
