// §6.4 磨豆機刻度庫 — JSON-driven + 支援使用者自訂
// MUST:清單需可擴充(§6.4 實作要求)
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

@immutable
class Grinder {
  final String id;
  final String name;
  final String unitLabelZh;
  final String unitLabelEn;
  final double minSetting;
  final double maxSetting;
  final double step;
  final bool isBuiltIn;

  const Grinder({
    required this.id,
    required this.name,
    required this.unitLabelZh,
    required this.unitLabelEn,
    required this.minSetting,
    required this.maxSetting,
    required this.step,
    this.isBuiltIn = true,
  });

  Grinder copyWith({String? name}) => Grinder(
        id: id,
        name: name ?? this.name,
        unitLabelZh: unitLabelZh,
        unitLabelEn: unitLabelEn,
        minSetting: minSetting,
        maxSetting: maxSetting,
        step: step,
        isBuiltIn: isBuiltIn,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'unit_zh': unitLabelZh,
        'unit_en': unitLabelEn,
        'min': minSetting,
        'max': maxSetting,
        'step': step,
        'is_built_in': isBuiltIn,
      };

  factory Grinder.fromJson(Map<String, dynamic> j) => Grinder(
        id: j['id'] as String,
        name: j['name'] as String,
        unitLabelZh: j['unit_zh'] as String,
        unitLabelEn: j['unit_en'] as String,
        minSetting: (j['min'] as num).toDouble(),
        maxSetting: (j['max'] as num).toDouble(),
        step: (j['step'] as num).toDouble(),
        isBuiltIn: (j['is_built_in'] as bool?) ?? true,
      );
}

/// 動態磨豆機清單(內建從 JSON 載 + 使用者自訂追加)
class GrinderCatalog extends ChangeNotifier {
  GrinderCatalog._();
  static final GrinderCatalog instance = GrinderCatalog._();

  static const _assetPath = 'assets/data/grinders.json';
  static const _uuid = Uuid();

  final List<Grinder> _custom = [];
  List<Grinder> _builtIn = const [];

  List<Grinder> get builtIn => List.unmodifiable(_builtIn);
  List<Grinder> get custom => List.unmodifiable(_custom);
  List<Grinder> get all => [..._builtIn, ..._custom];

  /// 由 id 查(內建優先,再自訂)
  Grinder? byId(String? id) {
    if (id == null) return null;
    for (final g in _builtIn) {
      if (g.id == id) return g;
    }
    for (final g in _custom) {
      if (g.id == id) return g;
    }
    return null;
  }

  /// 載入內建 — App 啟動時呼叫
  Future<void> load() async {
    final raw = await rootBundle.loadString(_assetPath);
    final list = (jsonDecode(raw) as List)
        .cast<Map<String, dynamic>>()
        .map(Grinder.fromJson)
        .toList(growable: false);
    _builtIn = list;
  }

  /// 加自訂磨豆機(§6.4 SHOULD)
  Grinder addCustom({
    required String name,
    required String unitLabelZh,
    required String unitLabelEn,
    required double minSetting,
    required double maxSetting,
    required double step,
  }) {
    final g = Grinder(
      id: 'custom_${_uuid.v4()}',
      name: name,
      unitLabelZh: unitLabelZh,
      unitLabelEn: unitLabelEn,
      minSetting: minSetting,
      maxSetting: maxSetting,
      step: step,
      isBuiltIn: false,
    );
    _custom.add(g);
    notifyListeners();
    return g;
  }

  void removeCustom(String id) {
    _custom.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  /// 觸發 notify(UI 手動強制刷新)
  void touch() => notifyListeners();
}
