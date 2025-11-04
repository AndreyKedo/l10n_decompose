import 'dart:io';

import 'package:args/args.dart';
import 'package:l10n_decompose/cli_constants.dart';
import 'package:l10n_decompose/src/datasource/resource_loader.dart';
import 'package:l10n_decompose/src/logic/command_builder.dart';
import 'package:l10n_decompose/src/logic/config_parser.dart';
import 'package:l10n_decompose/src/logic/file_system_tools.dart';
import 'package:l10n_decompose/src/logic/localization_node_generator.dart';
import 'package:l10n_decompose/src/model/l10n_decompose_options.dart';
import 'package:l10n_decompose/src/utils/console_utils.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

class L10nDecomposeCommand {
  L10nDecomposeCommand({required this.resourceLoader});

  final ResourceLoader<YamlMap> resourceLoader;

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

  void execute(ArgResults results) {
    bool completedWithError = true;
    String message = '';
    try {
      final yamlSource = resourceLoader.load(DefaultL10nDecomposeConfig.configFileName);
      YamlConfigValidator.validate(yamlSource);

      final configuration = configDecode.convert(yamlSource);

      final directories = scanByPath(configuration.dir);
      ConsolePrinter.i('Result scanEntries: ${directories.map((e) => e.path).toList(growable: false)}');

      final nodeGenerator = LocalizationNodeGenerator(config: configuration);

      final nodes = nodeGenerator.generate(directories);
      muteL10nConfig();
      print(nodes);
      // completedWithError = false;
      for (var node in nodes) {
        final options = OptionsBuilder();
        options.addOption(L10nOption.arbDir(node.config.arbDir));
        options.addOption(L10nOption.templateArbFile(node.config.templateArbFile));
        options.addOption(L10nOption.outputDir(node.config.outputDir));
        options.addOption(L10nOption.outputLocalizationFile(node.config.outputLocalizationFile));
        options.addOption(L10nOption.outputClass(node.config.outputClass));

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

        final result = Process.runSync(CliConstants.flutter, [
          CliConstants.l10nCommand,
          ...options.build().expand((option) => option.split(' ')),
        ]);

        if (result.exitCode != 0) {
          message = result.stderr;
          break;
        } else {
          ConsolePrinter.i("Node ${node.name} is completed localization");
          completedWithError = false;
        }
      }
    } on ResourceLoaderException catch (e) {
      message = e.message;
    } on YamlValidationFormatException catch (e) {
      message = e.message;
    } on Exception catch (e) {
      message = e.toString();
    }
    unMiteL10nConfig();

    if (completedWithError) {
      ConsolePrinter.e(message);
      exit(1);
    }
  }
}
