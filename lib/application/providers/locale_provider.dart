// §10 MUST:支援 zh-TW + en,跟隨系統,可手動切換
//
// 設計選擇:locale 是純全域狀態,不需要進 Riverpod graph。
// 用 InheritedNotifier + InheritedWidgetChangeNotifier 模式,
//
// 持久化用 SharedPreferences;在 main() runApp 之前先 hydrate
// 確保第一個 frame 就帶正確 locale,沒有 flicker。
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kLocalePrefKey = 'app.locale';
const String kLocaleZhTw = 'zh_TW';
const String kLocaleEn = 'en';

Locale? decodeLocale(String? raw) {
  switch (raw) {
    case kLocaleZhTw:
      return const Locale('zh', 'TW');
    case kLocaleEn:
      return const Locale('en');
    default:
      return null;
  }
}

String? encodeLocale(Locale? locale) {
  if (locale == null) return null;
  if (locale.languageCode == 'en') return kLocaleEn;
  if (locale.languageCode == 'zh' &&
      (locale.countryCode == 'TW' || locale.countryCode == null)) {
    return kLocaleZhTw;
  }
  return null;
}

/// main() 啟動時讀 prefs,把讀出來的值餵給 notifier(避免第一個 frame flash)
Future<Locale?> loadInitialLocale() async {
  final prefs = await SharedPreferences.getInstance();
  return decodeLocale(prefs.getString(kLocalePrefKey));
}

/// 全域 locale change notifier;app.dart 用 AnimatedBuilder 包住整個 MaterialApp
class LocaleController extends ChangeNotifier implements ValueListenable<Locale?> {
  LocaleController(this._value);
  Locale? _value;

  @override
  Locale? get value => _value;

  set value(Locale? v) {
    if (_value == v) return;
    _value = v;
    notifyListeners();
  }
}

/// InheritedNotifier 把 LocaleController 傳遞給整棵 widget tree
class LocaleScope extends InheritedNotifier<LocaleController> {
  const LocaleScope({
    super.key,
    required LocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static LocaleController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'LocaleScope.of() must be called inside LocaleScope');
    return scope!.notifier!;
  }
}

/// 持久化 helper:寫 SharedPreferences,跟 LocaleController.value 分離
/// 這樣 UI 切換是 sync 的、寫進硬碟是 async 不擋 UI
class LocalePersistence {
  LocalePersistence._();
  static Future<void> persist(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = encodeLocale(locale);
    if (encoded == null) {
      await prefs.remove(kLocalePrefKey);
    } else {
      await prefs.setString(kLocalePrefKey, encoded);
    }
  }
}
