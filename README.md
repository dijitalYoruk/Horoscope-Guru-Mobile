# Horoscope Guru App

A Flutter app that provides horoscope readings and astrological insights with AI assistance.

## Localization Support

The app now supports localization in English and Turkish. The localization system uses Flutter's built-in internationalization support.

### Localization Structure

- `l10n.yaml`: Configuration file for Flutter localization
- `lib/l10n/app_en.arb`: English localization strings
- `lib/l10n/app_tr.arb`: Turkish localization strings
- Generated files in `.dart_tool/flutter_gen/gen_l10n/`

### Adding a New Language

To add a new language:

1. Create a new ARB file in the `lib/l10n` directory, following the naming pattern `app_<language_code>.arb`
2. Copy the content from `app_en.arb` and translate all values
3. Run `flutter pub get && flutter gen-l10n` to generate the necessary files
4. Add the new locale to the supported locales list in `main.dart`:

```dart
supportedLocales: const [
  Locale('en'), // English
  Locale('tr'), // Turkish
  Locale('xx'), // New language
],
```

### Using Localized Strings

To use localized strings in your widgets:

```dart
final localizations = AppLocalizations.of(context)!;
Text(localizations.appTitle)
```

### Changing Language at Runtime

The app includes a language selector component that allows users to change their language preference at runtime. The selected language is stored in SharedPreferences and loaded when the app starts.

## Features

- Horoscope readings
- Cosmic chat with AI
- User profile with birth details
- Dark theme
- Multilanguage support (English, Turkish)

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter gen-l10n` to generate localization files
4. Run `flutter run` to start the app

## Dependencies

- flutter_localizations
- intl
- shared_preferences
- flutter_markdown
- And more (see pubspec.yaml)
