// extension type const L10nDecomposeOption(int mask) {
//   static const nullableGetter = L10nDecomposeOption(1 << 3);

//   static const format = L10nDecomposeOption(1 << 4);

//   static const all = {nullableGetter, format};

//   /// Whether or not to use named parameters for the generated localization methods.
//   static bool contains(L10nDecomposeOption options, L10nDecomposeOption option) {
//     return (options.mask & option.mask) == option.mask;
//   }

//   /// Appends the given option to the given options.
//   static L10nDecomposeOption append(L10nDecomposeOption options, L10nDecomposeOption option) {
//     return options | option;
//   }

//   /// Returns a new L10nOption with the given mask.
//   L10nDecomposeOption operator |(L10nDecomposeOption other) => L10nDecomposeOption(mask | other.mask);
// }

extension type const L10nDecomposeOptionKey(String rawValue) implements String {
  static const nullableGetter = L10nDecomposeOptionKey('nullable-getter');
  static const format = L10nDecomposeOptionKey('format');

  static const all = {nullableGetter, format};
}

extension type const L10nDecomposeOptions(Map<L10nDecomposeOptionKey, bool> options) {
  bool isEnabled(L10nDecomposeOptionKey key) => options[key] ?? false;

  bool isContains(L10nDecomposeOptionKey key) => options.containsKey(key);
}
