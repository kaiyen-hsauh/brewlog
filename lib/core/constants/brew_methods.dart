// §6.1 沖煮方式 — JSON 驅動(§16 決策:JSON > hardcode)
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';

@immutable
class BrewMethod {
  final String id;
  final String nameZh;
  final String nameEn;
  final double defaultRatioDenominator;
  final int defaultWaterTempC;
  final String defaultGrind;
  final String typicalTimeRange;
  final bool isEspresso;

  const BrewMethod({
    required this.id,
    required this.nameZh,
    required this.nameEn,
    required this.defaultRatioDenominator,
    required this.defaultWaterTempC,
    required this.defaultGrind,
    required this.typicalTimeRange,
    this.isEspresso = false,
  });

  factory BrewMethod.fromJson(Map<String, dynamic> j) => BrewMethod(
        id: j['id'] as String,
        nameZh: j['name_zh'] as String,
        nameEn: j['name_en'] as String,
        defaultRatioDenominator: (j['ratio'] as num).toDouble(),
        defaultWaterTempC: (j['temp'] as num).toInt(),
        defaultGrind: j['grind'] as String,
        typicalTimeRange: j['time'] as String,
        isEspresso: (j['espresso'] as bool?) ?? false,
      );
}

class BrewMethodCatalog extends ChangeNotifier {
  BrewMethodCatalog._();
  static final BrewMethodCatalog instance = BrewMethodCatalog._();
  static const _assetPath = 'assets/data/brew_methods.json';

  List<BrewMethod> _items = const [];

  List<BrewMethod> get all => List.unmodifiable(_items);

  Future<void> load() async {
    final raw = await rootBundle.loadString(_assetPath);
    _items = (jsonDecode(raw) as List)
        .cast<Map<String, dynamic>>()
        .map(BrewMethod.fromJson)
        .toList(growable: false);
    notifyListeners();
  }

  BrewMethod byId(String id) {
    for (final m in _items) {
      if (m.id == id) return m;
    }
    // 找不到就回傳 other(規格 §6.1)
    return _items.firstWhere((m) => m.id == 'other', orElse: () => _items.last);
  }
}
