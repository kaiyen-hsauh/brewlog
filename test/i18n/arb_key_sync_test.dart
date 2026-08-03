// §10 MUST:zh-TW / en ARB key 完全一致
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('app_zh.arb, app_zh_TW.arb, app_en.arb have identical keys', () {
    final zhBase = File('lib/l10n/app_zh.arb').readAsStringSync();
    final zhTw = File('lib/l10n/app_zh_TW.arb').readAsStringSync();
    final enRaw = File('lib/l10n/app_en.arb').readAsStringSync();

    final zhBaseMap = (jsonDecode(zhBase) as Map).cast<String, dynamic>();
    final zhTwMap = (jsonDecode(zhTw) as Map).cast<String, dynamic>();
    final enMap = (jsonDecode(enRaw) as Map).cast<String, dynamic>();

    // 過濾 metadata (@xxx 開頭與 @xxx 描述)
    String stripMeta(String k) => k.startsWith('@') ? k.substring(1) : k;

    final zhBaseKeys = zhBaseMap.keys.map(stripMeta).toSet();
    final zhTwKeys = zhTwMap.keys.map(stripMeta).toSet();
    final enKeys = enMap.keys.map(stripMeta).toSet();

    // base 與 zh_TW 應該一致
    expect(
      zhBaseKeys.difference(zhTwKeys),
      isEmpty,
      reason: 'zh base 有但 zh_TW 缺:${zhBaseKeys.difference(zhTwKeys)}',
    );
    expect(
      zhTwKeys.difference(zhBaseKeys),
      isEmpty,
      reason: 'zh_TW 有但 zh base 缺:${zhTwKeys.difference(zhBaseKeys)}',
    );
    // §10 MUST:zh 與 en 必須完全一致
    expect(
      zhBaseKeys.difference(enKeys),
      isEmpty,
      reason: 'zh 有但 en 缺:${zhBaseKeys.difference(enKeys)}',
    );
    expect(
      enKeys.difference(zhBaseKeys),
      isEmpty,
      reason: 'en 有但 zh 缺:${enKeys.difference(zhBaseKeys)}',
    );
  });
}
