// §10 驗收:locale 切換可運作 + 持久化
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brewlog/application/providers/locale_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('decodeLocale/en/zh_TW/null 各回對應 Locale', () {
    expect(decodeLocale(null), isNull);
    expect(decodeLocale('en'), const Locale('en'));
    expect(decodeLocale('zh_TW'), const Locale('zh', 'TW'));
    expect(decodeLocale('unknown_value'), isNull);
  });

  test('encodeLocale 雙向 encode/decode 互逆', () {
    expect(encodeLocale(null), isNull);
    expect(encodeLocale(const Locale('en')), 'en');
    expect(encodeLocale(const Locale('zh', 'TW')), 'zh_TW');
    // 對偶:decode(encode(x)) == x
    expect(decodeLocale(encodeLocale(const Locale('en'))), const Locale('en'));
    expect(decodeLocale(encodeLocale(const Locale('zh', 'TW'))), const Locale('zh', 'TW'));
    expect(decodeLocale(encodeLocale(null)), isNull);
  });

  test('loadInitialLocale 從 SharedPreferences 讀預載值', () async {
    SharedPreferences.setMockInitialValues({'app.locale': 'zh_TW'});
    final Locale? loaded = await loadInitialLocale();
    expect(loaded, const Locale('zh', 'TW'));

    SharedPreferences.setMockInitialValues({'app.locale': 'en'});
    expect(await loadInitialLocale(), const Locale('en'));

    SharedPreferences.setMockInitialValues({});
    expect(await loadInitialLocale(), isNull);
  });

  test('LocalePersistence.persist(切換應寫進 SharedPreferences)', () async {
    final prefs = await SharedPreferences.getInstance();

    // 初始:無
    expect(prefs.getString(kLocalePrefKey), null);

    // 切到 en
    await LocalePersistence.persist(const Locale('en'));
    expect(prefs.getString(kLocalePrefKey), 'en');

    // 切到 zh-TW
    await LocalePersistence.persist(const Locale('zh', 'TW'));
    expect(prefs.getString(kLocalePrefKey), 'zh_TW');

    // 切回 跟隨系統(null)
    await LocalePersistence.persist(null);
    expect(prefs.getString(kLocalePrefKey), null);
  });

  test('LocaleController.value setter 不重複通知', () async {
    final controller = LocaleController(null);
    var notifiedCount = 0;
    controller.addListener(() => notifiedCount++);

    // 同值不通知
    controller.value = null;
    expect(notifiedCount, 0);

    // 不同值才通知
    controller.value = const Locale('en');
    expect(notifiedCount, 1);

    // 同值不通知
    controller.value = const Locale('en');
    expect(notifiedCount, 1);

    // 切回 null
    controller.value = null;
    expect(notifiedCount, 2);
  });
}
