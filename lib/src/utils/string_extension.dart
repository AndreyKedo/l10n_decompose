extension StringExtension on String {
  String capitalizalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
