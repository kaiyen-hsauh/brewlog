// §12.1 數值範圍驗證 — 純函式,MUST
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/core/constants/grinders.dart';

class ValidationError {
  final String field;
  final String message;
  const ValidationError(this.field, this.message);
  @override
  String toString() => 'ValidationError($field: $message)';
}

class BrewValidator {
  BrewValidator._();

  /// §12.1 MUST:寫入前驗證,不可存入 NaN/Infinity
  static bool isFinitePositive(num? v) =>
      v != null && !v.isNaN && !v.isInfinite;

  static List<ValidationError> validateBrew(Brew b) {
    final errs = <ValidationError>[];

    if (!isFinitePositive(b.doseGrams) || b.doseGrams < 0.1 || b.doseGrams > 500) {
      errs.add(const ValidationError('doseGrams', '粉重需介於 0.1–500g'));
    }
    if (!isFinitePositive(b.waterGrams) || b.waterGrams < 1 || b.waterGrams > 5000) {
      errs.add(const ValidationError('waterGrams', '水量需介於 1–5000g'));
    }
    if (b.waterTempC != null &&
        (b.waterTempC! < 40 || b.waterTempC! > 100)) {
      errs.add(const ValidationError('waterTempC', '水溫需介於 40–100°C'));
    }
    if (b.tdsPercent != null &&
        (b.tdsPercent! < 0.01 || b.tdsPercent! > 20)) {
      errs.add(const ValidationError('tdsPercent', 'TDS 需介於 0.01–20%'));
    }
    if (b.totalBrewSeconds != null &&
        (b.totalBrewSeconds! < 1 || b.totalBrewSeconds! > 86400)) {
      errs.add(const ValidationError(
        'totalBrewSeconds',
        '總沖煮時間需介於 1–86400 秒',
      ));
    }
    // 研磨刻度依磨豆機範圍
    if (b.grindSetting != null && b.grinderId != null) {
      final g = GrinderCatalog.instance.byId(b.grinderId);
      if (g != null &&
          (b.grindSetting! < g.minSetting || b.grindSetting! > g.maxSetting)) {
        errs.add(ValidationError(
          'grindSetting',
          '研磨需介於 ${g.minSetting}–${g.maxSetting} ${g.unitLabelZh}',
        ));
      }
    }
    // 評分範圍(UI 限制即可,這裡保險)
    for (final e in [
      MapEntry('acidity', b.acidity),
      MapEntry('sweetness', b.sweetness),
      MapEntry('body', b.body),
      MapEntry('bitterness', b.bitterness),
      MapEntry('aftertaste', b.aftertaste),
      MapEntry('balance', b.balance),
    ]) {
      if (e.value != null && (e.value! < 1 || e.value! > 10)) {
        errs.add(ValidationError(e.key, '${e.key} 需介於 1–10'));
      }
    }
    if (b.overallRating != null &&
        (b.overallRating! < 0.5 || b.overallRating! > 5)) {
      errs.add(const ValidationError('overallRating', '總體評分需介於 0.5–5'));
    }
    return errs;
  }
}
