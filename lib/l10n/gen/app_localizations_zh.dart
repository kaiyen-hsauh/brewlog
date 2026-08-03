// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'BrewLog';

  @override
  String get tabBrew => '沖煮';

  @override
  String get tabLog => '記錄';

  @override
  String get tabBeans => '豆子';

  @override
  String get tabMe => '我的';

  @override
  String get brewStart => '開始沖煮';

  @override
  String get brewQuickRepeat => '快速重複上次';

  @override
  String get brewNoPrevious => '尚無沖煮記錄,從這裡開始第一杯';

  @override
  String brewTodayCount(int count) {
    return '今日已沖 $count 杯';
  }

  @override
  String get brewSelectBean => '選豆子';

  @override
  String get brewSelectMethod => '選沖煮方式';

  @override
  String get brewSetParams => '設定參數';

  @override
  String get brewTimer => '計時沖煮';

  @override
  String get brewRate => '風味評分';

  @override
  String get brewDiagnosis => '診斷建議';

  @override
  String get brewSaveAsRecipe => '存成配方';

  @override
  String get brewApplyAndStartNext => '套用建議並開始下一杯';

  @override
  String get paramDose => '粉重';

  @override
  String get paramWater => '水重';

  @override
  String get paramRatio => '粉水比';

  @override
  String get paramGrind => '研磨';

  @override
  String get paramWaterTemp => '水溫';

  @override
  String get paramBloomWater => '悶蒸水量';

  @override
  String get paramBloomTime => '悶蒸時間';

  @override
  String get paramTotalTime => '總沖煮時間';

  @override
  String get paramBeverageMass => '液重';

  @override
  String get paramTds => 'TDS';

  @override
  String get paramMore => '更多設定';

  @override
  String paramGrams(String value) {
    return '$value g';
  }

  @override
  String paramTempC(String value) {
    return '$value °C';
  }

  @override
  String get timerStart => '開始';

  @override
  String get timerPause => '暫停';

  @override
  String get timerReset => '重置';

  @override
  String get timerFinish => '完成';

  @override
  String timerCurrentWater(String g) {
    return '目前水量 $g g';
  }

  @override
  String get timerPourTarget => '注水目標';

  @override
  String get ratingAcidity => '酸質';

  @override
  String get ratingSweetness => '甜感';

  @override
  String get ratingBody => '醇厚度';

  @override
  String get ratingBitterness => '苦味';

  @override
  String get ratingAftertaste => '餘韻';

  @override
  String get ratingBalance => '平衡感';

  @override
  String get ratingOverall => '總體評分';

  @override
  String get ratingFlavorTags => '風味標籤';

  @override
  String get ratingDefects => '缺陷';

  @override
  String get diagnosisOneChangeAtATime => '建議先只調整第 ① 項,一次改一個變數才知道是什麼影響了風味';

  @override
  String get diagnosisYourTasteFirst => '最終以你的口味為準';

  @override
  String get diagnosisSuccess => '🎉 這杯很成功,建議存成配方';

  @override
  String get diagnosisNoSuggestion => '這杯看起來不錯,繼續保持';

  @override
  String get logTitle => '歷史記錄';

  @override
  String get logEmpty => '還沒有沖煮記錄';

  @override
  String get logCompare => '兩筆並列比對';

  @override
  String get logStats => '統計';

  @override
  String get logTotalBrews => '總沖煮次數';

  @override
  String logAvgRating(String n) {
    return '平均 $n ★';
  }

  @override
  String get logFavoriteMethod => '最常用沖煮方式';

  @override
  String get beanTitle => '咖啡豆';

  @override
  String get beanAdd => '新增豆子';

  @override
  String get beanName => '名稱';

  @override
  String get beanRoaster => '烘豆商';

  @override
  String get beanOrigin => '產地';

  @override
  String get beanFarm => '莊園';

  @override
  String get beanVariety => '品種';

  @override
  String get beanProcessing => '處理法';

  @override
  String get beanRoastLevel => '烘焙度';

  @override
  String get beanRoastDate => '烘焙日期';

  @override
  String get beanPurchaseDate => '購買日';

  @override
  String get beanWeight => '重量';

  @override
  String get beanPrice => '價格';

  @override
  String get beanAltitude => '海拔';

  @override
  String get beanRestDays => '養豆天數';

  @override
  String get beanRestHintRef => '依烘焙度與保存狀況而異';

  @override
  String get beanRestHint0to3 => '排氣旺盛期,風味尚未穩定';

  @override
  String get beanRestHint4to14 => '適飲期';

  @override
  String get beanRestHint15to30 => '穩定期';

  @override
  String get beanRestHintOver30 => '風味可能已衰退';

  @override
  String get beanRestHintInvalid => '烘焙日期異常';

  @override
  String get meTitle => '我的';

  @override
  String get meEquipment => '器材';

  @override
  String get meGrinder => '磨豆機';

  @override
  String get meDripper => '濾杯';

  @override
  String get meFilter => '濾紙';

  @override
  String get meKettle => '水壺';

  @override
  String get meScale => '電子秤';

  @override
  String get meLanguage => '語言';

  @override
  String get meSettings => '設定';

  @override
  String get meSubscription => '訂閱';

  @override
  String get meAbout => '關於';

  @override
  String get mePrivacyPolicy => '隱私政策';

  @override
  String get meTermsOfService => '服務條款';

  @override
  String get meLangZh => '繁體中文';

  @override
  String get meLangEn => 'English';

  @override
  String get paywallTitle => '升級 BrewLog Pro';

  @override
  String get paywallSubtitle => '解鎖完整診斷、配方庫、歷史比對與萃取控制圖';

  @override
  String get paywallMonthly => '月訂閱 NT\$99';

  @override
  String get paywallYearly => '年訂閱 NT\$690(省 42%)';

  @override
  String get paywallLifetime => '買斷 NT\$1,290';

  @override
  String get paywallRestore => '恢復購買';

  @override
  String get paywallLimitBrew => '已達免費版 30 筆上限';

  @override
  String get paywallLimitRecipe => '免費版最多 3 組配方';

  @override
  String get paywallLimitBean => '免費版最多 5 支豆子';

  @override
  String get paywallLimitDiagnosis => '本週診斷次數已用完';

  @override
  String get commonSave => '儲存';

  @override
  String get commonCancel => '取消';

  @override
  String get commonDelete => '刪除';

  @override
  String get commonConfirm => '確認';

  @override
  String get commonEdit => '編輯';

  @override
  String get commonCopy => '複製';

  @override
  String get commonUnitGrams => 'g';

  @override
  String get commonUnitCelsius => '°C';

  @override
  String get commonUnitPercent => '%';

  @override
  String get commonYes => '是';

  @override
  String get commonNo => '否';

  @override
  String get commonSelect => '請選擇';

  @override
  String get commonDate => '日期';

  @override
  String get commonRequired => '必填';

  @override
  String get commonAdd => '新增';

  @override
  String get commonAll => '全部';

  @override
  String get commonFilter => '篩選';

  @override
  String get commonSort => '排序';

  @override
  String get commonSearch => '搜尋';

  @override
  String get commonError => '錯誤';

  @override
  String get commonEmpty => '無資料';

  @override
  String get commonRetry => '重試';

  @override
  String get commonOk => '確定';

  @override
  String get commonMore => '更多';

  @override
  String get commonActions => '操作';

  @override
  String get commonDuplicated => '已複製';

  @override
  String get commonShowMore => '展開';

  @override
  String get commonShowLess => '收合';

  @override
  String get commonPercent => '%';

  @override
  String get commonSeconds => '秒';

  @override
  String get commonMinutes => '分';

  @override
  String get commonToday => '今天';

  @override
  String get commonThisWeek => '本週';

  @override
  String get commonThisMonth => '本月';

  @override
  String get commonDraft => '草稿';

  @override
  String get commonResume => '繼續沖煮';

  @override
  String get commonSavedAsDraft => '已存為草稿';

  @override
  String get commonLoading => '載入中…';

  @override
  String get commonClose => '關閉';

  @override
  String get commonTodayCountUnit => '杯';

  @override
  String get commonRatio => '粉水比';

  @override
  String get commonTemp => '水溫';

  @override
  String get commonTime => '時間';

  @override
  String get commonNote => '備註';

  @override
  String get commonPhoto => '照片';

  @override
  String get commonTakePhoto => '拍照';

  @override
  String get commonPickPhoto => '從相簿選擇';

  @override
  String get commonNoPhoto => '無照片';

  @override
  String get commonAddPhoto => '新增照片';

  @override
  String get beanAddTitle => '新增豆子';

  @override
  String get beanEditTitle => '編輯豆子';

  @override
  String beanDeleteConfirm(String name) {
    return '確定要刪除「$name」?';
  }

  @override
  String beanFieldRequired(String field) {
    return '$field為必填';
  }

  @override
  String get beanUse => '使用這支豆子沖煮';

  @override
  String beanRestDaysShort(int days) {
    return '養豆 $days 天';
  }

  @override
  String get beanUnspecified => '未指定豆子';

  @override
  String get beanDeletedTag => '已刪除的豆子';

  @override
  String get beanNoBeans => '還沒有任何豆子,從右下角新增第一支';

  @override
  String get beanPickDate => '選擇日期';

  @override
  String get beanOptional => '(選填)';

  @override
  String get meAddEquipment => '新增器材';

  @override
  String get meEquipmentName => '名稱';

  @override
  String get meEquipmentNotes => '備註';

  @override
  String get meEquipmentType => '類型';

  @override
  String get meEquipmentTypeGrinder => '磨豆機';

  @override
  String get meEquipmentTypeDripper => '濾杯';

  @override
  String get meEquipmentTypeFilter => '濾紙';

  @override
  String get meEquipmentTypeKettle => '水壺';

  @override
  String get meEquipmentTypeScale => '電子秤';

  @override
  String meEquipmentDeleteConfirm(String name) {
    return '確定刪除「$name」?';
  }

  @override
  String get grinderAdd => '新增自訂磨豆機';

  @override
  String get grinderName => '磨豆機名稱';

  @override
  String get grinderUnit => '刻度單位';

  @override
  String get grinderRange => '刻度範圍';

  @override
  String get grinderStep => '最小調整單位';

  @override
  String get grinderCustomSection => '自訂磨豆機';

  @override
  String get grinderBuiltInSection => '內建磨豆機';

  @override
  String get grinderActive => '使用中';

  @override
  String get grinderSetActive => '設為使用中';

  @override
  String grinderDeleteConfirm(String name) {
    return '確定刪除自訂磨豆機「$name」?';
  }

  @override
  String get brewSelectBeanHint => '選擇一支豆子開始';

  @override
  String get brewNoBeanChoice => '不指定豆子(實驗配方)';

  @override
  String get brewMethodPicker => '選擇沖煮方式';

  @override
  String get brewMethodTempNA => 'N/A';

  @override
  String brewMethodRatio(String ratio, String temp) {
    return '預設 1:$ratio · $temp°C';
  }

  @override
  String get espressoModeHint => 'espresso 模式:顯示 粉重 / 液重 / 時間,隱藏悶蒸與注水排程';

  @override
  String get espressoDoseLabel => '粉重';

  @override
  String get espressoBeverageLabel => '液重';

  @override
  String get espressoPressureLabel => '壓力';

  @override
  String paramGrindSettingFormat(String grinder, String value, String unit) {
    return '$grinder · $value $unit';
  }

  @override
  String get paramBeverageEst => '估算';

  @override
  String get paramRatioNa => '—';

  @override
  String get paramNeedTds => '需輸入 TDS';

  @override
  String get paramTdsLow => 'TDS 偏低';

  @override
  String get paramTdsHigh => 'TDS 偏高';

  @override
  String get paramInvalidNumber => '數值不合法';

  @override
  String get timerResume => '繼續';

  @override
  String timerElapsed(String time) {
    return '已沖 $time';
  }

  @override
  String timerNextPour(String label, String g) {
    return '下一段:$label 目標 $g g';
  }

  @override
  String timerCurrentSection(String label) {
    return '目前:$label';
  }

  @override
  String get timerAllDone => '完成注水';

  @override
  String get timerWakelockOn => '螢幕保持開啟';

  @override
  String get timerWakelockOff => '螢幕正常休眠';

  @override
  String get timerBackgroundAccurate => '背景計時(誤差 < 1s)';

  @override
  String get timerConfirmFinish => '確定完成這次沖煮?';

  @override
  String get timerSaveDraft => '存成草稿';

  @override
  String get timerStepBloom => '悶蒸';

  @override
  String get timerStepMain => '主段';

  @override
  String get timerStepCustom => '注水';

  @override
  String get rateHelperAcidityLow => '平淡';

  @override
  String get rateHelperAcidityMid => '中等';

  @override
  String get rateHelperAcidityHigh => '明亮';

  @override
  String get rateHelperBitternessLow => '溫和';

  @override
  String get rateHelperBitternessHigh => '苦澀';

  @override
  String get rateHelperSweetnessLow => '薄弱';

  @override
  String get rateHelperSweetnessHigh => '飽滿';

  @override
  String get rateHelperBodyLow => '水感';

  @override
  String get rateHelperBodyHigh => '厚實';

  @override
  String get rateHelperAftertasteShort => '短';

  @override
  String get rateHelperAftertasteLong => '悠長';

  @override
  String get rateHelperBalanceOff => '失衡';

  @override
  String get rateHelperBalanceGood => '和諧';

  @override
  String get rateNoFlavor => '尚未選風味';

  @override
  String get rateFlavorSearchHint => '搜尋詞彙(中英皆可)';

  @override
  String rateFlavorSelected(int count) {
    return '已選 $count/8';
  }

  @override
  String get rateDefectNone => '無明顯缺陷';

  @override
  String get rateDefectUnder => '萃取不足-尖酸';

  @override
  String get rateDefectOver => '過萃澀感';

  @override
  String get rateDefectWeak => '味道太淡';

  @override
  String get rateDefectStrong => '味道太濃';

  @override
  String get rateDefectOff => '雜味';

  @override
  String get rateComplete => '完成並看建議';

  @override
  String get diagHeader => '本杯診斷';

  @override
  String get diagSuccessTitle => '🎉 這杯很成功';

  @override
  String get diagSuccessDesc => '建議存成配方,並重現本次關鍵參數';

  @override
  String get diagSuccessKey => '本次關鍵參數';

  @override
  String get diagApply => '套用建議並開始下一杯';

  @override
  String get diagSaveRecipe => '存成配方';

  @override
  String diagItemPrefix(String n) {
    return '建議 $n';
  }

  @override
  String get diagNotEnoughData => '資料不足以診斷,請補上風味評分或 TDS';

  @override
  String get recipeAddTitle => '新增配方';

  @override
  String get recipeEditTitle => '編輯配方';

  @override
  String recipeDeleteConfirm(String name) {
    return '確定刪除配方「$name」?';
  }

  @override
  String get recipeNoRecipes => '還沒有配方';

  @override
  String get recipeProLimit => '免費版最多 3 組配方';

  @override
  String get recipeApply => '套用';

  @override
  String get recipeFavorite => '我的最愛';

  @override
  String get recipePourSchedule => '注水排程';

  @override
  String get recipeAddPourStep => '新增注水段';

  @override
  String recipeStepAt(String sec) {
    return '於 $sec 秒';
  }

  @override
  String recipeStepCumulative(String g) {
    return '累計 $g g';
  }

  @override
  String logTotal(int count) {
    return '共 $count 杯';
  }

  @override
  String logThisWeek(int count) {
    return '本週 $count 杯';
  }

  @override
  String get logMethodDistribution => '常用方式';

  @override
  String get logCompareSelect2 => '選 2 筆並列比對';

  @override
  String logComparePicked(int n) {
    return '已選 $n/2';
  }

  @override
  String get logCompareSame => '相同';

  @override
  String get logCompareDiff => '差異';

  @override
  String get logBrewControlChart => '萃取控制圖';

  @override
  String get logChartX => '萃取率 EY (%)';

  @override
  String get logChartY => '濃度 TDS (%)';

  @override
  String get logChartRefZone => '參考區間 EY 18–22 / TDS 1.15–1.45';

  @override
  String get logProLocked => 'Pro 限定功能';

  @override
  String get logFilterByBean => '依豆子篩選';

  @override
  String get logFilterByMethod => '依方式篩選';

  @override
  String get logFilterByRating => '依評分篩選';

  @override
  String get logFilterByDate => '依日期篩選';

  @override
  String get paywallFeatureBrews => '無限筆沖煮記錄';

  @override
  String get paywallFeatureRecipes => '無限組配方';

  @override
  String get paywallFeatureBeans => '無限支豆子';

  @override
  String get paywallFeatureDiag => '無限次診斷';

  @override
  String get paywallFeatureChart => '萃取控制圖';

  @override
  String get paywallFeatureCompare => '兩筆並列比對';

  @override
  String get paywallFeatureExport => '資料匯出(規劃中)';

  @override
  String get paywallSubscribe => '訂閱 Pro';

  @override
  String get paywallTermsNote => '訂閱將透過 App Store / Google Play 自動續訂,可隨時取消。';

  @override
  String get disclaimer =>
      '本 App 提供的沖煮建議與參考區間僅供參考,實際風味受豆子狀態、器材、水質與個人口味影響。最終以你的味覺為準。';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'BrewLog';

  @override
  String get tabBrew => '沖煮';

  @override
  String get tabLog => '記錄';

  @override
  String get tabBeans => '豆子';

  @override
  String get tabMe => '我的';

  @override
  String get brewStart => '開始沖煮';

  @override
  String get brewQuickRepeat => '快速重複上次';

  @override
  String get brewNoPrevious => '尚無沖煮記錄,從這裡開始第一杯';

  @override
  String brewTodayCount(int count) {
    return '今日已沖 $count 杯';
  }

  @override
  String get brewSelectBean => '選豆子';

  @override
  String get brewSelectMethod => '選沖煮方式';

  @override
  String get brewSetParams => '設定參數';

  @override
  String get brewTimer => '計時沖煮';

  @override
  String get brewRate => '風味評分';

  @override
  String get brewDiagnosis => '診斷建議';

  @override
  String get brewSaveAsRecipe => '存成配方';

  @override
  String get brewApplyAndStartNext => '套用建議並開始下一杯';

  @override
  String get paramDose => '粉重';

  @override
  String get paramWater => '水重';

  @override
  String get paramRatio => '粉水比';

  @override
  String get paramGrind => '研磨';

  @override
  String get paramWaterTemp => '水溫';

  @override
  String get paramBloomWater => '悶蒸水量';

  @override
  String get paramBloomTime => '悶蒸時間';

  @override
  String get paramTotalTime => '總沖煮時間';

  @override
  String get paramBeverageMass => '液重';

  @override
  String get paramTds => 'TDS';

  @override
  String get paramMore => '更多設定';

  @override
  String paramGrams(String value) {
    return '$value g';
  }

  @override
  String paramTempC(String value) {
    return '$value °C';
  }

  @override
  String get timerStart => '開始';

  @override
  String get timerPause => '暫停';

  @override
  String get timerReset => '重置';

  @override
  String get timerFinish => '完成';

  @override
  String timerCurrentWater(String g) {
    return '目前水量 $g g';
  }

  @override
  String get timerPourTarget => '注水目標';

  @override
  String get ratingAcidity => '酸質';

  @override
  String get ratingSweetness => '甜感';

  @override
  String get ratingBody => '醇厚度';

  @override
  String get ratingBitterness => '苦味';

  @override
  String get ratingAftertaste => '餘韻';

  @override
  String get ratingBalance => '平衡感';

  @override
  String get ratingOverall => '總體評分';

  @override
  String get ratingFlavorTags => '風味標籤';

  @override
  String get ratingDefects => '缺陷';

  @override
  String get diagnosisOneChangeAtATime => '建議先只調整第 ① 項,一次改一個變數才知道是什麼影響了風味';

  @override
  String get diagnosisYourTasteFirst => '最終以你的口味為準';

  @override
  String get diagnosisSuccess => '🎉 這杯很成功,建議存成配方';

  @override
  String get diagnosisNoSuggestion => '這杯看起來不錯,繼續保持';

  @override
  String get logTitle => '歷史記錄';

  @override
  String get logEmpty => '還沒有沖煮記錄';

  @override
  String get logCompare => '兩筆並列比對';

  @override
  String get logStats => '統計';

  @override
  String get logTotalBrews => '總沖煮次數';

  @override
  String logAvgRating(String n) {
    return '平均 $n ★';
  }

  @override
  String get logFavoriteMethod => '最常用沖煮方式';

  @override
  String get beanTitle => '咖啡豆';

  @override
  String get beanAdd => '新增豆子';

  @override
  String get beanName => '名稱';

  @override
  String get beanRoaster => '烘豆商';

  @override
  String get beanOrigin => '產地';

  @override
  String get beanFarm => '莊園';

  @override
  String get beanVariety => '品種';

  @override
  String get beanProcessing => '處理法';

  @override
  String get beanRoastLevel => '烘焙度';

  @override
  String get beanRoastDate => '烘焙日期';

  @override
  String get beanPurchaseDate => '購買日';

  @override
  String get beanWeight => '重量';

  @override
  String get beanPrice => '價格';

  @override
  String get beanAltitude => '海拔';

  @override
  String get beanRestDays => '養豆天數';

  @override
  String get beanRestHintRef => '依烘焙度與保存狀況而異';

  @override
  String get beanRestHint0to3 => '排氣旺盛期,風味尚未穩定';

  @override
  String get beanRestHint4to14 => '適飲期';

  @override
  String get beanRestHint15to30 => '穩定期';

  @override
  String get beanRestHintOver30 => '風味可能已衰退';

  @override
  String get beanRestHintInvalid => '烘焙日期異常';

  @override
  String get meTitle => '我的';

  @override
  String get meEquipment => '器材';

  @override
  String get meGrinder => '磨豆機';

  @override
  String get meDripper => '濾杯';

  @override
  String get meFilter => '濾紙';

  @override
  String get meKettle => '水壺';

  @override
  String get meScale => '電子秤';

  @override
  String get meLanguage => '語言';

  @override
  String get meSettings => '設定';

  @override
  String get meSubscription => '訂閱';

  @override
  String get meAbout => '關於';

  @override
  String get mePrivacyPolicy => '隱私政策';

  @override
  String get meTermsOfService => '服務條款';

  @override
  String get meLangZh => '繁體中文';

  @override
  String get meLangEn => 'English';

  @override
  String get paywallTitle => '升級 BrewLog Pro';

  @override
  String get paywallSubtitle => '解鎖完整診斷、配方庫、歷史比對與萃取控制圖';

  @override
  String get paywallMonthly => '月訂閱 NT\$99';

  @override
  String get paywallYearly => '年訂閱 NT\$690(省 42%)';

  @override
  String get paywallLifetime => '買斷 NT\$1,290';

  @override
  String get paywallRestore => '恢復購買';

  @override
  String get paywallLimitBrew => '已達免費版 30 筆上限';

  @override
  String get paywallLimitRecipe => '免費版最多 3 組配方';

  @override
  String get paywallLimitBean => '免費版最多 5 支豆子';

  @override
  String get paywallLimitDiagnosis => '本週診斷次數已用完';

  @override
  String get commonSave => '儲存';

  @override
  String get commonCancel => '取消';

  @override
  String get commonDelete => '刪除';

  @override
  String get commonConfirm => '確認';

  @override
  String get commonEdit => '編輯';

  @override
  String get commonCopy => '複製';

  @override
  String get commonUnitGrams => 'g';

  @override
  String get commonUnitCelsius => '°C';

  @override
  String get commonUnitPercent => '%';

  @override
  String get commonYes => '是';

  @override
  String get commonNo => '否';

  @override
  String get commonSelect => '請選擇';

  @override
  String get commonDate => '日期';

  @override
  String get commonRequired => '必填';

  @override
  String get commonAdd => '新增';

  @override
  String get commonAll => '全部';

  @override
  String get commonFilter => '篩選';

  @override
  String get commonSort => '排序';

  @override
  String get commonSearch => '搜尋';

  @override
  String get commonError => '錯誤';

  @override
  String get commonEmpty => '無資料';

  @override
  String get commonRetry => '重試';

  @override
  String get commonOk => '確定';

  @override
  String get commonMore => '更多';

  @override
  String get commonActions => '操作';

  @override
  String get commonDuplicated => '已複製';

  @override
  String get commonShowMore => '展開';

  @override
  String get commonShowLess => '收合';

  @override
  String get commonPercent => '%';

  @override
  String get commonSeconds => '秒';

  @override
  String get commonMinutes => '分';

  @override
  String get commonToday => '今天';

  @override
  String get commonThisWeek => '本週';

  @override
  String get commonThisMonth => '本月';

  @override
  String get commonDraft => '草稿';

  @override
  String get commonResume => '繼續沖煮';

  @override
  String get commonSavedAsDraft => '已存為草稿';

  @override
  String get commonLoading => '載入中…';

  @override
  String get commonClose => '關閉';

  @override
  String get commonTodayCountUnit => '杯';

  @override
  String get commonRatio => '粉水比';

  @override
  String get commonTemp => '水溫';

  @override
  String get commonTime => '時間';

  @override
  String get commonNote => '備註';

  @override
  String get commonPhoto => '照片';

  @override
  String get commonTakePhoto => '拍照';

  @override
  String get commonPickPhoto => '從相簿選擇';

  @override
  String get commonNoPhoto => '無照片';

  @override
  String get commonAddPhoto => '新增照片';

  @override
  String get beanAddTitle => '新增豆子';

  @override
  String get beanEditTitle => '編輯豆子';

  @override
  String beanDeleteConfirm(String name) {
    return '確定要刪除「$name」?';
  }

  @override
  String beanFieldRequired(String field) {
    return '$field為必填';
  }

  @override
  String get beanUse => '使用這支豆子沖煮';

  @override
  String beanRestDaysShort(int days) {
    return '養豆 $days 天';
  }

  @override
  String get beanUnspecified => '未指定豆子';

  @override
  String get beanDeletedTag => '已刪除的豆子';

  @override
  String get beanNoBeans => '還沒有任何豆子,從右下角新增第一支';

  @override
  String get beanPickDate => '選擇日期';

  @override
  String get beanOptional => '(選填)';

  @override
  String get meAddEquipment => '新增器材';

  @override
  String get meEquipmentName => '名稱';

  @override
  String get meEquipmentNotes => '備註';

  @override
  String get meEquipmentType => '類型';

  @override
  String get meEquipmentTypeGrinder => '磨豆機';

  @override
  String get meEquipmentTypeDripper => '濾杯';

  @override
  String get meEquipmentTypeFilter => '濾紙';

  @override
  String get meEquipmentTypeKettle => '水壺';

  @override
  String get meEquipmentTypeScale => '電子秤';

  @override
  String meEquipmentDeleteConfirm(String name) {
    return '確定刪除「$name」?';
  }

  @override
  String get grinderAdd => '新增自訂磨豆機';

  @override
  String get grinderName => '磨豆機名稱';

  @override
  String get grinderUnit => '刻度單位';

  @override
  String get grinderRange => '刻度範圍';

  @override
  String get grinderStep => '最小調整單位';

  @override
  String get grinderCustomSection => '自訂磨豆機';

  @override
  String get grinderBuiltInSection => '內建磨豆機';

  @override
  String get grinderActive => '使用中';

  @override
  String get grinderSetActive => '設為使用中';

  @override
  String grinderDeleteConfirm(String name) {
    return '確定刪除自訂磨豆機「$name」?';
  }

  @override
  String get brewSelectBeanHint => '選擇一支豆子開始';

  @override
  String get brewNoBeanChoice => '不指定豆子(實驗配方)';

  @override
  String get brewMethodPicker => '選擇沖煮方式';

  @override
  String get brewMethodTempNA => 'N/A';

  @override
  String brewMethodRatio(String ratio, String temp) {
    return '預設 1:$ratio · $temp°C';
  }

  @override
  String get espressoModeHint => 'espresso 模式:顯示 粉重 / 液重 / 時間,隱藏悶蒸與注水排程';

  @override
  String get espressoDoseLabel => '粉重';

  @override
  String get espressoBeverageLabel => '液重';

  @override
  String get espressoPressureLabel => '壓力';

  @override
  String paramGrindSettingFormat(String grinder, String value, String unit) {
    return '$grinder · $value $unit';
  }

  @override
  String get paramBeverageEst => '估算';

  @override
  String get paramRatioNa => '—';

  @override
  String get paramNeedTds => '需輸入 TDS';

  @override
  String get paramTdsLow => 'TDS 偏低';

  @override
  String get paramTdsHigh => 'TDS 偏高';

  @override
  String get paramInvalidNumber => '數值不合法';

  @override
  String get timerResume => '繼續';

  @override
  String timerElapsed(String time) {
    return '已沖 $time';
  }

  @override
  String timerNextPour(String label, String g) {
    return '下一段:$label 目標 $g g';
  }

  @override
  String timerCurrentSection(String label) {
    return '目前:$label';
  }

  @override
  String get timerAllDone => '完成注水';

  @override
  String get timerWakelockOn => '螢幕保持開啟';

  @override
  String get timerWakelockOff => '螢幕正常休眠';

  @override
  String get timerBackgroundAccurate => '背景計時(誤差 < 1s)';

  @override
  String get timerConfirmFinish => '確定完成這次沖煮?';

  @override
  String get timerSaveDraft => '存成草稿';

  @override
  String get timerStepBloom => '悶蒸';

  @override
  String get timerStepMain => '主段';

  @override
  String get timerStepCustom => '注水';

  @override
  String get rateHelperAcidityLow => '平淡';

  @override
  String get rateHelperAcidityMid => '中等';

  @override
  String get rateHelperAcidityHigh => '明亮';

  @override
  String get rateHelperBitternessLow => '溫和';

  @override
  String get rateHelperBitternessHigh => '苦澀';

  @override
  String get rateHelperSweetnessLow => '薄弱';

  @override
  String get rateHelperSweetnessHigh => '飽滿';

  @override
  String get rateHelperBodyLow => '水感';

  @override
  String get rateHelperBodyHigh => '厚實';

  @override
  String get rateHelperAftertasteShort => '短';

  @override
  String get rateHelperAftertasteLong => '悠長';

  @override
  String get rateHelperBalanceOff => '失衡';

  @override
  String get rateHelperBalanceGood => '和諧';

  @override
  String get rateNoFlavor => '尚未選風味';

  @override
  String get rateFlavorSearchHint => '搜尋詞彙(中英皆可)';

  @override
  String rateFlavorSelected(int count) {
    return '已選 $count/8';
  }

  @override
  String get rateDefectNone => '無明顯缺陷';

  @override
  String get rateDefectUnder => '萃取不足-尖酸';

  @override
  String get rateDefectOver => '過萃澀感';

  @override
  String get rateDefectWeak => '味道太淡';

  @override
  String get rateDefectStrong => '味道太濃';

  @override
  String get rateDefectOff => '雜味';

  @override
  String get rateComplete => '完成並看建議';

  @override
  String get diagHeader => '本杯診斷';

  @override
  String get diagSuccessTitle => '🎉 這杯很成功';

  @override
  String get diagSuccessDesc => '建議存成配方,並重現本次關鍵參數';

  @override
  String get diagSuccessKey => '本次關鍵參數';

  @override
  String get diagApply => '套用建議並開始下一杯';

  @override
  String get diagSaveRecipe => '存成配方';

  @override
  String diagItemPrefix(String n) {
    return '建議 $n';
  }

  @override
  String get diagNotEnoughData => '資料不足以診斷,請補上風味評分或 TDS';

  @override
  String get recipeAddTitle => '新增配方';

  @override
  String get recipeEditTitle => '編輯配方';

  @override
  String recipeDeleteConfirm(String name) {
    return '確定刪除配方「$name」?';
  }

  @override
  String get recipeNoRecipes => '還沒有配方';

  @override
  String get recipeProLimit => '免費版最多 3 組配方';

  @override
  String get recipeApply => '套用';

  @override
  String get recipeFavorite => '我的最愛';

  @override
  String get recipePourSchedule => '注水排程';

  @override
  String get recipeAddPourStep => '新增注水段';

  @override
  String recipeStepAt(String sec) {
    return '於 $sec 秒';
  }

  @override
  String recipeStepCumulative(String g) {
    return '累計 $g g';
  }

  @override
  String logTotal(int count) {
    return '共 $count 杯';
  }

  @override
  String logThisWeek(int count) {
    return '本週 $count 杯';
  }

  @override
  String get logMethodDistribution => '常用方式';

  @override
  String get logCompareSelect2 => '選 2 筆並列比對';

  @override
  String logComparePicked(int n) {
    return '已選 $n/2';
  }

  @override
  String get logCompareSame => '相同';

  @override
  String get logCompareDiff => '差異';

  @override
  String get logBrewControlChart => '萃取控制圖';

  @override
  String get logChartX => '萃取率 EY (%)';

  @override
  String get logChartY => '濃度 TDS (%)';

  @override
  String get logChartRefZone => '參考區間 EY 18–22 / TDS 1.15–1.45';

  @override
  String get logProLocked => 'Pro 限定功能';

  @override
  String get logFilterByBean => '依豆子篩選';

  @override
  String get logFilterByMethod => '依方式篩選';

  @override
  String get logFilterByRating => '依評分篩選';

  @override
  String get logFilterByDate => '依日期篩選';

  @override
  String get paywallFeatureBrews => '無限筆沖煮記錄';

  @override
  String get paywallFeatureRecipes => '無限組配方';

  @override
  String get paywallFeatureBeans => '無限支豆子';

  @override
  String get paywallFeatureDiag => '無限次診斷';

  @override
  String get paywallFeatureChart => '萃取控制圖';

  @override
  String get paywallFeatureCompare => '兩筆並列比對';

  @override
  String get paywallFeatureExport => '資料匯出(規劃中)';

  @override
  String get paywallSubscribe => '訂閱 Pro';

  @override
  String get paywallTermsNote => '訂閱將透過 App Store / Google Play 自動續訂,可隨時取消。';

  @override
  String get disclaimer =>
      '本 App 提供的沖煮建議與參考區間僅供參考,實際風味受豆子狀態、器材、水質與個人口味影響。最終以你的味覺為準。';
}
