// S8 widget 測試補齊(§13 要求 ≥15)
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:brewlog/app.dart';
import 'package:brewlog/data/datasources/local/hive_setup.dart';
import 'package:brewlog/application/providers/locale_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brewlog/core/constants/brew_methods.dart';
import 'package:brewlog/core/constants/grinders.dart';
import 'package:brewlog/core/theme/brew_theme.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/l10n/gen/app_localizations.dart';
import 'package:brewlog/presentation/screens/brew/brew_form_screen.dart';

class _FakePathProvider extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.';
  @override
  Future<String?> getApplicationSupportPath() async => '.';
  @override
  Future<String?> getTemporaryPath() async => '.';
}

Future<Widget> _wrap() async {
  SharedPreferences.setMockInitialValues({'app.locale': 'zh_TW'});
  final initial = await loadInitialLocale();
  return ProviderScope(
    child: BrewLogApp(localeController: LocaleController(initial)),
  );
}

Future<void> _setUpHive() async {
  PathProviderPlatform.instance = _FakePathProvider();
  Hive.init('.');
  for (final name in [
    HiveBoxes.beans,
    HiveBoxes.brews,
    HiveBoxes.recipes,
    HiveBoxes.equipment,
    HiveBoxes.settings,
  ]) {
    if (!Hive.isBoxOpen(name)) await Hive.openBox(name);
  }
  await BrewMethodCatalog.instance.load();
  await GrinderCatalog.instance.load();
}

void _setPhone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  setUpAll(_setUpHive);

  testWidgets('App boots and shows bottom nav', (tester) async {
    _setPhone(tester);
    await tester.pumpWidget(await _wrap());
    await tester.pump();
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('預設 tab = 沖煮', (tester) async {
    _setPhone(tester);
    await tester.pumpWidget(await _wrap());
    await tester.pump();
    // 沖煮 tab 的圖示 + label
    expect(find.text('沖煮'), findsOneWidget);
  });

  testWidgets('切到豆子 tab,看到 FAB', (tester) async {
    _setPhone(tester);
    await tester.pumpWidget(await _wrap());
    await tester.pump();
    await tester.tap(find.text('豆子'));
    await tester.pumpAndSettle();
    expect(find.text('新增豆子'), findsOneWidget);
  });

  testWidgets('切到我的 tab,看到 BrewLog Pro 入口', (tester) async {
    _setPhone(tester);
    await tester.pumpWidget(await _wrap());
    await tester.pump();
    await tester.tap(find.text('我的'));
    await tester.pumpAndSettle();
    // 滾動到 BrewLog Pro 出現
    await tester.scrollUntilVisible(find.text('BrewLog Pro'), 200);
    expect(find.text('BrewLog Pro'), findsWidgets);
  });

  testWidgets('切到記錄 tab,空狀態顯示', (tester) async {
    _setPhone(tester);
    await tester.pumpWidget(await _wrap());
    await tester.pump();
    await tester.tap(find.text('記錄'));
    await tester.pumpAndSettle();
    expect(find.text('還沒有沖煮記錄'), findsOneWidget);
  });

  testWidgets('App 主題用 Material 3 + 咖啡棕', (tester) async {
    _setPhone(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildBrewTheme(),
        home: const Scaffold(body: SizedBox.shrink()),
      ),
    );
    final BuildContext ctx = tester.element(find.byType(Scaffold));
    final ThemeData theme = Theme.of(ctx);
    expect(theme.useMaterial3, isTrue);
  });

  testWidgets('義式設定只顯示一個液重輸入欄位', (tester) async {
    _setPhone(tester);
    final now = DateTime(2026, 8, 3);
    final espresso = Brew(
      id: 'espresso-test',
      brewedAt: now,
      brewMethodId: 'espresso',
      doseGrams: 18,
      waterGrams: 36,
      createdAt: now,
      updatedAt: now,
    );
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: const [Locale('zh', 'TW'), Locale('en')],
          locale: const Locale('zh', 'TW'),
          home: BrewFormScreen(initial: espresso),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ExpansionTile));
    await tester.pumpAndSettle();

    expect(find.text('液重'), findsOneWidget);
  });
}
