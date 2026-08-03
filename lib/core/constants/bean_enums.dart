// §6.2 處理法 Processing
class Processing {
  Processing._();
  static const washed = 'washed';
  static const natural = 'natural';
  static const honey = 'honey';
  static const anaerobic = 'anaerobic';
  static const wetHulled = 'wet_hulled';
  static const other = 'other';

  static const Map<String, (String zh, String en)> all = {
    washed: ('水洗', 'Washed'),
    natural: ('日曬', 'Natural'),
    honey: ('蜜處理', 'Honey'),
    anaerobic: ('厭氧發酵', 'Anaerobic'),
    wetHulled: ('濕刨', 'Wet-hulled'),
    other: ('其他', 'Other'),
  };

  static String zh(String key) => all[key]?.$1 ?? key;
  static String en(String key) => all[key]?.$2 ?? key;
}

// §6.3 烘焙度 Roast Level
class RoastLevel {
  RoastLevel._();
  static const lightPlus = 'light_plus'; // 極淺
  static const light = 'light';
  static const mediumLight = 'medium_light';
  static const medium = 'medium';
  static const mediumDark = 'medium_dark';
  static const dark = 'dark';

  static const Map<String, (String zh, String en)> all = {
    lightPlus: ('極淺', 'Light+'),
    light: ('淺', 'Light'),
    mediumLight: ('中淺', 'Medium-Light'),
    medium: ('中', 'Medium'),
    mediumDark: ('中深', 'Medium-Dark'),
    dark: ('深', 'Dark'),
  };

  static String zh(String key) => all[key]?.$1 ?? key;
  static String en(String key) => all[key]?.$2 ?? key;
}
