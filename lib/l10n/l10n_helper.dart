// i18n helper — AppLocalizations.of(context)! 統一封裝
import 'package:brewlog/l10n/gen/app_localizations.dart';
import 'package:flutter/widgets.dart';

extension AppL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
