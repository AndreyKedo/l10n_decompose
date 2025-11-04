# l10n-decompose

This CLI generate decomposed localization by different directories for each feature.

For example, if you have a function called `auth`, you would create a directory called `l10n` within the `auth` directory and add the .arb localization files. Create a configuration file `l10n-decompose.yaml`.

```yaml
# Required
dir: lib/feature

# Optional; Use pattern %_en.arb or static name.
template-arb-file: "%_en.arb"

#Optional; By default l10n
arb-dir: l10n

#Optional; By default localization
output-dir: localization

#Optional; By default use pattern %_localization.dart or static name.
output-localization-file: "%_localization.dart"

#Optional; By default use pattern %Localizations or static name.
output-class: "%Localizations"

#Optional; By default false inherited from flutter gen-l10n
format: false

#Optional; By default true inherited from flutter gen-l10n
nullable-getter: true

# Optional; 
parts:
  # Required;
  - name: auth
    # Optional; Use pattern %_en.arb or static name.
    template-arb-file: home_en.arb
    # Optional; By default l10n
    arbDir: l10n
    # Optional; By default localization
    outputDir: localization
    # Optional; By default use pattern %_localization.dart or static name.
    outputLocalizationFile: auth_localizations.dart
    # Optional; By default use pattern %Localizations or static name.
    outputClass: AuthLocalizations
```

After running the command `l10n-decompose`, the directory would look like this:
```
auth
├── l10n
│   ├── auth_en.arb
│   ├── auth_ru.arb
├── localization
│   ├── auth_localizations_en.dart
│   ├── auth_localizations_ru.dart
│   ├── auth_localizations.dart
```
