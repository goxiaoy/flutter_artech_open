# Localization

1. Install  `flutter_intl` plugin, [Android Studio](https://plugins.jetbrains.com/plugin/13666-flutter-intl), (for projects no sound null safety ,use [v1.12](https://plugins.jetbrains.com/files/13666/100003/Flutter_Intl-1.12.0-2019.2.zip?updateId=100003&pluginId=13666&family=INTELLIJ) ) , [VS Code](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl), (for projects no sound null safety ,use [v1.13](https://marketplace.visualstudio.com/_apis/public/gallery/publishers/localizely/vsextensions/flutter-intl/1.13.0/vspackage) )

2. Initialize for your project 
   - (Android Studio) Open your project, and run Initialize for the Project command from Tools | Flutter Intl menu (command explained below)
   - (VS Code) Open your project, open the command palette and find the Flutter Intl: Initialize command.

By default en locale is added by auto-creating a file lib/l10n/intl_en.arb.

NOTE: By default the extension generates and maintains files inside lib/generated/ folder which you should not edit manually. But you should keep these files in your project repository.

3. Add dependency needed for localization:
   ```
   dependencies:
    // Other dependencies...
    flutter_localizations:
        sdk: flutter
   ```

4. Add locale. Create new files like in `lib/l10n/intl_{locale}.arb`

5. Arb files format
    ```
    {
        "pageHomeConfirm": "Confirm",
        "pageHomeWelcome": "Welcome {name}",
        "pageHomeWelcomeGender": "{gender, select, male {Hi man!} female {Hi woman!} other {Hi there!}}",
        "pageHomeWelcomeRole": "{role, select, admin {Hi admin!} manager {Hi manager!} other {Hi visitor!}}",
        "pageNotificationsCount": "{howMany, plural, one{1 message} other{{howMany} messages}}"
    }
    ```
6. Add to your module
   - create new delegate to fix flutter localization bug
  
    ```dart
        import 'package:artech_core/core.dart';
        import 'package:flutter/cupertino.dart';

        import 'generated/intl/messages_all.dart';
        import 'generated/l10n.dart';

        class MultiAppLocalizationsDelegate extends AppLocalizationDelegate {
        const MultiAppLocalizationsDelegate();

        static const AppLocalizationDelegate delegate =
            MultiAppLocalizationsDelegate();

        @override
        Future<S> load(Locale locale) {
            return MultipleLocalizations.load(
                initializeMessages, locale, (l) => S.load(locale),
                setDefaultLocale: true);
        }
        }

    ```

   - add delegate to your project
    ```
    @override
    void configureServices() {
        configTyped<LocalizationOption>(configurator: (opt) {
        opt.delegates.add(MultiAppLocalizationsDelegate.delegate);
        ...
    });
    ```

7. In your `MaterialApp`
   ```
    var opt = services.get<LocalizationOption>();

    return MaterialApp(
        localizationsDelegates: opt.reversedDelegates
        ...
   ```
