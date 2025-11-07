import 'package:l10n_decompose/src/utils/string_extension.dart';
import 'package:test/test.dart';

void main() {
  test('capitalize text', () {
    expect("lower case text".capitalize(), equals("Lower case text"));
  });
}
