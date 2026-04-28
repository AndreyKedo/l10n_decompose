extension type const L10nDecomposeOptionKey(String rawValue) implements String {
  static const nullableGetter = L10nDecomposeOptionKey('nullable-getter');
  static const format = L10nDecomposeOptionKey('format');

  static const all = {nullableGetter, format};
}

extension type const L10nDecomposeOptions(Map<L10nDecomposeOptionKey, bool> options) {
  bool isEnabled(L10nDecomposeOptionKey key) => options[key] ?? false;

  bool isContains(L10nDecomposeOptionKey key) => options.containsKey(key);
}
