import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brewlog/app.dart';
import 'package:brewlog/data/datasources/local/hive_setup.dart';
import 'package:brewlog/core/constants/brew_methods.dart';
import 'package:brewlog/core/constants/grinders.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStore.init();
  // §6.1 / §6.4:啟動時載入 JSON-driven catalog
  await BrewMethodCatalog.instance.load();
  await GrinderCatalog.instance.load();
  runApp(const ProviderScope(child: BrewLogApp()));
}
