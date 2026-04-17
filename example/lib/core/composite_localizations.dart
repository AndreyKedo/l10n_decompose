// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:l10n_decompose_example/feature/settings/localization/gen/settings_localization.dart'
    as _i1;
import 'package:l10n_decompose_example/feature/home/localization/home_localization.dart'
    as _i2;
import 'package:l10n_decompose_example/feature/application/localization/application_localization.dart'
    as _i3;

abstract class CompositeLocalizations {
  static const localizationsDelegates = [
    _i1.SettingsLocalizations.delegate,
    _i2.HomeLocalizations.delegate,
    _i3.ApplicationLocalizations.delegate,
  ];
}
