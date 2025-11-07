Helpful CLI for generating localization spread across different directories. For generating localization using `flutter gen-l10n`.

## Get started

Add dev dependency to your project `dart pub add dev:l10n_decompose`

```yaml
dev_dependencies:
  l10n_decompose: ^0.1.0
```

## How to use

For example, if you have a feature `auth`, you would create a directory called `l10n` within the `auth` directory and add the .arb localization files. Create a configuration file `l10n-decompose.yaml` and run command `dart run l10n_decompose`.

Full configuration file:
```yaml
# Required
dir: lib/feature

# Optional; Use pattern %_en.arb or static name.
template-arb-file: "%_en.arb"

#Optional; By default l10n
arb-dir: l10n

# Optional; By default, the directory name "localization" is used, which will be created relative to.
# To place in an absolute directory, use / at the beginning of the path. For example /lib/core/localization
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
  - name: home
    # Optional; Use pattern %_en.arb or static name.
    template-arb-file: home_en.arb
    # Optional; By default use Global settings
    arbDir: l10n
    # Optional; By default use Global settings
    outputDir: localization
    # Optional; By default use Global settings
    outputLocalizationFile: main_locale.dart
    # Optional; By default use Global settings
    outputClass: MainLocale
```

After running the command, the auth directory would look like this:
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

The CLI extends `flutter gen-l10n` and can be used together. For example, you can use the CLI to generate localization files for a specific directory and then use `flutter gen-l10n` to generate the localization files for the entire project. Example:

```
core
├── l10n
│   ├── app_en.arb
│   ├── app_ru.arb
├── localization
│   ├── app_localizations_en.dart
│   ├── app_localizations_ru.dart
│   ├── app_localizations.dart
feature
├── auth
|   ├── l10n
|   │   ├── auth_en.arb
|   │   ├── auth_ru.arb
|   ├── localization
|   │   ├── auth_localizations_en.dart
|   │   ├── auth_localizations_ru.dart
|   │   ├── auth_localizations.dart
```