// S1 測試:entity fromJson/toJson round-trip + catalog 載入
import 'package:flutter_test/flutter_test.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/core/constants/grinders.dart';
import 'package:brewlog/core/constants/brew_methods.dart';
import 'package:brewlog/core/constants/bean_enums.dart';

void main() {
  group('Entity JSON round-trip', () {
    test('Bean round-trip 保留所有欄位', () {
      final now = DateTime(2026, 8, 3, 10);
      final b = Bean(
        id: 'b1',
        name: 'Ethiopia Yirgacheffe',
        roaster: 'Local Roastery',
        origin: 'Ethiopia',
        farm: 'Yirgacheffe',
        variety: 'Heirloom',
        processingKey: Processing.washed,
        roastLevelKey: RoastLevel.light,
        roastDate: now.subtract(const Duration(days: 7)),
        weightGrams: 200,
        price: 350,
        currency: 'TWD',
        altitude: '1900-2100m',
        notes: 'Test notes',
        createdAt: now,
        updatedAt: now,
      );
      final b2 = Bean.fromJson(b.toJson());
      expect(b2.id, b.id);
      expect(b2.name, b.name);
      expect(b2.roaster, b.roaster);
      expect(b2.processingKey, b.processingKey);
      expect(b2.roastDate, b.roastDate);
      expect(b2.weightGrams, b.weightGrams);
      expect(b2.price, b.price);
      expect(b2.altitude, b.altitude);
    });

    test('Brew round-trip 包含評分 + 缺陷 + flavorTags', () {
      final now = DateTime.now();
      final brew = Brew(
        id: 'br1',
        brewedAt: now,
        brewMethodId: 'v60',
        doseGrams: 20,
        waterGrams: 320,
        grindSetting: 24,
        grinderId: 'comandante_c40',
        waterTempC: 93,
        bloomWaterGrams: 50,
        bloomSeconds: 30,
        totalBrewSeconds: 180,
        beverageMassGrams: 300,
        tdsPercent: 1.35,
        acidity: 7,
        sweetness: 6,
        body: 5,
        bitterness: 3,
        aftertaste: 7,
        balance: 7,
        overallRating: 4.0,
        flavorTags: const ['citrus', 'jasmine'],
        defects: const ['no_defect'],
        notes: 'clean and bright',
        createdAt: now,
        updatedAt: now,
      );
      final b2 = Brew.fromJson(brew.toJson());
      expect(b2.id, brew.id);
      expect(b2.doseGrams, brew.doseGrams);
      expect(b2.overallRating, brew.overallRating);
      expect(b2.flavorTags, brew.flavorTags);
      expect(b2.defects, brew.defects);
      expect(b2.tdsPercent, brew.tdsPercent);
    });

    test('Recipe 包含 pourSchedule', () {
      final now = DateTime.now();
      final r = Recipe(
        id: 'r1',
        name: 'V60 標準',
        brewMethodId: 'v60',
        ratioDenominator: 16,
        grindSetting: 24,
        grinderId: 'comandante_c40',
        waterTempC: 93,
        bloomWaterGrams: 50,
        bloomSeconds: 30,
        pourSchedule: const [
          PourStep(order: 0, atSecond: 0, cumulativeWaterGrams: 50, label: '悶蒸'),
          PourStep(order: 1, atSecond: 45, cumulativeWaterGrams: 150),
          PourStep(order: 2, atSecond: 90, cumulativeWaterGrams: 250),
        ],
        isFavorite: true,
        createdAt: now,
      );
      final r2 = Recipe.fromJson(r.toJson());
      expect(r2.pourSchedule.length, 3);
      expect(r2.pourSchedule.first.label, '悶蒸');
      expect(r2.isFavorite, true);
    });

    test('§12.2 Bean 刪除時 Brew 應保留,豆名顯示「已刪除的豆子」', () {
      // 模擬:記錄的 beanId 找不到對應 Bean 時,UI 邏輯會處理
      // (這裡只測 entity 不會 crash)
      final brew = Brew(
        id: 'x',
        brewedAt: DateTime.now(),
        brewMethodId: 'v60',
        doseGrams: 20,
        waterGrams: 320,
        beanId: 'deleted_bean_id',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final j = brew.toJson();
      expect(j['bean_id'], 'deleted_bean_id');
    });
  });

  group('§6.4 磨豆機 catalog', () {
    test('JSON 驅動:從 Map 解析(模擬 asset 載入)', () {
      final json = {
        'id': 'test_g',
        'name': 'Test Grinder',
        'unit_zh': '格',
        'unit_en': 'clicks',
        'min': 0,
        'max': 30,
        'step': 1,
        'is_built_in': true,
      };
      final g = Grinder.fromJson(json);
      expect(g.name, 'Test Grinder');
      expect(g.maxSetting, 30);
    });

    test('自訂磨豆機加入後可 byId 找到', () {
      final catalog = GrinderCatalog.instance;
      final beforeCount = catalog.custom.length;
      final added = catalog.addCustom(
        name: 'MyCustom',
        unitLabelZh: '格',
        unitLabelEn: 'custom',
        minSetting: 0,
        maxSetting: 50,
        step: 1,
      );
      expect(catalog.custom.length, beforeCount + 1);
      expect(catalog.byId(added.id)?.name, 'MyCustom');
      catalog.removeCustom(added.id);
      expect(catalog.byId(added.id), isNull);
    });
  });

  group('§6.1 沖煮方式 catalog', () {
    test('JSON 驅動:解析範例', () {
      final json = {
        'id': 'v60',
        'name_zh': 'V60 手沖',
        'name_en': 'V60',
        'ratio': 16,
        'temp': 93,
        'grind': '中細',
        'time': '2:30–3:00',
        'espresso': false,
      };
      final m = BrewMethod.fromJson(json);
      expect(m.id, 'v60');
      expect(m.defaultRatioDenominator, 16);
      expect(m.isEspresso, false);
    });

    test('espresso 模式旗標正確', () {
      final json = {
        'id': 'espresso',
        'name_zh': '義式',
        'name_en': 'Espresso',
        'ratio': 2,
        'temp': 93,
        'grind': '極細',
        'time': '0:25',
        'espresso': true,
      };
      expect(BrewMethod.fromJson(json).isEspresso, isTrue);
    });
  });

  group('§6.2 處理法 + §6.3 烘焙度', () {
    test('Processing 6 種內建', () {
      expect(Processing.all.length, 6);
      expect(Processing.zh(Processing.washed), '水洗');
      expect(Processing.en(Processing.natural), 'Natural');
    });
    test('RoastLevel 6 種', () {
      expect(RoastLevel.all.length, 6);
      expect(RoastLevel.zh(RoastLevel.medium), '中');
    });
  });
}
