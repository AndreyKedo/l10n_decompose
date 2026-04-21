// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:l10n_decompose_example/core/l10n/app_localization.dart' as _i1;
import 'package:l10n_decompose_example/feature/settings/localization/gen/settings_locale.dart'
    as _i2;
import 'package:l10n_decompose_example/feature/home/l10n/home_localization.dart'
    as _i3;
import 'package:l10n_decompose_example/feature/application/l10n/application_localization.dart'
    as _i4;

abstract class CompositeLocalizations {
  static const localizationsDelegates = [
    _i1.AppLocalizations.delegate,
    _i2.SettingsLocalization.delegate,
    _i3.HomeLocalizations.delegate,
    _i4.ApplicationLocalizations.delegate,
  ];
}
