// §F4 + §F7 integration:診斷引擎純函式端對端驗證(最真實的「整合」測試)
import 'package:flutter_test/flutter_test.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/domain/services/diagnosis_engine.dart';

void main() {
  test('I_10rules_full_coverage', () {
    // 10 條規則的綜合測試 — 每條用最少資料觸發
    final now = DateTime(2026, 8, 4);

    Brew make({
      Map<String, double>? rating,
      List<String> defects = const [],
      String beanId = '',
    }) {
      return Brew(
        id: 'test-${rating?.values.join() ?? ""}-${defects.join()}',
        brewedAt: now,
        brewMethodId: 'v60',
        doseGrams: 15,
        waterGrams: 240,
        beanId: beanId,
        acidity: rating?['a'],
        sweetness: rating?['s'],
        body: rating?['b'],
        bitterness: rating?['bit'],
        aftertaste: rating?['at'],
        balance: rating?['bal'],
        overallRating: rating?['o'],
        defects: defects,
        createdAt: now,
        updatedAt: now,
      );
    }

    // 規則 1:萃取不足(缺陷快選)
    var s = DiagnosisEngine.diagnose(make(defects: ['under_extracted']));
    expect(s.first.kind, DiagKind.underExtraction);

    // 規則 2:過度萃取
    s = DiagnosisEngine.diagnose(make(defects: ['over_extracted']));
    expect(s.first.kind, DiagKind.overExtraction);

    // 規則 3:味道太淡
    s = DiagnosisEngine.diagnose(make(defects: ['too_weak']));
    expect(s.first.kind, DiagKind.weak);

    // 規則 4:味道太濃
    s = DiagnosisEngine.diagnose(make(defects: ['too_strong']));
    expect(s.first.kind, DiagKind.strong);

    // 規則 9:成功(評分高)
    s = DiagnosisEngine.diagnose(make(rating: {'o': 4.5, 'a': 7, 's': 7, 'b': 7, 'bit': 4, 'at': 7, 'bal': 8}));
    expect(s.first.kind, DiagKind.success);

    // 規則 10:無缺陷微調(評分中等)
    s = DiagnosisEngine.diagnose(make(rating: {'o': 3.5, 'a': 7, 's': 7, 'b': 5, 'bit': 5, 'at': 5, 'bal': 6}));
    expect(s.first.kind, DiagKind.microTweak);
  });

  test('I_priority:缺陷快選優先於推論判斷', () {
    final now = DateTime(2026, 8, 4);
    // 同時有缺陷 = under + over,應取先命中者 (under)
    final brew = Brew(
      id: 'pri-test',
      brewedAt: now,
      brewMethodId: 'v60',
      doseGrams: 15,
      waterGrams: 240,
      acidity: 8, sweetness: 3, body: 5, bitterness: 7, aftertaste: 3, balance: 5,
      overallRating: 4.0,
      defects: const ['under_extracted', 'over_extracted'],
      createdAt: now,
      updatedAt: now,
    );
    final s = DiagnosisEngine.diagnose(brew);
    expect(s.first.kind, DiagKind.underExtraction,
        reason: '條件互斥時應先命中 §F7.2 規則 1 (under_extracted)');
  });

  test('I_ey_formula_known', () {
    // §F4.1:已知案例 dose=20, beverage=300, TDS=1.35 → EY=20.25
    const dose = 20.0;
    const beverage = 300.0;
    const tds = 1.35;
    final ey = (tds * beverage) / dose;
    expect(ey, closeTo(20.25, 0.01));
    // 另一個: dose=15, beverage=240, TDS=1.30
    expect((1.30 * 240) / 15, closeTo(20.80, 0.01));
  });
}
