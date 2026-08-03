// §8.2 Hive 本機儲存初始化
// S0:只開 box 殼;F1/F5/F6 各自 repo 實作在 S1/S2/S6 補上。
import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxes {
  HiveBoxes._();
  static const beans = 'beans';
  static const brews = 'brews';
  static const recipes = 'recipes';
  static const equipment = 'equipment';
  static const settings = 'settings';
}

class LocalStore {
  LocalStore._();

  static Future<void> init() async {
    await Hive.initFlutter();
    // 開啟所有 box(S0 範圍);後續 sprint 會補 entity adapters
    await Future.wait([
      Hive.openBox(HiveBoxes.beans),
      Hive.openBox(HiveBoxes.brews),
      Hive.openBox(HiveBoxes.recipes),
      Hive.openBox(HiveBoxes.equipment),
      Hive.openBox(HiveBoxes.settings),
    ]);
  }

  static Box get(String name) => Hive.box(name);
}
