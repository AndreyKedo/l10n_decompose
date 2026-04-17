import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:l10n_decompose/src/model/localization_node.dart';
import 'package:path/path.dart' as p;

/// {@template delegates_class_builder}
/// An object for generating source code for a composite delegate class.
/// {@endtemplate}
class DelegatesClassBuilder {
  /// {@macro delegates_class_builder}
  ///
  /// - [package] - package identifier.
  /// - [nodes] - a localization entries.
  /// - [className] - name for generated delegate class.
  DelegatesClassBuilder({
    required this.package,
    required this.nodes,
    required this.className,
    //this.supportedLocales = const ['en', 'ru'],
  });

  final String package;
  final List<LocalizationNode> nodes;
  final String className;
  //final List<String> supportedLocales;

  late final _dartFormatter = DartFormatter(
    languageVersion: DartFormatter.latestLanguageVersion,
  );

  /// Building the source code.
  String build() {
    // Создаём библиотеку
    final library = Library(
      (b) => b..body.add(_buildClass()),
    );

    final emitter = DartEmitter.scoped();
    return _dartFormatter.format('${library.accept(emitter)}');
  }

  String _relativeImportPath(LocalizationNode node) {
    // Вычисляем абсолютный путь к файлу локализации
    final localizationFile = p.setExtension(
        p.join(
          p.relative(node.config.outputDir, from: 'lib'),
          node.config.outputLocalizationFile,
        ),
        '.dart');

    return 'package:$package/$localizationFile';
  }

  Class _buildClass() {
    return Class(
      (b) => b
        ..abstract = true
        ..name = className
        ..fields.addAll([
          _buildLocalizationsDelegatesField(),
          //_buildSupportedLocalesField(),
        ]),
    );
  }

  Field _buildLocalizationsDelegatesField() {
    final delegates = <Code>[];
    for (final node in nodes) {
      final className = node.config.outputClass;
      final importPath = _relativeImportPath(node);
      delegates.add(refer('$className.delegate', importPath).code);
    }

    return Field(
      (b) => b
        ..name = 'localizationsDelegates'
        ..static = true
        ..modifier = FieldModifier.constant
        ..assignment = literalList(delegates).code,
    );
  }

  // Field _buildSupportedLocalesField() {
  //   final localeType = refer('Locale', 'package:flutter/material.dart');
  //   final locales = supportedLocales.map((lang) => localeType.call([literalString(lang)]).code).toList();

  //   return Field(
  //     (b) => b
  //       ..name = 'supportedLocales'
  //       ..static = true
  //       ..modifier = FieldModifier.constant
  //       ..assignment = literalList(locales, localeType).code,
  //   );
  // }
}
