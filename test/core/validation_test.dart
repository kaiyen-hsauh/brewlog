// §12.1 數值範圍驗證
// §13 計算測試:粉水比 + 萃取率
import 'package:flutter_test/flutter_test.dart';
import 'package:brewlog/core/utils/validators.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/core/constants/grinders.dart' as g;

Brew _brew({
  double dose = 20,
  double water = 300,
  double? temp = 93,
  double? tds = 1.35,
  double? beverage = 300,
  double? grind = 24,
  String? grinderId = 'comandante_c40',
  int? totalSeconds = 180,
  double? acidity,
  double? overall,
}) {
  final now = DateTime.now();
  return Brew(
    id: 't',
    brewedAt: now,
    brewMethodId: 'v60',
    doseGrams: dose,
    waterGrams: water,
    grindSetting: grind,
    grinderId: grinderId,
    waterTempC: temp,
    tdsPercent: tds,
    beverageMassGrams: beverage,
    totalBrewSeconds: totalSeconds,
    acidity: acidity,
    overallRating: overall,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  group('粉水比與萃取率', () {
    test('§F4.1 已知案例 dose=20, beverage=300, TDS=1.35 → EY=20.25', () {
      final b = _brew(dose: 20, water: 320, beverage: 300, tds: 1.35);
      final ey = b.extractionYield!;
      expect(ey.eyPercent, closeTo(20.25, 0.01));
      expect(ey.isEstimatedMass, isFalse);
    });

    test('§F4.1 未填液重 → 估算,且標示 isEstimatedMass=true', () {
      // 估算 ≈ water − dose*2
      final b = _brew(dose: 20, water: 300, beverage: null, tds: 1.35);
      final ey = b.extractionYield!;
      expect(ey.isEstimatedMass, isTrue);
      // (1.35 × 260) / 20 = 17.55
      expect(ey.eyPercent, closeTo(17.55, 0.01));
    });

    test('§12.1 邊界:dose=0 → ratio=「—」,extractionYield=null', () {
      final b = _brew(dose: 0, water: 300);
      expect(b.ratioDisplay, '—');
      expect(b.extractionYield, isNull);
    });

    test('§F4.1 未填 TDS → extractionYield=null,UI 顯示「需輸入 TDS」', () {
      final b = _brew(tds: null);
      expect(b.extractionYield, isNull);
    });

    test('粉水比顯示為 1:XX.X', () {
      final b = _brew(dose: 18, water: 288);
      expect(b.ratioDisplay, '1:16.0');
    });
  });

  group('§12.1 數值範圍驗證', () {
    test('合法值通過', () {
      expect(BrewValidator.validateBrew(_brew()), isEmpty);
    });

    test('粉重 0 → 阻擋', () {
      final errs = BrewValidator.validateBrew(_brew(dose: 0));
      expect(errs.any((e) => e.field == 'doseGrams'), isTrue);
    });

    test('粉重 0.05 (小於 0.1 下限) → 阻擋', () {
      final errs = BrewValidator.validateBrew(_brew(dose: 0.05));
      expect(errs.any((e) => e.field == 'doseGrams'), isTrue);
    });

    test('粉重 501 (大於 500 上限) → 阻擋', () {
      final errs = BrewValidator.validateBrew(_brew(dose: 501));
      expect(errs.any((e) => e.field == 'doseGrams'), isTrue);
    });

    test('水溫 39 (低於 40 下限) → 阻擋', () {
      final errs = BrewValidator.validateBrew(_brew(temp: 39));
      expect(errs.any((e) => e.field == 'waterTempC'), isTrue);
    });

    test('水溫 101 (高於 100 上限) → 阻擋', () {
      final errs = BrewValidator.validateBrew(_brew(temp: 101));
      expect(errs.any((e) => e.field == 'waterTempC'), isTrue);
    });

    test('研磨超出磨豆機範圍 → 阻擋', () {
      // 預先註冊 Comandante C40
      g.GrinderCatalog.instance.addCustom(
        name: 'Comandante C40', unitLabelZh: '格', unitLabelEn: 'clicks',
        minSetting: 0, maxSetting: 40, step: 1,
      );
      // Commander 上限 40,50 應擋
      final added = g.GrinderCatalog.instance.custom.last;
      final errs = BrewValidator.validateBrew(_brew(grind: 50, grinderId: added.id));
      expect(errs.any((e) => e.field == 'grindSetting'), isTrue);
    });

    test('TDS 超出範圍 → 阻擋', () {
      final errs = BrewValidator.validateBrew(_brew(tds: 25));
      expect(errs.any((e) => e.field == 'tdsPercent'), isTrue);
    });

    test('NaN 不可存入 → 阻擋', () {
      // 故意不寫一個無限大的
      final b = _brew(dose: double.nan);
      final errs = BrewValidator.validateBrew(b);
      expect(errs, isNotEmpty);
    });
  });

  group('§F6 養豆天數', () {
    test('3 天內:排氣旺盛', () {
      final today = DateTime.now();
      final roasted = today.subtract(const Duration(days: 2));
      final bean = Bean(
        id: 'x',
        name: 'Test',
        roastDate: roasted,
        createdAt: today,
        updatedAt: today,
      );
      expect(bean.restDays, 2);
      expect(bean.restDaysHintZh, '排氣旺盛期,風味尚未穩定');
    });

    test('10 天:適飲期', () {
      final today = DateTime.now();
      final bean = Bean(
        id: 'x',
        name: 'Test',
        roastDate: today.subtract(const Duration(days: 10)),
        createdAt: today,
        updatedAt: today,
      );
      expect(bean.restDaysHintZh, '適飲期');
    });

    test('45 天:可能衰退', () {
      final today = DateTime.now();
      final bean = Bean(
        id: 'x',
        name: 'Test',
        roastDate: today.subtract(const Duration(days: 45)),
        createdAt: today,
        updatedAt: today,
      );
      expect(bean.restDaysHintZh, '風味可能已衰退');
    });

    test('§12.2 未來日期 → 異常訊息', () {
      final today = DateTime.now();
      final bean = Bean(
        id: 'x',
        name: 'Test',
        roastDate: today.add(const Duration(days: 3)),
        createdAt: today,
        updatedAt: today,
      );
      expect(bean.restDaysHintZh, '烘焙日期異常');
    });
  });

  group('§6.4 磨豆機刻度庫', () {
    test('Comandante C40 上限 40', () {
      final cmd = g.Grinder(
        id: 'c', name: 'C40', unitLabelZh: '格', unitLabelEn: 'clicks',
        minSetting: 0, maxSetting: 40, step: 1,
      );
      expect(cmd.maxSetting, 40);
      expect(cmd.unitLabelZh, '格');
    });
    test('Fellow Ode 上限 11', () {
      final ode = g.Grinder(
        id: 'o', name: 'Ode', unitLabelZh: '刻度', unitLabelEn: 'setting',
        minSetting: 1, maxSetting: 11, step: 1,
      );
      expect(ode.maxSetting, 11);
    });
    test('byId 找不到回傳 null', () {
      expect(g.GrinderCatalog.instance.byId('nope'), isNull);
    });
  });
}
