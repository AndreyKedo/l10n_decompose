import 'package:flutter/widgets.dart';
import 'package:l10n_decompose_example/core/l10n/app_localization.dart';
import 'package:l10n_decompose_example/core/l10n/composite_localizations.dart';
import 'package:l10n_decompose_example/feature/application/l10n/application_localization.dart';
import 'package:l10n_decompose_example/feature/home/l10n/home_localization.dart';
import 'package:l10n_decompose_example/feature/settings/localization/gen/settings_locale.dart';

extension type ApplicationLocalization(BuildContext _context) {
  static final delegates = CompositeLocalizations.localizationsDelegates;

  AppLocalizations get coreLcl => AppLocalizations.of(_context);

  ApplicationLocalizations get appLcl => ApplicationLocalizations.of(_context);

  SettingsLocalization get settingsLcl => SettingsLocalization.of(_context);

  HomeLocalizations get homeLcl => HomeLocalizations.of(_context);
}
