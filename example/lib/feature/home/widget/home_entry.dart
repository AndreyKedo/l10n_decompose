import 'package:flutter/material.dart';
import 'package:l10n_decompose_example/feature/home/localization/home_localization.dart';
import 'package:l10n_decompose_example/feature/home/screen/home_screen.dart';

final class HomeEntry extends StatelessWidget {
  const HomeEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Localizations.override(context: context, delegates: [HomeLocalizations.delegate], child: HomeScreen());
  }
}
