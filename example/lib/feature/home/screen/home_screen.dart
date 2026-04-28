import 'package:flutter/material.dart';
import 'package:l10n_decompose_example/core/l10n/localization.dart';

final class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = ApplicationLocalization(context);
    return Scaffold(
      appBar: AppBar(title: Text("${localization.coreLcl.appName} - Home")),
      body: Center(child: Text(localization.homeLcl.welcome)),
    );
  }
}
