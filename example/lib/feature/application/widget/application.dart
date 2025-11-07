import 'package:flutter/material.dart';
import 'package:l10n_decompose_example/core/localizations/application_delegate.dart';
import 'package:l10n_decompose_example/feature/application/localization/application_localization.dart';
import 'package:l10n_decompose_example/feature/home/widget/home_entry.dart';

final class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [...ApplicationDelegate.localizationsDelegates, ApplicationLocalizations.delegate],
      supportedLocales: ApplicationDelegate.supportedLocales,
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text(context.lcl.appName)),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text('Application feature localization: ${ApplicationLocalizations.of(context).welcome}'),
                Text('Settings localization: ${context.lclSettings.settings}'),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => HomeEntry()));
                  },
                  child: Text('Open home'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
