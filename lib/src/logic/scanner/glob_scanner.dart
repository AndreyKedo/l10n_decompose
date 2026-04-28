import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:l10n_decompose/src/logic/scanner/arb_scanner.dart';

class GlobScanner implements ArbScanner {
  GlobScanner({required this.lookupPattern});

  final String lookupPattern;

  late final glob = Glob(lookupPattern);

  @override
  List<ArbEntry> scan() {
    final entries = glob.listSync();
    return entries.whereType<File>().map(ArbEntry.new).toList(growable: false);
  }
}
