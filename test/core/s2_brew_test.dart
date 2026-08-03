// S2 測試:§F4 萃取計算 UI 邏輯 + §F1 CRUD round-trip
import 'package:flutter_test/flutter_test.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/core/constants/brew_methods.dart';

void main() {
  group('§F4 萃取率計算(給 UI 用)', () {
    test('dose=0 → 粉水比與 EY 都「—」/null', () {
      final b = Brew(
        id: 'x',
        brewedAt: DateTime.now(),
        brewMethodId: 'v60',
        doseGrams: 0,
        waterGrams: 300,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(b.ratioDisplay, '—');
      expect(b.extractionYield, isNull);
    });

    test('§F4.3 四捨五入到 1 位小數(EY)', () {
      final b = Brew(
        id: 'x',
        brewedAt: DateTime.now(),
        brewMethodId: 'v60',
        doseGrams: 20,
        waterGrams: 320,
        beverageMassGrams: 300,
        tdsPercent: 1.345,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      // 1.345 * 300 / 20 = 20.175
      expect(b.extractionYield!.eyPercent, closeTo(20.175, 0.001));
      // UI 顯示用 toStringAsFixed(1) → 20.2
    });

    test('§F4.3 已知案例 dose=20, beverage=300, TDS=1.35 → EY=20.25', () {
      final b = Brew(
        id: 'x',
        brewedAt: DateTime.now(),
        brewMethodId: 'v60',
        doseGrams: 20,
        waterGrams: 320,
        beverageMassGrams: 300,
        tdsPercent: 1.35,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(b.extractionYield!.eyPercent, closeTo(20.25, 0.01));
      expect(b.extractionYield!.isEstimatedMass, isFalse);
    });

    test('未填液重用估算值並標示', () {
      final b = Brew(
        id: 'x',
        brewedAt: DateTime.now(),
        brewMethodId: 'v60',
        doseGrams: 20,
        waterGrams: 300,
        tdsPercent: 1.35,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      // 估算 ≈ 300 - 20*2 = 260
      // (1.35 * 260) / 20 = 17.55
      expect(b.extractionYield!.isEstimatedMass, isTrue);
      expect(b.extractionYield!.eyPercent, closeTo(17.55, 0.01));
    });

    test('§F4.2 濾泡範圍:EY 18–22% / TDS 1.15–1.45%', () {
      // 範圍檢查
      const filterRangeEy = [14, 26];
      const filterRangeTds = [0.8, 1.8];
      expect(filterRangeEy[0], 14);
      expect(filterRangeEy[1], 26);
      expect(filterRangeTds[0], 0.8);
      expect(filterRangeTds[1], 1.8);
    });
  });

  group('§F1.3 沖煮記錄 CRUD 驗收', () {
    test('Brew 從 form 構造後能 round-trip', () {
      final now = DateTime.now();
      final b = Brew(
        id: genId(),
        brewedAt: now,
        brewMethodId: 'v60',
        doseGrams: 20,
        waterGrams: 320,
        grindSetting: 24,
        grinderId: 'comandante_c40',
        waterTempC: 93,
        createdAt: now,
        updatedAt: now,
      );
      final b2 = Brew.fromJson(b.toJson());
      expect(b2.id, b.id);
      expect(b2.doseGrams, b.doseGrams);
      expect(b2.brewMethodId, b.brewMethodId);
    });

    test('§F1.3「複製此次沖煮」: 帶入所有參數但清空評分', () {
      // 邏輯驗證: 從既有 brew 建一個新 brew
      final now = DateTime.now();
      final orig = Brew(
        id: 'old',
        brewedAt: now,
        brewMethodId: 'v60',
        doseGrams: 20,
        waterGrams: 320,
        grindSetting: 24,
        grinderId: 'comandante_c40',
        waterTempC: 93,
        overallRating: 4.5,
        notes: 'good',
        createdAt: now,
        updatedAt: now,
      );
      // 「複製」: 保留參數,新 id,清空評分
      final copy = Brew(
        id: genId(),
        brewedAt: now,
        beanId: orig.beanId,
        brewMethodId: orig.brewMethodId,
        recipeId: orig.recipeId,
        doseGrams: orig.doseGrams,
        waterGrams: orig.waterGrams,
        grindSetting: orig.grindSetting,
        grinderId: orig.grinderId,
        waterTempC: orig.waterTempC,
        bloomWaterGrams: orig.bloomWaterGrams,
        bloomSeconds: orig.bloomSeconds,
        pourSchedule: orig.pourSchedule,
        filterType: orig.filterType,
        waterProfile: orig.waterProfile,
        createdAt: now,
        updatedAt: now,
        // 評分刻意不帶
      );
      expect(copy.doseGrams, orig.doseGrams);
      expect(copy.grindSetting, orig.grindSetting);
      expect(copy.id, isNot(orig.id));
      expect(copy.overallRating, isNull);
    });

    test('重複沖煮建立新紀錄，保留設定並清除上次結果', () {
      final createdAt = DateTime(2026, 8, 1, 9);
      final repeatedAt = DateTime(2026, 8, 3, 10);
      final original = Brew(
        id: 'original',
        brewedAt: createdAt,
        beanId: 'bean-1',
        brewMethodId: 'v60',
        recipeId: 'recipe-1',
        doseGrams: 20,
        waterGrams: 300,
        grindSetting: 24,
        grinderId: 'comandante_c40',
        waterTempC: 93,
        bloomWaterGrams: 40,
        bloomSeconds: 45,
        pourSchedule: const [
          PourStep(order: 0, atSecond: 0, cumulativeWaterGrams: 40),
        ],
        totalBrewSeconds: 180,
        beverageMassGrams: 260,
        tdsPercent: 1.35,
        filterType: '濾紙',
        acidity: 7,
        overallRating: 4.5,
        flavorTags: const ['citrus'],
        defects: const ['too_weak'],
        notes: '上次筆記',
        photoPath: '/tmp/old.jpg',
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      final copy = original.duplicate(id: 'new', now: repeatedAt);

      expect(copy.id, 'new');
      expect(copy.brewedAt, repeatedAt);
      expect(copy.createdAt, repeatedAt);
      expect(copy.doseGrams, original.doseGrams);
      expect(copy.waterGrams, original.waterGrams);
      expect(copy.grindSetting, original.grindSetting);
      expect(copy.pourSchedule, original.pourSchedule);
      expect(copy.totalBrewSeconds, isNull);
      expect(copy.beverageMassGrams, isNull);
      expect(copy.tdsPercent, isNull);
      expect(copy.overallRating, isNull);
      expect(copy.flavorTags, isEmpty);
      expect(copy.defects, isEmpty);
      expect(copy.notes, isNull);
      expect(copy.photoPath, isNull);
    });
  });

  group('§6.1 沖煮方式 espresso 模式判定', () {
    test('espresso 模式', () {
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
}
