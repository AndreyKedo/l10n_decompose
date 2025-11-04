# l10n-decompose

This CLI generate decomposed localization by different directories for each feature.

For example, if you have a function called `auth`, you would create a directory called `l10n` within the `auth` directory and add the .arb localization files. Create a configuration file `l10n-decompose.yaml`.

```yaml
## Pattern for looking for localization files
dir: lib/feature
## Optional; By default l10n
arb-dir: l10n
## Optional; By default localization
output-dir: localization
## Optional; By default use pattern %feature%_localization.dart
output-localization-file: %feature%_localization.dart
## Optional; By default use pattern %feature%Localizations
output-class: %feature%Localizations

## Optional; Getting general options from
l10n-config: ./l10n.yaml
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
