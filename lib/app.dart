import 'package:flutter/material.dart';
import 'package:brewlog/l10n/gen/app_localizations.dart';

import 'package:brewlog/core/theme/brew_theme.dart';
import 'package:brewlog/presentation/screens/home_shell.dart';

class BrewLogApp extends StatelessWidget {
  const BrewLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrewLog',
      debugShowCheckedModeBanner: false,
      theme: buildBrewTheme(),
      // §10 MUST:支援 zh-TW + en,跟隨系統,可手動切換
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('zh', 'TW'), Locale('en')],
      locale: const Locale('zh', 'TW'),
      home: const HomeShell(),
    );
  }
}
