/// CLI options.
extension type const GlobalOptions(({String name, String abbr}) value) {
  /// Get help.
  static const help = GlobalOptions((name: 'help', abbr: 'h'));

  /// Get current CLI version.
  static const version = GlobalOptions((name: 'version', abbr: ''));

  /// Enable verbose mode.
  static const verbose = GlobalOptions((name: 'verbose', abbr: 'v'));

  /// Option name.
  String get name => value.name;

  /// Option abbr.
  String get abbr => value.abbr;

  /// Option help message.
  String get helpMessage => switch (this) {
        help => 'Print this usage information.',
        version => 'Print the tool version.',
        verbose => 'Show additional command output.',
        _ => '',
      };
}
