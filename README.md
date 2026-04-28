## l10n Decompose

[![Pub](https://img.shields.io/pub/v/l10n_decompose.svg)](https://pub.dev/packages/l10n_decompose)

A CLI tool for generating localization spread across different directories. Built on top of `flutter gen‑l10n`, it allows you to decompose localization by features or modules.

## Quick Start

Add a dev dependency to your project:

```bash
dart pub add dev:l10n_decompose
```

Add the configuration section to `pubspec.yaml` (see below) and run:

```bash
dart run l10n_decompose
```

## How It Works

The tool scans the project for `.arb` files matching the `input` pattern and, for each found group of files, runs `flutter gen‑l10n` with individual parameters. This enables separate localization classes for each feature while keeping a single generation process.

### Core Behavior

1. **Scanning** – the tool searches for all files matching the `input` pattern (default `**_en.arb`). Each such group of files is considered a separate *localization unit* (node).
2. **Parameter determination** – for each node, based on the path to the template `.arb` file, the following are computed:
   - `arb‑dir` – the directory containing the `.arb` files of this node.
   - `template‑arb‑file` – the name of the template file (e.g., `auth_en.arb`).
   - `output‑dir` – the directory for generated Dart files (determined by the `output` parameter).
   - `output‑localization‑file` – the name of the main generated file (without locale suffix).
   - `output‑class` – the name of the generated class (determined by the `output‑class` parameter).
3. **Running `flutter gen‑l10n`** – for each node, `flutter gen‑l10n` is invoked with the computed parameters. The `l10n.yaml` file (if present) is temporarily renamed so that `gen‑l10n` does not use the global configuration.
4. **Composite file generation** – if `composite` is enabled in the configuration, after all nodes are successfully generated, a file is created that combines all delegates into a single static list.

## Configuration

Configuration is placed in the `l10n_decompose` section of `pubspec.yaml`. All parameters except `parts` are global and can be overridden for individual parts.

### Full Configuration Example

```yaml
l10n_decompose:
  # Pattern for searching template .arb files (required)
  input: "**_en.arb"

  # Pattern for output directories (optional, default "gen/*_localization.dart")
  output: gen/*_localization.dart

  # Class name pattern (optional, default "*Localizations")
  output-class: "*Localizations"

  # Format generated code (optional, default false)
  format: false

  # Nullable getters (optional, default true)
  nullable-getter: true

  # Composite file settings (optional)
  composite:
    enabled: true
    outputFile: lib/general_localizations.dart
    outputClass: GeneralLocalizations

  # Fine‑grained settings for individual parts (optional)
  parts:
    - name: core
      output: localization/app_locale.dart
      outputClass: AppLocale
```

### Detailed Parameter Description

#### `input` (search pattern)

Defines which files are considered *template* `.arb` files. The pattern uses glob syntax and should contain `**` for recursive search. Usually includes a language suffix (e.g., `_en.arb` or `_en_US.arb`).

**Examples:**
- `"**_en.arb"` – will find `auth/l10n/auth_en.arb`, `core/l10n/app_en.arb`, etc.
- `"lib/feature/**/_en.arb"` – restricts search to the `lib/feature` directory.

> **Important:** the prefix (the part before `_en.arb`) can be anything, but `snake_case` is recommended.

#### `output` (output directory pattern)

Defines where the generated Dart files will be placed. The pattern may contain `*`, which will be replaced with the prefix of the template `.arb` file.

**Examples:**
- `gen/*_localization.dart` – for file `auth_en.arb` the output directory will be `gen`, and the main file will be `auth_localization.dart`.
- `localization/*.dart` – output directory `localization`, file `auth.dart`.

The path can be relative (relative to the directory containing the `.arb` files) or absolute (starting with `/` or `lib/`).

#### `output‑class` (class name pattern)

Defines the name of the generated class. May contain `*`, which is replaced with the prefix of the template `.arb` file (converted to `PascalCase`).

**Examples:**
- `"*Localizations"` – for `auth_en.arb` yields class `AuthLocalizations`.
- `"*Locale"` – for `app_en.arb` yields `AppLocale`.

If the pattern does not contain `*`, the given name is used as‑is (for all nodes).

#### `format` and `nullable‑getter`

These parameters are passed directly to `flutter gen‑l10n`. Their default values match the behavior of `gen‑l10n` (`format: false`, `nullable‑getter: true`).

#### `composite` (delegate aggregation)

If `enabled: true`, after generating all nodes, a separate file is created containing an abstract class with a static `localizationsDelegates` field that aggregates all delegates from the generated nodes.

- `outputFile` – path to the created file (relative to the project root).
- `outputClass` – class name.

#### `parts` (fine‑tuning for specific nodes)

Allows overriding global parameters for particular nodes. Each entry in `parts` must contain a `name` field that matches the prefix of the template `.arb` file (without the `_en.arb` suffix).

**Example:** for file `core/l10n/app_en.arb` the prefix is `app`. To customize its output, add:

```yaml
parts:
  - name: app
    output: lib/core/localization/app_locale.dart
    outputClass: AppLocale
```

The `output` and `output‑class` fields work the same as the global ones but apply only to the node with the given name.

## Example Project Structure

Assume you have a project with the following structure:

```
lib/
├── core/
│   ├── l10n/
│   │   ├── app_en.arb
│   │   └── app_ru.arb
├── feature/
│   ├── auth/
│   │   ├── l10n/
│   │   │   ├── auth_en.arb
│   │   │   └── auth_ru.arb
│   ├── settings/
│   │   ├── l10n/
│   │   │   ├── settings_en.arb
│   │   │   └── settings_ru.arb
```

With the default configuration, after running `dart run l10n_decompose` you will get:

```
lib/
├── core/
│   ├── l10n/                    (source .arb files)
│   |   └── gen/
│   │       ├── app_localization.dart
│   │       ├── app_localization_en.dart
│   │       └── app_localization_ru.dart
├── feature/
│   ├── auth/
│   │   ├── l10n/
│   │   |   └── gen/
│   │   │       ├── auth_localization.dart
│   │   │       ├── auth_localization_en.dart
│   │   │       └── auth_localization_ru.dart
│   ├── settings/
│   │   ├── l10n/
│   │   |   └── gen/
│   │   │       ├── settings_localization.dart
│   │   │       ├── settings_localization_en.dart
│   │   │       └── settings_localization_ru.dart
```

If `composite` is enabled, an additional file `lib/general_localizations.dart` will be created with content like:

```dart
abstract class GeneralLocalizations {
  static const localizationsDelegates = [
    AppLocalizations.delegate,
    AuthLocalizations.delegate,
    SettingsLocalizations.delegate,
  ];

  static const supportedLocales = <Locale>[
    Locale('ru'),
    Locale('en'),
  ];
}
```

## Using Together with `flutter gen‑l10n`

`l10n_decompose` does not replace the standard Flutter utility; it complements it. You can:

- Use `l10n_decompose` to generate localization per feature.
- Use `flutter gen‑l10n` to generate global localization (if you have an `l10n.yaml`).
- Combine both approaches by temporarily renaming `l10n.yaml` (which `l10n_decompose` does automatically).

## Repository Example

The `example` folder contains a complete Flutter project demonstrating the tool. You can explore its structure and configuration.

## License

MIT