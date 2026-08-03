// S7 stub:訂閱狀態 + Freemium 限制
// S7 會接入 in_app_purchase;此檔 S6 即可用
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:brewlog/data/datasources/local/hive_setup.dart';

/// §11.1 Freemium 限制
class Limits {
  static const maxBrewsFree = 30;
  static const maxRecipesFree = 3;
  static const maxBeansFree = 5;
  static const maxDiagnosisPerWeekFree = 3;
}

class SubscriptionNotifier extends Notifier<bool> {
  @override
  bool build() {
    final box = Hive.box(HiveBoxes.settings);
    return box.get('is_pro', defaultValue: false) as bool;
  }

  void setPro(bool v) {
    Hive.box(HiveBoxes.settings).put('is_pro', v);
    state = v;
  }

  void restore() {
    final box = Hive.box(HiveBoxes.settings);
    state = (box.get('is_pro', defaultValue: false) as bool);
  }
}

final subscriptionProvider =
    NotifierProvider<SubscriptionNotifier, bool>(SubscriptionNotifier.new);

/// §11.3 Freemium 限制檢查(回傳 null 表示通過,否則回傳原因 key)
class LimitReason {
  static const brews = 'brews';
  static const recipes = 'recipes';
  static const beans = 'beans';
  static const diagnosis = 'diagnosis';
}

class FreemiumGuard {
  FreemiumGuard._();
  static String? canAddBrew(bool isPro, int currentCount) {
    if (isPro) return null;
    if (currentCount >= Limits.maxBrewsFree) return LimitReason.brews;
    return null;
  }

  static String? canAddRecipe(bool isPro, int currentCount) {
    if (isPro) return null;
    if (currentCount >= Limits.maxRecipesFree) return LimitReason.recipes;
    return null;
  }

  static String? canAddBean(bool isPro, int currentCount) {
    if (isPro) return null;
    if (currentCount >= Limits.maxBeansFree) return LimitReason.beans;
    return null;
  }

  /// 每週診斷次數限制(§11.1)
  static String? canRunDiagnosis(bool isPro) {
    if (isPro) return null;
    final box = Hive.box(HiveBoxes.settings);
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final wsKey =
        '${weekStart.year}-${weekStart.month.toString().padLeft(2, '0')}-${weekStart.day.toString().padLeft(2, '0')}';
    final countKey = 'diag_count_$wsKey';
    final count = (box.get(countKey, defaultValue: 0) as int);
    if (count >= Limits.maxDiagnosisPerWeekFree) {
      return LimitReason.diagnosis;
    }
    return null;
  }

  /// 診斷後 +1
  static void recordDiagnosis() {
    final box = Hive.box(HiveBoxes.settings);
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final wsKey =
        '${weekStart.year}-${weekStart.month.toString().padLeft(2, '0')}-${weekStart.day.toString().padLeft(2, '0')}';
    final countKey = 'diag_count_$wsKey';
    final count = (box.get(countKey, defaultValue: 0) as int);
    box.put(countKey, count + 1);
  }
}

/// 萃取控制圖 Pro 解鎖(§11.1):TDS >= 6 為 espresso,否則 filter
class BrewControlChartScope {
  static bool isEspresso(String methodId) => methodId == 'espresso';

  /// 取得指定沖煮方式的參考區間
  static ({double minX, double maxX, double minY, double maxY}) referenceZone(
          String methodId) =>
      isEspresso(methodId)
          ? (minX: 14, maxX: 26, minY: 6.0, maxY: 14.0)
          : (minX: 14, maxX: 26, minY: 0.8, maxY: 1.8);
}
