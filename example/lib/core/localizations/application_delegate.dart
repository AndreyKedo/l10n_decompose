import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'gen/app_localizations.dart';
import 'gen/settings_localization.dart';

abstract final class ApplicationDelegate {
  static const localizationsDelegates = <LocalizationsDelegate<Object>>[
    AppLocalizations.delegate,
    SettingsLocalizations.delegate,

    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const supportedLocales = <Locale>[Locale('ru'), Locale('en')];
}

extension ApplicationLocalization on BuildContext {
  AppLocalizations get lcl => AppLocalizations.of(this)!;

  SettingsLocalizations get lclSettings => SettingsLocalizations.of(this)!;
}
