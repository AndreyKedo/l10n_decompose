class L10nManifest {
  L10nManifest({
    required this.config,
    required this.package,
  });

  final String package;
  final Map<String, Object?> config;

  @override
  String toString() {
    return 'L10nManifest(package: $package, config: $config)';
  }
}
