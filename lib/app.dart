import 'package:flutter/material.dart';
import 'package:brewlog/l10n/gen/app_localizations.dart';

import 'package:brewlog/core/theme/brew_theme.dart';
import 'package:brewlog/application/providers/locale_provider.dart';
import 'package:brewlog/presentation/screens/home_shell.dart';

class BrewLogApp extends StatefulWidget {
  const BrewLogApp({super.key, required this.localeController});
  final LocaleController localeController;

  @override
  State<BrewLogApp> createState() => _BrewLogAppState();
}

class _BrewLogAppState extends State<BrewLogApp> {
  @override
  void initState() {
    super.initState();
    widget.localeController.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.localeController.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LocaleScope(
      controller: widget.localeController,
      child: AnimatedBuilder(
        animation: widget.localeController,
        builder: (context, _) => MaterialApp(
          title: 'BrewLog',
          debugShowCheckedModeBanner: false,
          theme: buildBrewTheme(),
          // §10 MUST:跟隨系統 / zh-TW / en,可在「我的」手動切換並持久化
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: const [Locale('zh', 'TW'), Locale('en')],
          locale: widget.localeController.value,
          home: const HomeShell(),
        ),
      ),
    );
  }
}
