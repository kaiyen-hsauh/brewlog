// S5:F7 診斷引擎 — 純函式,§8.1 MUST 可完整單元測試
// §F7.1 輸入:本次沖煮 + 評分 + 缺陷 → 輸出:1–3 條具體可執行建議
// §F7.2 規則表(共 10 條)
// §F7.3 每條建議具體到數字/格數;一次只改一個變數
import 'package:brewlog/core/constants/flavor_taxonomy.dart';
import 'package:brewlog/domain/entities/entities.dart';

enum DiagKind { underExtraction, overExtraction, weak, strong, eyLow, eyHigh, beanNew, beanOld, success, microTweak, noData }

class Suggestion {
  final DiagKind kind;
  final String text; // 給使用者看
  final String? unit; // "格" / "°C" / "秒"
  final int order; // 1, 2, 3
  final bool isPrimary; // 第一條(primary),其他 secondary
  const Suggestion({
    required this.kind,
    required this.text,
    required this.order,
    this.unit,
    this.isPrimary = false,
  });
}

class DiagnosisEngine {
  DiagnosisEngine._();

  /// 入口:§F7.1
  /// MUST 是純函式,只依賴輸入
  static List<Suggestion> diagnose(
    Brew brew, {
    Bean? bean,
    String grindUnit = '格',
  }) {
    final out = <Suggestion>[];

    // 1. 成功路徑
    if ((brew.overallRating ?? 0) >= 4.5) {
      out.add(const Suggestion(
        kind: DiagKind.success,
        text: '這杯很成功,建議存成配方',
        order: 1,
        isPrimary: true,
      ));
      return out;
    }

    // 2. 缺陷優先
    if (brew.defects.contains(BrewDefect.underExtracted) ||
        ((brew.acidity ?? 0) >= 8 && (brew.sweetness ?? 10) <= 4)) {
      _add(out, DiagKind.underExtraction, '研磨調細 1–2 $grindUnit', unit: grindUnit, primary: true);
      _add(out, DiagKind.underExtraction, '水溫提高 2°C', unit: '°C');
      _add(out, DiagKind.underExtraction, '延長沖煮時間 15–20 秒', unit: '秒');
    } else if (brew.defects.contains(BrewDefect.overExtracted) ||
        ((brew.bitterness ?? 0) >= 7 && (brew.aftertaste ?? 10) <= 4)) {
      _add(out, DiagKind.overExtraction, '研磨調粗 1–2 $grindUnit', unit: grindUnit, primary: true);
      _add(out, DiagKind.overExtraction, '水溫降低 2°C', unit: '°C');
      _add(out, DiagKind.overExtraction, '縮短沖煮時間 15–20 秒', unit: '秒');
    } else if (brew.defects.contains(BrewDefect.tooWeak)) {
      final newDenom = (brew.waterGrams / brew.doseGrams - 1).clamp(2, 30).toInt();
      _add(out, DiagKind.weak,
          '粉水比調濃:1:${(brew.waterGrams / brew.doseGrams).toStringAsFixed(0)} → 1:$newDenom',
          unit: '比', primary: true);
    } else if (brew.defects.contains(BrewDefect.tooStrong)) {
      final newDenom = (brew.waterGrams / brew.doseGrams + 1).clamp(2, 30).toInt();
      _add(out, DiagKind.strong,
          '粉水比調淡:1:${(brew.waterGrams / brew.doseGrams).toStringAsFixed(0)} → 1:$newDenom',
          unit: '比', primary: true);
    }

    // 3. EY 客觀輔助
    final ey = brew.extractionYield;
    if (ey != null && out.isEmpty) {
      if (ey.eyPercent < 18) {
        _add(out, DiagKind.eyLow,
            '萃取率偏低 (${ey.eyPercent.toStringAsFixed(1)}%),建議研磨調細或延長悶蒸',
            unit: 'EY', primary: true);
      } else if (ey.eyPercent > 22) {
        _add(out, DiagKind.eyHigh,
            '萃取率偏高 (${ey.eyPercent.toStringAsFixed(1)}%),建議研磨調粗或縮短時間',
            unit: 'EY', primary: true);
      }
    }

    // 4. 養豆天數(附加)
    if (bean != null) {
      final days = bean.restDays;
      if (days != null && days <= 3) {
        out.add(Suggestion(
          kind: DiagKind.beanNew,
          text: '豆子烘焙僅 $days 天,排氣旺盛,建議延長悶蒸或靜置 2–3 天再沖',
          order: 99,
        ));
      } else if (days != null && days > 30) {
        out.add(Suggestion(
          kind: DiagKind.beanOld,
          text: '豆子養豆 $days 天,風味可能衰退,建議提高水溫 1–2°C 或調細 1 格補足',
          order: 99,
        ));
      }
    }

    // 5. 微調(若上述都沒命中且有評分)
    // §F7.2 規則 5/6 EY 客觀輔助;微調規則在「無明顯缺陷 + 評分 3–4.5」時執行
    final hasDefectTrigger = out.any((s) =>
        s.kind == DiagKind.underExtraction ||
        s.kind == DiagKind.overExtraction ||
        s.kind == DiagKind.weak ||
        s.kind == DiagKind.strong);
    if (!hasDefectTrigger &&
        brew.acidity != null &&
        brew.sweetness != null &&
        brew.body != null &&
        brew.aftertaste != null &&
        brew.balance != null) {
      // 找最低分維度(bitterness 高分 = 負面,故不列入正向微調)
      final dims = {
        '酸質': brew.acidity!,
        '甜感': brew.sweetness!,
        '醇厚': brew.body!,
        '餘韻': brew.aftertaste!,
        '平衡': brew.balance!,
      };
      final lowest = dims.entries.reduce((a, b) => a.value < b.value ? a : b);
      if (lowest.value <= 5) {
        out.add(Suggestion(
          kind: DiagKind.microTweak,
          text: '${lowest.key}(${lowest.value.toStringAsFixed(0)})偏低,可嘗試微調研磨或注水速度',
          order: 1,
          isPrimary: true,
        ));
      }
    }

    // 6. 沒資料
    if (out.isEmpty) {
      out.add(const Suggestion(
        kind: DiagKind.noData,
        text: '資料不足以診斷,請補上風味評分或 TDS',
        order: 1,
        isPrimary: true,
      ));
    }

    return out;
  }

  static void _add(List<Suggestion> out, DiagKind k, String text,
      {String? unit, bool primary = false}) {
    if (out.any((s) => s.text == text)) return;
    out.add(Suggestion(
      kind: k,
      text: text,
      order: out.length + 1,
      unit: unit,
      isPrimary: primary && out.isEmpty,
    ));
  }
}
