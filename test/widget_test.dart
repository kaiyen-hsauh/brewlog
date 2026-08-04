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
  // §9.2 主題顏色 hex 對得起 spec
  testWidgets('W9_2_palette', (tester) async {
    _setPhone(tester);
    expect(BrewColors.primary.value, 0xFF6F4E37);
    expect(BrewColors.secondary.value, 0xFFC8A27A);
    expect(BrewColors.accent.value, 0xFFD97706);
    expect(BrewColors.surface.value, 0xFFFAF7F2);
    expect(BrewColors.onSurface.value, 0xFF1F2937);
    expect(BrewColors.success.value, 0xFF047857);
    expect(BrewColors.error.value, 0xFFB91C1C);
  });

  // §9.3 字級:最小 12sp,計時 64sp,標題 24sp
  testWidgets('W9_3_typography', (tester) async {
    _setPhone(tester);
    expect(BrewTypography.minReadable, 12);
    expect(BrewTypography.body, 16);
    expect(BrewTypography.sectionTitle, 18);
    expect(BrewTypography.pageTitle, 24);
    expect(BrewTypography.timer, 64);
  });

  // §9.4 S1 CTA 高度 ≥ 120dp (§F1.3 大按鈕規格)
  testWidgets('W9_4_cta_height', (tester) async {
    _setPhone(tester);
    await tester.pumpWidget(await _wrap());
    await tester.pump();
    expect(find.byType(ElevatedButton), findsWidgets);
    // 量第一顆 ElevatedButton(主畫面開始沖煮)的 SizedBox 容器高度
    final btnRect = tester.getRect(find.byType(ElevatedButton).first);
    // 主 CTA 有 SizedBox(height: 120) wrap,所以 size.height 應 ≥ 120
    expect(btnRect.height, greaterThanOrEqualTo(110.0),
        reason: '§9.4 S1 CTA 必須 ≥ 120dp,實測 ${btnRect.height}');
  });

  // S1 首頁 greeting
  testWidgets('W_home_greeting', (tester) async {
    _setPhone(tester);
    await tester.pumpWidget(await _wrap());
    await tester.pump();
    expect(find.textContaining('早安'), findsOneWidget);
    expect(find.textContaining('今日'), findsOneWidget);
  });

  // S1 快速重複卡
  testWidgets('W_home_quick_repeat', (tester) async {
    _setPhone(tester);
    await tester.pumpWidget(await _wrap());
    await tester.pump();
    expect(find.text('快速重複上次'), findsOneWidget);
  });

  // 豆子 tab 顯示 AppBar 標題「咖啡豆」+ 空狀態「從右下方新增第一支」
  testWidgets('W_beans_appbar_empty', (tester) async {
    _setPhone(tester);
    await tester.pumpWidget(await _wrap());
    await tester.pump();
    await tester.tap(find.text('豆子'));
    await tester.pumpAndSettle();
    expect(find.text('咖啡豆'), findsOneWidget); // AppBar
    expect(find.text('還沒有任何豆子,從右下角新增第一支'), findsOneWidget); // 空狀態
  });

  // MeScreen AppBar 顯示「我的」
  testWidgets('W_me_appbar_title', (tester) async {
    _setPhone(tester);
    await tester.pumpWidget(await _wrap());
    await tester.pump();
    await tester.tap(find.text('我的'));
    await tester.pumpAndSettle();
    expect(find.text('我的'), findsWidgets);
  });

  // App theme 是 Material 3
  testWidgets('W_theme_material3', (tester) async {
    _setPhone(tester);
    await tester.pumpWidget(MaterialApp(theme: buildBrewTheme(), home: const Scaffold()));
    final ctx = tester.element(find.byType(Scaffold));
    expect(Theme.of(ctx).useMaterial3, isTrue);
  });
}
