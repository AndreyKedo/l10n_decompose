import 'package:args/args.dart';
import 'package:l10n_decompose/src/command/l10n_decompose_command.dart';
import 'package:l10n_decompose/src/datasource/resource_loader.dart';
import 'package:l10n_decompose/src/utils/console_utils.dart';
import 'package:l10n_decompose/src/utils/logger.dart';
import 'package:logging/logging.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Print this usage information.')
    ..addFlag('verbose', abbr: 'v', negatable: false, help: 'Show additional command output.')
    ..addFlag('version', negatable: false, help: 'Print the tool version.');
}

void printUsage(ArgParser argParser) {
  ConsolePrinter.i('\nUsage: dart l10n_decompose.dart <flags> [arguments]\n\n${argParser.usage}');
}

void main(List<String> arguments) {
  final resourceLoader = YamlConfigurationLoader();

  final argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    AppLogger.enableLogger();

    // Process the parsed arguments.
    if (results.flag('help')) {
      printUsage(argParser);
      return;
    }
    if (results.flag('version')) {
      ConsolePrinter.i(version);
      return;
    }
    if (results.flag('verbose')) {
      AppLogger.r.setLogLevel(Level.FINER);
    }

    final command = L10nDecomposeCommand(resourceLoader: resourceLoader, logger: AppLogger.r);

    command.execute(results);
  } on FormatException catch (e) {
    ConsolePrinter.e(e.message);
    printUsage(argParser);
  }
}
