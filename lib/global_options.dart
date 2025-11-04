extension type const GlobalOptions(({String name, String abbr}) value) {
  static const help = GlobalOptions((name: 'help', abbr: 'h'));
  static const version = GlobalOptions((name: 'version', abbr: 'v'));

  String get helpMessage => switch (this) {
    help => 'Print this usage information.',
    version => 'Print the tool version.',
    _ => '',
  };
}
