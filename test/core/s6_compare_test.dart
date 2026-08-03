// S6 測試:F5 配方庫 round-trip + F9 比對差異邏輯 + F4.2 萃取控制圖範圍
import 'package:flutter_test/flutter_test.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/application/providers/subscription.dart';

void main() {
  group('§F5 配方 round-trip', () {
    test('Recipe 包含 PourStep 完整 round-trip', () {
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
        pourSchedule: [
          PourStep(order: 0, atSecond: 0, cumulativeWaterGrams: 50, label: '悶蒸'),
          PourStep(order: 1, atSecond: 45, cumulativeWaterGrams: 150),
          PourStep(order: 2, atSecond: 90, cumulativeWaterGrams: 250),
        ],
        isFavorite: true,
        createdAt: now,
      );
      final r2 = Recipe.fromJson(r.toJson());
      expect(r2.pourSchedule.length, 3);
      expect(r2.pourSchedule[0].label, '悶蒸');
      expect(r2.pourSchedule[1].cumulativeWaterGrams, 150);
      expect(r2.isFavorite, true);
    });
  });

  group('§11.1 Freemium 限制(純函式,不需要 Hive)', () {
    test('免費版 brews 30 筆上限', () {
      expect(Limits.maxBrewsFree, 30);
      expect(Limits.maxRecipesFree, 3);
      expect(Limits.maxBeansFree, 5);
      expect(Limits.maxDiagnosisPerWeekFree, 3);
    });
  });

  group('§F4.2 萃取控制圖參考區間', () {
    test('濾泡模式:EY 14-26 / TDS 0.8-1.8', () {
      final z = BrewControlChartScope.referenceZone('v60');
      expect(z.minX, 14);
      expect(z.maxX, 26);
      expect(z.minY, 0.8);
      expect(z.maxY, 1.8);
    });
    test('espresso 模式:TDS 6-14', () {
      final z = BrewControlChartScope.referenceZone('espresso');
      expect(z.minY, 6);
      expect(z.maxY, 14);
    });
    test('isEspresso 判定', () {
      expect(BrewControlChartScope.isEspresso('espresso'), isTrue);
      expect(BrewControlChartScope.isEspresso('v60'), isFalse);
    });
  });

  group('§F9 兩筆比對邏輯', () {
    test('差異:不同粉水比', () {
      final a = _brew(dose: 20, water: 300, overall: 4.0); // 1:15.0
      final b = _brew(dose: 20, water: 340, overall: 4.2); // 1:17.0
      expect(a.ratioDisplay, '1:15.0');
      expect(b.ratioDisplay, '1:17.0');
      expect(a.ratioDisplay == b.ratioDisplay, isFalse);
    });
    test('相同:粉水比一樣', () {
      final a = _brew(dose: 20, water: 300);
      final b = _brew(dose: 20, water: 300);
      expect(a.ratioDisplay == b.ratioDisplay, isTrue);
    });
  });
}

Brew _brew({double dose = 20, double water = 320, double? overall}) {
  final now = DateTime.now();
  return Brew(
    id: genId(),
    brewedAt: now,
    brewMethodId: 'v60',
    doseGrams: dose,
    waterGrams: water,
    overallRating: overall,
    createdAt: now,
    updatedAt: now,
  );
}
