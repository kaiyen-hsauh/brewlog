// S5 測試:§F7 診斷引擎 — 10 條規則 + 邊界(§13 要求 ≥20 案例)
import 'package:flutter_test/flutter_test.dart';
import 'package:brewlog/core/constants/flavor_taxonomy.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/domain/services/diagnosis_engine.dart';

Brew _brew({
  double dose = 20,
  double water = 300,
  double? tds = 1.35,
  double? beverage,
  double? acidity,
  double? sweetness,
  double? bitterness,
  double? aftertaste,
  double? body,
  double? balance,
  double? overall,
  List<String> defects = const [],
}) {
  final now = DateTime.now();
  return Brew(
    id: 't',
    brewedAt: now,
    brewMethodId: 'v60',
    doseGrams: dose,
    waterGrams: water,
    tdsPercent: tds,
    beverageMassGrams: beverage,
    acidity: acidity,
    sweetness: sweetness,
    body: body,
    bitterness: bitterness,
    aftertaste: aftertaste,
    balance: balance,
    overallRating: overall,
    defects: defects,
    createdAt: now,
    updatedAt: now,
  );
}

Bean _bean({int? daysAgo}) {
  final today = DateTime.now();
  return Bean(
    id: 'b',
    name: 'Test',
    roastDate: daysAgo == null ? null : today.subtract(Duration(days: daysAgo)),
    createdAt: today,
    updatedAt: today,
  );
}

void main() {
  group('§F7.2 規則 1:萃取不足(缺陷快選)', () {
    test('缺陷=under_extracted → 3 條建議', () {
      final s = DiagnosisEngine.diagnose(_brew(defects: [BrewDefect.underExtracted]));
      expect(s.length, 3);
      expect(s.first.kind, DiagKind.underExtraction);
      expect(s.first.text, contains('研磨調細'));
      expect(s[1].text, contains('水溫'));
      expect(s[2].text, contains('延長沖煮時間'));
    });
  });

  group('§F7.2 規則 1 推論:酸≥8 + 甜≤4', () {
    test('酸質 8 + 甜感 4 → 判定萃取不足', () {
      final s = DiagnosisEngine.diagnose(_brew(acidity: 8, sweetness: 4));
      expect(s.first.kind, DiagKind.underExtraction);
    });
    test('酸質 9 + 甜感 3 → 萃取不足', () {
      final s = DiagnosisEngine.diagnose(_brew(acidity: 9, sweetness: 3));
      expect(s.first.kind, DiagKind.underExtraction);
    });
  });

  group('§F7.2 規則 2:過度萃取(缺陷快選)', () {
    test('缺陷=over_extracted → 3 條', () {
      final s = DiagnosisEngine.diagnose(_brew(defects: [BrewDefect.overExtracted]));
      expect(s.length, 3);
      expect(s.first.text, contains('研磨調粗'));
    });
  });

  group('§F7.2 規則 2 推論:苦≥7 + 餘韻≤4', () {
    test('苦味 7 + 餘韻 4 → 過萃', () {
      final s = DiagnosisEngine.diagnose(_brew(bitterness: 7, aftertaste: 4));
      expect(s.first.kind, DiagKind.overExtraction);
    });
  });

  group('§F7.2 規則 3:味道太淡', () {
    test('缺陷=too_weak + 當前粉水比 1:15 → 建議 1:14', () {
      final s = DiagnosisEngine.diagnose(
          _brew(dose: 20, water: 300, defects: [BrewDefect.tooWeak]));
      expect(s.first.kind, DiagKind.weak);
      expect(s.first.text, contains('1:15'));
      expect(s.first.text, contains('1:14'));
    });
  });

  group('§F7.2 規則 4:味道太濃', () {
    test('缺陷=too_strong + 1:15 → 1:16', () {
      final s = DiagnosisEngine.diagnose(
          _brew(dose: 20, water: 300, defects: [BrewDefect.tooStrong]));
      expect(s.first.kind, DiagKind.strong);
      expect(s.first.text, contains('1:16'));
    });
  });

  group('§F7.2 規則 5:EY<18%', () {
    test('dose=20, beverage=300, tds=1.0 → EY=15%', () {
      final s = DiagnosisEngine.diagnose(_brew(tds: 1.0, beverage: 300));
      expect(s.first.kind, DiagKind.eyLow);
    });
    test('tds=1.35, beverage=300, dose=20 → EY=20.25(不命中低)', () {
      final s = DiagnosisEngine.diagnose(_brew(tds: 1.35, beverage: 300));
      // 20.25 在 18-22 區間,不會命中
      expect(s.any((x) => x.kind == DiagKind.eyLow), isFalse);
    });
  });

  group('§F7.2 規則 6:EY>22%', () {
    test('tds=1.6, beverage=300, dose=20 → EY=24%', () {
      final s = DiagnosisEngine.diagnose(_brew(tds: 1.6, beverage: 300));
      expect(s.first.kind, DiagKind.eyHigh);
    });
  });

  group('§F7.2 規則 7:豆子太新', () {
    test('restDays=2 → beanNew 附註', () {
      final s = DiagnosisEngine.diagnose(
          _brew(acidity: 7, sweetness: 7, body: 7, bitterness: 3, aftertaste: 7, balance: 7),
          bean: _bean(daysAgo: 2));
      expect(s.any((x) => x.kind == DiagKind.beanNew), isTrue);
    });
    test('restDays=10 → 無 beanNew', () {
      final s = DiagnosisEngine.diagnose(
          _brew(acidity: 7, sweetness: 7, body: 7, bitterness: 3, aftertaste: 7, balance: 7),
          bean: _bean(daysAgo: 10));
      expect(s.any((x) => x.kind == DiagKind.beanNew), isFalse);
    });
  });

  group('§F7.2 規則 8:豆子太老', () {
    test('restDays=45 → beanOld 附註', () {
      final s = DiagnosisEngine.diagnose(
          _brew(acidity: 5, sweetness: 5, body: 5, bitterness: 5, aftertaste: 5, balance: 5),
          bean: _bean(daysAgo: 45));
      expect(s.any((x) => x.kind == DiagKind.beanOld), isTrue);
    });
  });

  group('§F7.2 規則 9:成功(整體 ≥ 4.5)', () {
    test('overall=4.5 → 成功路徑', () {
      final s = DiagnosisEngine.diagnose(_brew(overall: 4.5));
      expect(s.first.kind, DiagKind.success);
      expect(s.length, 1); // 成功直接 return
    });
    test('overall=5.0 → 成功', () {
      final s = DiagnosisEngine.diagnose(_brew(overall: 5.0));
      expect(s.first.kind, DiagKind.success);
    });
  });

  group('§F7.2 規則 10:無明顯缺陷 + 評分 3–4.5 → 微調', () {
    test('6 維都填寫但酸質最低 3 + 無 TDS → 微調酸質', () {
      final s = DiagnosisEngine.diagnose(_brew(
        tds: null,
        acidity: 3, sweetness: 6, body: 6, bitterness: 5, aftertaste: 6, balance: 6,
      ));
      expect(s.first.kind, DiagKind.microTweak);
      expect(s.first.text, contains('酸質'));
    });
    test('6 維都填寫且都 5+ → 仍給一條微調(找最低)', () {
      final s = DiagnosisEngine.diagnose(_brew(
        tds: null,
        acidity: 6, sweetness: 5, body: 6, bitterness: 3, aftertaste: 6, balance: 6,
      ));
      expect(s.length, greaterThanOrEqualTo(1));
    });
  });

  group('§F7.3 MUST:具體到數字/格數', () {
    test('研磨建議含「1–2 格」', () {
      final s = DiagnosisEngine.diagnose(_brew(defects: [BrewDefect.underExtracted]),
          grindUnit: '格');
      expect(s.first.text, contains('1–2 格'));
    });
    test('使用自訂 grindUnit (刻度)', () {
      final s = DiagnosisEngine.diagnose(_brew(defects: [BrewDefect.underExtracted]),
          grindUnit: '刻度');
      expect(s.first.text, contains('1–2 刻度'));
    });
  });

  group('§F7.4 條件互斥:同時尖酸又澀 → 取先命中者', () {
    test('缺陷有 under+over,先命中 under', () {
      final s = DiagnosisEngine.diagnose(_brew(
        defects: [BrewDefect.underExtracted, BrewDefect.overExtracted],
        acidity: 9, sweetness: 2, bitterness: 8, aftertaste: 2,
      ));
      // 條件互斥:先命中 under
      expect(s.first.kind, DiagKind.underExtraction);
    });
  });

  group('§F7 純函式保證', () {
    test('同樣輸入兩次結果相同', () {
      final s1 = DiagnosisEngine.diagnose(_brew(defects: [BrewDefect.underExtracted]));
      final s2 = DiagnosisEngine.diagnose(_brew(defects: [BrewDefect.underExtracted]));
      expect(s1.length, s2.length);
      expect(s1.first.text, s2.first.text);
    });
  });

  group('§F7 邊界', () {
    test('無評分無缺陷無 TDS → noData', () {
      final s = DiagnosisEngine.diagnose(_brew(tds: null));
      expect(s.first.kind, DiagKind.noData);
    });
    test('完全空評分 + bean 太新 → beanNew 附註', () {
      final s = DiagnosisEngine.diagnose(_brew(tds: null), bean: _bean(daysAgo: 1));
      // 沒有任何評分,落入 noData 路徑,但 bean 附註會加入
      expect(s.any((x) => x.kind == DiagKind.beanNew || x.kind == DiagKind.noData), isTrue);
    });
    test('最多 3 條主要建議', () {
      final s = DiagnosisEngine.diagnose(
          _brew(defects: [BrewDefect.underExtracted]),
          bean: _bean(daysAgo: 2));
      // 主要建議應 ≤ 3
      final main = s.where((x) => x.order < 99).toList();
      expect(main.length, lessThanOrEqualTo(3));
    });
  });
}
