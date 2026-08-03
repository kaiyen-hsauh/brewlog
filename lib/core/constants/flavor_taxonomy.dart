// §6.5 自有風味分類法
// MUST:不可抄 SCA 風味輪結構、配色、圖形。
// 詞彙為通用名詞,不受著作權保護,但視覺必須原創。
class FlavorTaxonomy {
  FlavorTaxonomy._();

  /// 第一層 8 大類
  static const List<FlavorCategory> categories = [
    FlavorCategory(
      id: 'fruity',
      zh: '果香',
      en: 'Fruity',
      children: [
        FlavorItem(id: 'citrus', zh: '柑橘', en: 'Citrus'),
        FlavorItem(id: 'berry', zh: '莓果', en: 'Berry'),
        FlavorItem(id: 'stone_fruit', zh: '核果', en: 'Stone Fruit'),
        FlavorItem(id: 'tropical', zh: '熱帶水果', en: 'Tropical'),
        FlavorItem(id: 'apple_pear', zh: '蘋果梨', en: 'Apple/Pear'),
        FlavorItem(id: 'grape', zh: '葡萄', en: 'Grape'),
      ],
    ),
    FlavorCategory(
      id: 'floral',
      zh: '花香',
      en: 'Floral',
      children: [
        FlavorItem(id: 'jasmine', zh: '茉莉', en: 'Jasmine'),
        FlavorItem(id: 'rose', zh: '玫瑰', en: 'Rose'),
        FlavorItem(id: 'chamomile', zh: '洋甘菊', en: 'Chamomile'),
        FlavorItem(id: 'osmanthus', zh: '桂花', en: 'Osmanthus'),
      ],
    ),
    FlavorCategory(
      id: 'sweet',
      zh: '甜味',
      en: 'Sweet',
      children: [
        FlavorItem(id: 'honey', zh: '蜂蜜', en: 'Honey'),
        FlavorItem(id: 'caramel', zh: '焦糖', en: 'Caramel'),
        FlavorItem(id: 'brown_sugar', zh: '紅糖', en: 'Brown Sugar'),
        FlavorItem(id: 'vanilla', zh: '香草', en: 'Vanilla'),
        FlavorItem(id: 'maple', zh: '楓糖', en: 'Maple'),
      ],
    ),
    FlavorCategory(
      id: 'nutty_cocoa',
      zh: '堅果可可',
      en: 'Nutty/Cocoa',
      children: [
        FlavorItem(id: 'almond', zh: '杏仁', en: 'Almond'),
        FlavorItem(id: 'hazelnut', zh: '榛果', en: 'Hazelnut'),
        FlavorItem(id: 'peanut', zh: '花生', en: 'Peanut'),
        FlavorItem(id: 'milk_chocolate', zh: '牛奶巧克力', en: 'Milk Chocolate'),
        FlavorItem(id: 'dark_chocolate', zh: '黑巧克力', en: 'Dark Chocolate'),
      ],
    ),
    FlavorCategory(
      id: 'spice',
      zh: '辛香',
      en: 'Spice',
      children: [
        FlavorItem(id: 'cinnamon', zh: '肉桂', en: 'Cinnamon'),
        FlavorItem(id: 'clove', zh: '丁香', en: 'Clove'),
        FlavorItem(id: 'pepper', zh: '胡椒', en: 'Pepper'),
        FlavorItem(id: 'anise', zh: '八角', en: 'Anise'),
      ],
    ),
    FlavorCategory(
      id: 'roasted',
      zh: '烘焙',
      en: 'Roasted',
      children: [
        FlavorItem(id: 'toast', zh: '烤麵包', en: 'Toast'),
        FlavorItem(id: 'smoky', zh: '煙燻', en: 'Smoky'),
        FlavorItem(id: 'burnt', zh: '焦香', en: 'Burnt'),
        FlavorItem(id: 'tobacco', zh: '菸草', en: 'Tobacco'),
      ],
    ),
    FlavorCategory(
      id: 'herbal',
      zh: '草本',
      en: 'Herbal',
      children: [
        FlavorItem(id: 'green_tea', zh: '綠茶', en: 'Green Tea'),
        FlavorItem(id: 'black_tea', zh: '紅茶', en: 'Black Tea'),
        FlavorItem(id: 'grassy', zh: '青草', en: 'Grassy'),
        FlavorItem(id: 'medicinal', zh: '藥草', en: 'Medicinal'),
      ],
    ),
    FlavorCategory(
      id: 'other',
      zh: '其他/負面',
      en: 'Other',
      children: [
        FlavorItem(id: 'earthy', zh: '土味', en: 'Earthy'),
        FlavorItem(id: 'papery', zh: '紙味', en: 'Papery'),
        FlavorItem(id: 'fermented', zh: '發酵', en: 'Fermented'),
        FlavorItem(id: 'astringent', zh: '澀感', en: 'Astringent'),
        FlavorItem(id: 'metallic', zh: '金屬味', en: 'Metallic'),
      ],
    ),
  ];

  /// 全部攤平供搜尋
  static List<FlavorItem> get allItems =>
      categories.expand((c) => c.children).toList(growable: false);

  static FlavorItem? byId(String id) {
    for (final c in categories) {
      for (final item in c.children) {
        if (item.id == id) return item;
      }
    }
    return null;
  }
}

class FlavorCategory {
  final String id;
  final String zh;
  final String en;
  final List<FlavorItem> children;
  const FlavorCategory({
    required this.id,
    required this.zh,
    required this.en,
    required this.children,
  });
}

class FlavorItem {
  final String id;
  final String zh;
  final String en;
  const FlavorItem({required this.id, required this.zh, required this.en});
}

// §F3.4 缺陷快選(供診斷引擎使用)
class BrewDefect {
  BrewDefect._();

  static const underExtracted = 'under_extracted'; // 萃取不足-尖酸
  static const overExtracted = 'over_extracted'; // 過萃澀感
  static const tooWeak = 'too_weak'; // 味道太淡
  static const tooStrong = 'too_strong'; // 味道太濃
  static const offFlavor = 'off_flavor'; // 雜味
  static const noDefect = 'no_defect'; // 無明顯缺陷

  static const Map<String, (String zh, String en)> all = {
    underExtracted: ('萃取不足-尖酸', 'Under-extracted'),
    overExtracted: ('過萃澀感', 'Over-extracted'),
    tooWeak: ('味道太淡', 'Too weak'),
    tooStrong: ('味道太濃', 'Too strong'),
    offFlavor: ('雜味', 'Off-flavor'),
    noDefect: ('無明顯缺陷', 'No defect'),
  };
}
