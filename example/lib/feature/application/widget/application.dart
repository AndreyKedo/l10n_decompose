import 'package:flutter/material.dart';
import 'package:l10n_decompose_example/core/l10n/localization.dart';
import 'package:l10n_decompose_example/feature/home/widget/home_entry.dart';

final class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: ApplicationLocalization.delegates,
      // supportedLocales: ApplicationDelegate.supportedLocales,
      home: Builder(
        builder: (context) {
          final localization = ApplicationLocalization(context);
          return Scaffold(
            appBar: AppBar(title: Text(localization.coreLcl.appName)),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text('Application feature localization: ${localization.appLcl.welcome}'),
                Text('Settings localization: ${localization.settingsLcl.settings}'),
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
