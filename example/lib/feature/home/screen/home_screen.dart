import 'package:flutter/material.dart';
import 'package:l10n_decompose_example/core/localizations/application_delegate.dart';
import 'package:l10n_decompose_example/feature/home/localization/home_localization.dart';

final class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = HomeLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("${context.lcl.appName} - Home")),
      body: Center(child: Text(localization.welcome)),
    );
  }
}
