import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brewlog/app.dart';
import 'package:brewlog/data/datasources/local/hive_setup.dart';
import 'package:brewlog/core/constants/brew_methods.dart';
import 'package:brewlog/core/constants/grinders.dart';
import 'package:brewlog/application/providers/locale_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStore.init();
  // §6.1 / §6.4:啟動時載入 JSON-driven catalog
  await BrewMethodCatalog.instance.load();
  await GrinderCatalog.instance.load();
  // §10 MUST:預載使用者選的 locale,確保第一個 frame 就帶正確設定
  final initialLocale = await loadInitialLocale();
  final localeController = LocaleController(initialLocale);

  // Riverpod ProviderScope 仍需在外層,因為其他螢幕是 ConsumerWidget
  runApp(ProviderScope(
    child: BrewLogApp(localeController: localeController),
  ));
}
