import 'package:args/args.dart';
import 'package:l10n_decompose/src/command/l10n_decompose_command.dart';
import 'package:l10n_decompose/src/datasource/resource_loader.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Print this usage information.')
    ..addFlag('verbose', abbr: 'v', negatable: false, help: 'Show additional command output.')
    ..addFlag('version', negatable: false, help: 'Print the tool version.');
}

void printUsage(ArgParser argParser) {
  print('Usage: dart l10n_decompose.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) {
  final resourceLoader = YamlConfigurationLoader();

  final argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.flag('help')) {
      printUsage(argParser);
      return;
    }
    if (results.flag('version')) {
      print('l10n_decompose version: $version');
      return;
    }
    if (results.flag('verbose')) {
      verbose = true;
    }

    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }

    final command = L10nDecomposeCommand(resourceLoader: resourceLoader);

    command.execute(results);
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
