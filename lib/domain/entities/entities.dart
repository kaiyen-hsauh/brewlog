// §7 領域模型 — 純 Dart,含手寫 fromJson/toJson(§8.2 MUST:不依賴 build_runner)

import 'package:uuid/uuid.dart';

const _uuid = Uuid();
String genId() => _uuid.v4();

String? _s2n(String? s) => (s == null || s.isEmpty) ? null : s;
DateTime? _parseDate(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString());
}

String? _dateToJson(DateTime? d) => d?.toIso8601String();

// ─────────── PourStep ───────────
class PourStep {
  final int order;
  final int atSecond;
  final double cumulativeWaterGrams;
  final String? label;
  const PourStep({
    required this.order,
    required this.atSecond,
    required this.cumulativeWaterGrams,
    this.label,
  });
  Map<String, dynamic> toJson() => {
    'order': order,
    'at_second': atSecond,
    'cumulative_water_g': cumulativeWaterGrams,
    'label': label,
  };
  factory PourStep.fromJson(Map<String, dynamic> j) => PourStep(
    order: j['order'] as int,
    atSecond: j['at_second'] as int,
    cumulativeWaterGrams: (j['cumulative_water_g'] as num).toDouble(),
    label: _s2n(j['label'] as String?),
  );
}

// ─────────── Bean ───────────
class Bean {
  final String id;
  final String name;
  final String? roaster;
  final String? origin;
  final String? farm;
  final String? variety;
  final String? processingKey;
  final String? roastLevelKey;
  final DateTime? roastDate;
  final DateTime? purchaseDate;
  final double? weightGrams;
  final double? price;
  final String? currency;
  final String? altitude;
  final String? notes;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId;
  final DateTime? syncedAt;

  const Bean({
    required this.id,
    required this.name,
    this.roaster,
    this.origin,
    this.farm,
    this.variety,
    this.processingKey,
    this.roastLevelKey,
    this.roastDate,
    this.purchaseDate,
    this.weightGrams,
    this.price,
    this.currency,
    this.altitude,
    this.notes,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    this.syncedAt,
  });

  Bean copyWith({
    String? name,
    String? roaster,
    String? origin,
    String? farm,
    String? variety,
    String? processingKey,
    String? roastLevelKey,
    DateTime? roastDate,
    DateTime? purchaseDate,
    double? weightGrams,
    double? price,
    String? currency,
    String? altitude,
    String? notes,
    String? photoPath,
    DateTime? updatedAt,
  }) => Bean(
    id: id,
    name: name ?? this.name,
    roaster: roaster ?? this.roaster,
    origin: origin ?? this.origin,
    farm: farm ?? this.farm,
    variety: variety ?? this.variety,
    processingKey: processingKey ?? this.processingKey,
    roastLevelKey: roastLevelKey ?? this.roastLevelKey,
    roastDate: roastDate ?? this.roastDate,
    purchaseDate: purchaseDate ?? this.purchaseDate,
    weightGrams: weightGrams ?? this.weightGrams,
    price: price ?? this.price,
    currency: currency ?? this.currency,
    altitude: altitude ?? this.altitude,
    notes: notes ?? this.notes,
    photoPath: photoPath ?? this.photoPath,
    createdAt: createdAt,
    updatedAt: updatedAt ?? DateTime.now(),
    userId: userId,
    syncedAt: syncedAt,
  );

  int? get restDays {
    if (roastDate == null) return null;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final roasted = DateTime(roastDate!.year, roastDate!.month, roastDate!.day);
    return today.difference(roasted).inDays;
  }

  String? get restDaysHintZh {
    final d = restDays;
    if (d == null) return null;
    if (d < 0) return '烘焙日期異常';
    if (d <= 3) return '排氣旺盛期,風味尚未穩定';
    if (d <= 14) return '適飲期';
    if (d <= 30) return '穩定期';
    return '風味可能已衰退';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'roaster': roaster,
    'origin': origin,
    'farm': farm,
    'variety': variety,
    'processing': processingKey,
    'roast_level': roastLevelKey,
    'roast_date': _dateToJson(roastDate),
    'purchase_date': _dateToJson(purchaseDate),
    'weight_g': weightGrams,
    'price': price,
    'currency': currency,
    'altitude': altitude,
    'notes': notes,
    'photo_path': photoPath,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'user_id': userId,
    'synced_at': _dateToJson(syncedAt),
  };

  factory Bean.fromJson(Map<String, dynamic> j) => Bean(
    id: j['id'] as String,
    name: j['name'] as String,
    roaster: _s2n(j['roaster'] as String?),
    origin: _s2n(j['origin'] as String?),
    farm: _s2n(j['farm'] as String?),
    variety: _s2n(j['variety'] as String?),
    processingKey: _s2n(j['processing'] as String?),
    roastLevelKey: _s2n(j['roast_level'] as String?),
    roastDate: _parseDate(j['roast_date']),
    purchaseDate: _parseDate(j['purchase_date']),
    weightGrams: (j['weight_g'] as num?)?.toDouble(),
    price: (j['price'] as num?)?.toDouble(),
    currency: _s2n(j['currency'] as String?),
    altitude: _s2n(j['altitude'] as String?),
    notes: _s2n(j['notes'] as String?),
    photoPath: _s2n(j['photo_path'] as String?),
    createdAt: _parseDate(j['created_at']) ?? DateTime.now(),
    updatedAt: _parseDate(j['updated_at']) ?? DateTime.now(),
    userId: _s2n(j['user_id'] as String?),
    syncedAt: _parseDate(j['synced_at']),
  );
}

// ─────────── Recipe ───────────
class Recipe {
  final String id;
  final String name;
  final String brewMethodId;
  final double ratioDenominator;
  final double? grindSetting;
  final String? grinderId;
  final double? waterTempC;
  final double? bloomWaterGrams;
  final int? bloomSeconds;
  final List<PourStep> pourSchedule;
  final bool isFavorite;
  final DateTime createdAt;

  const Recipe({
    required this.id,
    required this.name,
    required this.brewMethodId,
    required this.ratioDenominator,
    this.grindSetting,
    this.grinderId,
    this.waterTempC,
    this.bloomWaterGrams,
    this.bloomSeconds,
    this.pourSchedule = const [],
    this.isFavorite = false,
    required this.createdAt,
  });

  Recipe copyWith({
    String? name,
    String? brewMethodId,
    double? ratioDenominator,
    double? grindSetting,
    String? grinderId,
    double? waterTempC,
    double? bloomWaterGrams,
    int? bloomSeconds,
    List<PourStep>? pourSchedule,
    bool? isFavorite,
  }) => Recipe(
    id: id,
    name: name ?? this.name,
    brewMethodId: brewMethodId ?? this.brewMethodId,
    ratioDenominator: ratioDenominator ?? this.ratioDenominator,
    grindSetting: grindSetting ?? this.grindSetting,
    grinderId: grinderId ?? this.grinderId,
    waterTempC: waterTempC ?? this.waterTempC,
    bloomWaterGrams: bloomWaterGrams ?? this.bloomWaterGrams,
    bloomSeconds: bloomSeconds ?? this.bloomSeconds,
    pourSchedule: pourSchedule ?? this.pourSchedule,
    isFavorite: isFavorite ?? this.isFavorite,
    createdAt: createdAt,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'brew_method': brewMethodId,
    'ratio_denominator': ratioDenominator,
    'grind_setting': grindSetting,
    'grinder_id': grinderId,
    'water_temp_c': waterTempC,
    'bloom_water_g': bloomWaterGrams,
    'bloom_seconds': bloomSeconds,
    'pour_schedule': pourSchedule.map((s) => s.toJson()).toList(),
    'is_favorite': isFavorite,
    'created_at': createdAt.toIso8601String(),
  };

  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
    id: j['id'] as String,
    name: j['name'] as String,
    brewMethodId: j['brew_method'] as String,
    ratioDenominator: (j['ratio_denominator'] as num).toDouble(),
    grindSetting: (j['grind_setting'] as num?)?.toDouble(),
    grinderId: _s2n(j['grinder_id'] as String?),
    waterTempC: (j['water_temp_c'] as num?)?.toDouble(),
    bloomWaterGrams: (j['bloom_water_g'] as num?)?.toDouble(),
    bloomSeconds: (j['bloom_seconds'] as num?)?.toInt(),
    pourSchedule: ((j['pour_schedule'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .map(PourStep.fromJson)
        .toList(),
    isFavorite: (j['is_favorite'] as bool?) ?? false,
    createdAt: _parseDate(j['created_at']) ?? DateTime.now(),
  );
}

// ─────────── Brew ───────────
class Brew {
  final String id;
  final DateTime brewedAt;
  final String? beanId;
  final String brewMethodId;
  final String? recipeId;
  final double doseGrams;
  final double waterGrams;
  final double? grindSetting;
  final String? grinderId;
  final double? waterTempC;
  final double? bloomWaterGrams;
  final int? bloomSeconds;
  final List<PourStep> pourSchedule;
  final int? totalBrewSeconds;
  final double? beverageMassGrams;
  final double? tdsPercent;
  final String? filterType;
  final String? waterProfile;
  final double? acidity;
  final double? sweetness;
  final double? body;
  final double? bitterness;
  final double? aftertaste;
  final double? balance;
  final double? overallRating;
  final List<String> flavorTags;
  final List<String> defects;
  final String? notes;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId;
  final DateTime? syncedAt;
  final bool? isPublic;

  const Brew({
    required this.id,
    required this.brewedAt,
    this.beanId,
    required this.brewMethodId,
    this.recipeId,
    required this.doseGrams,
    required this.waterGrams,
    this.grindSetting,
    this.grinderId,
    this.waterTempC,
    this.bloomWaterGrams,
    this.bloomSeconds,
    this.pourSchedule = const [],
    this.totalBrewSeconds,
    this.beverageMassGrams,
    this.tdsPercent,
    this.filterType,
    this.waterProfile,
    this.acidity,
    this.sweetness,
    this.body,
    this.bitterness,
    this.aftertaste,
    this.balance,
    this.overallRating,
    this.flavorTags = const [],
    this.defects = const [],
    this.notes,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    this.syncedAt,
    this.isPublic,
  });

  /// §F4.1 粉水比 → 顯示為 1:XX.X
  String get ratioDisplay {
    if (doseGrams <= 0) return '—';
    return '1:${(waterGrams / doseGrams).toStringAsFixed(1)}';
  }

  /// §F4.1 萃取率 EY。未填液重用估算值並標示「(估算)」。
  ExtractionYield? get extractionYield {
    if (doseGrams <= 0) return null;
    if (tdsPercent == null) return null;
    final mass = beverageMassGrams ?? (waterGrams - doseGrams * 2.0);
    final isEstimated = beverageMassGrams == null;
    final ey = (tdsPercent! * mass) / doseGrams;
    return ExtractionYield(eyPercent: ey, isEstimatedMass: isEstimated);
  }

  /// 建立一筆新的沖煮草稿，沿用沖煮設定但不帶入上一次的結果。
  Brew duplicate({String? id, DateTime? now}) {
    final timestamp = now ?? DateTime.now();
    return Brew(
      id: id ?? genId(),
      brewedAt: timestamp,
      beanId: beanId,
      brewMethodId: brewMethodId,
      recipeId: recipeId,
      doseGrams: doseGrams,
      waterGrams: waterGrams,
      grindSetting: grindSetting,
      grinderId: grinderId,
      waterTempC: waterTempC,
      bloomWaterGrams: bloomWaterGrams,
      bloomSeconds: bloomSeconds,
      pourSchedule: List<PourStep>.from(pourSchedule),
      filterType: filterType,
      waterProfile: waterProfile,
      createdAt: timestamp,
      updatedAt: timestamp,
      userId: userId,
      isPublic: isPublic,
    );
  }

  Brew copyWith({
    DateTime? brewedAt,
    String? beanId,
    String? brewMethodId,
    String? recipeId,
    double? doseGrams,
    double? waterGrams,
    double? grindSetting,
    String? grinderId,
    double? waterTempC,
    double? bloomWaterGrams,
    int? bloomSeconds,
    List<PourStep>? pourSchedule,
    int? totalBrewSeconds,
    double? beverageMassGrams,
    double? tdsPercent,
    String? filterType,
    String? waterProfile,
    double? acidity,
    double? sweetness,
    double? body,
    double? bitterness,
    double? aftertaste,
    double? balance,
    double? overallRating,
    List<String>? flavorTags,
    List<String>? defects,
    String? notes,
    String? photoPath,
    DateTime? updatedAt,
  }) => Brew(
    id: id,
    brewedAt: brewedAt ?? this.brewedAt,
    beanId: beanId ?? this.beanId,
    brewMethodId: brewMethodId ?? this.brewMethodId,
    recipeId: recipeId ?? this.recipeId,
    doseGrams: doseGrams ?? this.doseGrams,
    waterGrams: waterGrams ?? this.waterGrams,
    grindSetting: grindSetting ?? this.grindSetting,
    grinderId: grinderId ?? this.grinderId,
    waterTempC: waterTempC ?? this.waterTempC,
    bloomWaterGrams: bloomWaterGrams ?? this.bloomWaterGrams,
    bloomSeconds: bloomSeconds ?? this.bloomSeconds,
    pourSchedule: pourSchedule ?? this.pourSchedule,
    totalBrewSeconds: totalBrewSeconds ?? this.totalBrewSeconds,
    beverageMassGrams: beverageMassGrams ?? this.beverageMassGrams,
    tdsPercent: tdsPercent ?? this.tdsPercent,
    filterType: filterType ?? this.filterType,
    waterProfile: waterProfile ?? this.waterProfile,
    acidity: acidity ?? this.acidity,
    sweetness: sweetness ?? this.sweetness,
    body: body ?? this.body,
    bitterness: bitterness ?? this.bitterness,
    aftertaste: aftertaste ?? this.aftertaste,
    balance: balance ?? this.balance,
    overallRating: overallRating ?? this.overallRating,
    flavorTags: flavorTags ?? this.flavorTags,
    defects: defects ?? this.defects,
    notes: notes ?? this.notes,
    photoPath: photoPath ?? this.photoPath,
    createdAt: createdAt,
    updatedAt: updatedAt ?? DateTime.now(),
    userId: userId,
    syncedAt: syncedAt,
    isPublic: isPublic,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'brewed_at': brewedAt.toIso8601String(),
    'bean_id': beanId,
    'brew_method': brewMethodId,
    'recipe_id': recipeId,
    'dose_g': doseGrams,
    'water_g': waterGrams,
    'grind_setting': grindSetting,
    'grinder_id': grinderId,
    'water_temp_c': waterTempC,
    'bloom_water_g': bloomWaterGrams,
    'bloom_seconds': bloomSeconds,
    'pour_schedule': pourSchedule.map((s) => s.toJson()).toList(),
    'total_brew_seconds': totalBrewSeconds,
    'beverage_mass_g': beverageMassGrams,
    'tds_percent': tdsPercent,
    'filter_type': filterType,
    'water_profile': waterProfile,
    'acidity': acidity,
    'sweetness': sweetness,
    'body': body,
    'bitterness': bitterness,
    'aftertaste': aftertaste,
    'balance': balance,
    'overall_rating': overallRating,
    'flavor_tags': flavorTags,
    'defects': defects,
    'notes': notes,
    'photo_path': photoPath,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'user_id': userId,
    'synced_at': _dateToJson(syncedAt),
    'is_public': isPublic,
  };

  factory Brew.fromJson(Map<String, dynamic> j) => Brew(
    id: j['id'] as String,
    brewedAt: _parseDate(j['brewed_at']) ?? DateTime.now(),
    beanId: _s2n(j['bean_id'] as String?),
    brewMethodId: j['brew_method'] as String,
    recipeId: _s2n(j['recipe_id'] as String?),
    doseGrams: (j['dose_g'] as num).toDouble(),
    waterGrams: (j['water_g'] as num).toDouble(),
    grindSetting: (j['grind_setting'] as num?)?.toDouble(),
    grinderId: _s2n(j['grinder_id'] as String?),
    waterTempC: (j['water_temp_c'] as num?)?.toDouble(),
    bloomWaterGrams: (j['bloom_water_g'] as num?)?.toDouble(),
    bloomSeconds: (j['bloom_seconds'] as num?)?.toInt(),
    pourSchedule: ((j['pour_schedule'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .map(PourStep.fromJson)
        .toList(),
    totalBrewSeconds: (j['total_brew_seconds'] as num?)?.toInt(),
    beverageMassGrams: (j['beverage_mass_g'] as num?)?.toDouble(),
    tdsPercent: (j['tds_percent'] as num?)?.toDouble(),
    filterType: _s2n(j['filter_type'] as String?),
    waterProfile: _s2n(j['water_profile'] as String?),
    acidity: (j['acidity'] as num?)?.toDouble(),
    sweetness: (j['sweetness'] as num?)?.toDouble(),
    body: (j['body'] as num?)?.toDouble(),
    bitterness: (j['bitterness'] as num?)?.toDouble(),
    aftertaste: (j['aftertaste'] as num?)?.toDouble(),
    balance: (j['balance'] as num?)?.toDouble(),
    overallRating: (j['overall_rating'] as num?)?.toDouble(),
    flavorTags: ((j['flavor_tags'] as List?) ?? const []).cast<String>(),
    defects: ((j['defects'] as List?) ?? const []).cast<String>(),
    notes: _s2n(j['notes'] as String?),
    photoPath: _s2n(j['photo_path'] as String?),
    createdAt: _parseDate(j['created_at']) ?? DateTime.now(),
    updatedAt: _parseDate(j['updated_at']) ?? DateTime.now(),
    userId: _s2n(j['user_id'] as String?),
    syncedAt: _parseDate(j['synced_at']),
    isPublic: j['is_public'] as bool?,
  );
}

class ExtractionYield {
  final double eyPercent;
  final bool isEstimatedMass;
  const ExtractionYield({
    required this.eyPercent,
    required this.isEstimatedMass,
  });
}

// ─────────── Equipment ───────────
class Equipment {
  final String id;
  final String type;
  final String name;
  final String? notes;
  const Equipment({
    required this.id,
    required this.type,
    required this.name,
    this.notes,
  });

  Equipment copyWith({String? name, String? notes, String? type}) => Equipment(
    id: id,
    type: type ?? this.type,
    name: name ?? this.name,
    notes: notes ?? this.notes,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'name': name,
    'notes': notes,
  };

  factory Equipment.fromJson(Map<String, dynamic> j) => Equipment(
    id: j['id'] as String,
    type: j['type'] as String,
    name: j['name'] as String,
    notes: _s2n(j['notes'] as String?),
  );
}
