import 'package:path/path.dart';

extension type PathUtils._(Context context) implements Context {
  factory PathUtils(String root) => PathUtils._(Context(style: Style.platform, current: root));
}
