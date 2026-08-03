import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// App 標題
  ///
  /// In zh_TW, this message translates to:
  /// **'BrewLog'**
  String get appTitle;

  /// No description provided for @tabBrew.
  ///
  /// In zh_TW, this message translates to:
  /// **'沖煮'**
  String get tabBrew;

  /// No description provided for @tabLog.
  ///
  /// In zh_TW, this message translates to:
  /// **'記錄'**
  String get tabLog;

  /// No description provided for @tabBeans.
  ///
  /// In zh_TW, this message translates to:
  /// **'豆子'**
  String get tabBeans;

  /// No description provided for @tabMe.
  ///
  /// In zh_TW, this message translates to:
  /// **'我的'**
  String get tabMe;

  /// No description provided for @brewStart.
  ///
  /// In zh_TW, this message translates to:
  /// **'開始沖煮'**
  String get brewStart;

  /// No description provided for @brewQuickRepeat.
  ///
  /// In zh_TW, this message translates to:
  /// **'快速重複上次'**
  String get brewQuickRepeat;

  /// No description provided for @brewNoPrevious.
  ///
  /// In zh_TW, this message translates to:
  /// **'尚無沖煮記錄,從這裡開始第一杯'**
  String get brewNoPrevious;

  /// No description provided for @brewTodayCount.
  ///
  /// In zh_TW, this message translates to:
  /// **'今日已沖 {count} 杯'**
  String brewTodayCount(int count);

  /// No description provided for @brewSelectBean.
  ///
  /// In zh_TW, this message translates to:
  /// **'選豆子'**
  String get brewSelectBean;

  /// No description provided for @brewSelectMethod.
  ///
  /// In zh_TW, this message translates to:
  /// **'選沖煮方式'**
  String get brewSelectMethod;

  /// No description provided for @brewSetParams.
  ///
  /// In zh_TW, this message translates to:
  /// **'設定參數'**
  String get brewSetParams;

  /// No description provided for @brewTimer.
  ///
  /// In zh_TW, this message translates to:
  /// **'計時沖煮'**
  String get brewTimer;

  /// No description provided for @brewRate.
  ///
  /// In zh_TW, this message translates to:
  /// **'風味評分'**
  String get brewRate;

  /// No description provided for @brewDiagnosis.
  ///
  /// In zh_TW, this message translates to:
  /// **'診斷建議'**
  String get brewDiagnosis;

  /// No description provided for @brewSaveAsRecipe.
  ///
  /// In zh_TW, this message translates to:
  /// **'存成配方'**
  String get brewSaveAsRecipe;

  /// No description provided for @brewApplyAndStartNext.
  ///
  /// In zh_TW, this message translates to:
  /// **'套用建議並開始下一杯'**
  String get brewApplyAndStartNext;

  /// No description provided for @paramDose.
  ///
  /// In zh_TW, this message translates to:
  /// **'粉重'**
  String get paramDose;

  /// No description provided for @paramWater.
  ///
  /// In zh_TW, this message translates to:
  /// **'水重'**
  String get paramWater;

  /// No description provided for @paramRatio.
  ///
  /// In zh_TW, this message translates to:
  /// **'粉水比'**
  String get paramRatio;

  /// No description provided for @paramGrind.
  ///
  /// In zh_TW, this message translates to:
  /// **'研磨'**
  String get paramGrind;

  /// No description provided for @paramWaterTemp.
  ///
  /// In zh_TW, this message translates to:
  /// **'水溫'**
  String get paramWaterTemp;

  /// No description provided for @paramBloomWater.
  ///
  /// In zh_TW, this message translates to:
  /// **'悶蒸水量'**
  String get paramBloomWater;

  /// No description provided for @paramBloomTime.
  ///
  /// In zh_TW, this message translates to:
  /// **'悶蒸時間'**
  String get paramBloomTime;

  /// No description provided for @paramTotalTime.
  ///
  /// In zh_TW, this message translates to:
  /// **'總沖煮時間'**
  String get paramTotalTime;

  /// No description provided for @paramBeverageMass.
  ///
  /// In zh_TW, this message translates to:
  /// **'液重'**
  String get paramBeverageMass;

  /// No description provided for @paramTds.
  ///
  /// In zh_TW, this message translates to:
  /// **'TDS'**
  String get paramTds;

  /// No description provided for @paramMore.
  ///
  /// In zh_TW, this message translates to:
  /// **'更多設定'**
  String get paramMore;

  /// No description provided for @paramGrams.
  ///
  /// In zh_TW, this message translates to:
  /// **'{value} g'**
  String paramGrams(String value);

  /// No description provided for @paramTempC.
  ///
  /// In zh_TW, this message translates to:
  /// **'{value} °C'**
  String paramTempC(String value);

  /// No description provided for @timerStart.
  ///
  /// In zh_TW, this message translates to:
  /// **'開始'**
  String get timerStart;

  /// No description provided for @timerPause.
  ///
  /// In zh_TW, this message translates to:
  /// **'暫停'**
  String get timerPause;

  /// No description provided for @timerReset.
  ///
  /// In zh_TW, this message translates to:
  /// **'重置'**
  String get timerReset;

  /// No description provided for @timerFinish.
  ///
  /// In zh_TW, this message translates to:
  /// **'完成'**
  String get timerFinish;

  /// No description provided for @timerCurrentWater.
  ///
  /// In zh_TW, this message translates to:
  /// **'目前水量 {g} g'**
  String timerCurrentWater(String g);

  /// No description provided for @timerPourTarget.
  ///
  /// In zh_TW, this message translates to:
  /// **'注水目標'**
  String get timerPourTarget;

  /// No description provided for @ratingAcidity.
  ///
  /// In zh_TW, this message translates to:
  /// **'酸質'**
  String get ratingAcidity;

  /// No description provided for @ratingSweetness.
  ///
  /// In zh_TW, this message translates to:
  /// **'甜感'**
  String get ratingSweetness;

  /// No description provided for @ratingBody.
  ///
  /// In zh_TW, this message translates to:
  /// **'醇厚度'**
  String get ratingBody;

  /// No description provided for @ratingBitterness.
  ///
  /// In zh_TW, this message translates to:
  /// **'苦味'**
  String get ratingBitterness;

  /// No description provided for @ratingAftertaste.
  ///
  /// In zh_TW, this message translates to:
  /// **'餘韻'**
  String get ratingAftertaste;

  /// No description provided for @ratingBalance.
  ///
  /// In zh_TW, this message translates to:
  /// **'平衡感'**
  String get ratingBalance;

  /// No description provided for @ratingOverall.
  ///
  /// In zh_TW, this message translates to:
  /// **'總體評分'**
  String get ratingOverall;

  /// No description provided for @ratingFlavorTags.
  ///
  /// In zh_TW, this message translates to:
  /// **'風味標籤'**
  String get ratingFlavorTags;

  /// No description provided for @ratingDefects.
  ///
  /// In zh_TW, this message translates to:
  /// **'缺陷'**
  String get ratingDefects;

  /// No description provided for @diagnosisOneChangeAtATime.
  ///
  /// In zh_TW, this message translates to:
  /// **'建議先只調整第 ① 項,一次改一個變數才知道是什麼影響了風味'**
  String get diagnosisOneChangeAtATime;

  /// No description provided for @diagnosisYourTasteFirst.
  ///
  /// In zh_TW, this message translates to:
  /// **'最終以你的口味為準'**
  String get diagnosisYourTasteFirst;

  /// No description provided for @diagnosisSuccess.
  ///
  /// In zh_TW, this message translates to:
  /// **'🎉 這杯很成功,建議存成配方'**
  String get diagnosisSuccess;

  /// No description provided for @diagnosisNoSuggestion.
  ///
  /// In zh_TW, this message translates to:
  /// **'這杯看起來不錯,繼續保持'**
  String get diagnosisNoSuggestion;

  /// No description provided for @logTitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'歷史記錄'**
  String get logTitle;

  /// No description provided for @logEmpty.
  ///
  /// In zh_TW, this message translates to:
  /// **'還沒有沖煮記錄'**
  String get logEmpty;

  /// No description provided for @logCompare.
  ///
  /// In zh_TW, this message translates to:
  /// **'兩筆並列比對'**
  String get logCompare;

  /// No description provided for @logStats.
  ///
  /// In zh_TW, this message translates to:
  /// **'統計'**
  String get logStats;

  /// No description provided for @logTotalBrews.
  ///
  /// In zh_TW, this message translates to:
  /// **'總沖煮次數'**
  String get logTotalBrews;

  /// No description provided for @logAvgRating.
  ///
  /// In zh_TW, this message translates to:
  /// **'平均 {n} ★'**
  String logAvgRating(String n);

  /// No description provided for @logFavoriteMethod.
  ///
  /// In zh_TW, this message translates to:
  /// **'最常用沖煮方式'**
  String get logFavoriteMethod;

  /// No description provided for @beanTitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'咖啡豆'**
  String get beanTitle;

  /// No description provided for @beanAdd.
  ///
  /// In zh_TW, this message translates to:
  /// **'新增豆子'**
  String get beanAdd;

  /// No description provided for @beanName.
  ///
  /// In zh_TW, this message translates to:
  /// **'名稱'**
  String get beanName;

  /// No description provided for @beanRoaster.
  ///
  /// In zh_TW, this message translates to:
  /// **'烘豆商'**
  String get beanRoaster;

  /// No description provided for @beanOrigin.
  ///
  /// In zh_TW, this message translates to:
  /// **'產地'**
  String get beanOrigin;

  /// No description provided for @beanFarm.
  ///
  /// In zh_TW, this message translates to:
  /// **'莊園'**
  String get beanFarm;

  /// No description provided for @beanVariety.
  ///
  /// In zh_TW, this message translates to:
  /// **'品種'**
  String get beanVariety;

  /// No description provided for @beanProcessing.
  ///
  /// In zh_TW, this message translates to:
  /// **'處理法'**
  String get beanProcessing;

  /// No description provided for @beanRoastLevel.
  ///
  /// In zh_TW, this message translates to:
  /// **'烘焙度'**
  String get beanRoastLevel;

  /// No description provided for @beanRoastDate.
  ///
  /// In zh_TW, this message translates to:
  /// **'烘焙日期'**
  String get beanRoastDate;

  /// No description provided for @beanPurchaseDate.
  ///
  /// In zh_TW, this message translates to:
  /// **'購買日'**
  String get beanPurchaseDate;

  /// No description provided for @beanWeight.
  ///
  /// In zh_TW, this message translates to:
  /// **'重量'**
  String get beanWeight;

  /// No description provided for @beanPrice.
  ///
  /// In zh_TW, this message translates to:
  /// **'價格'**
  String get beanPrice;

  /// No description provided for @beanAltitude.
  ///
  /// In zh_TW, this message translates to:
  /// **'海拔'**
  String get beanAltitude;

  /// No description provided for @beanRestDays.
  ///
  /// In zh_TW, this message translates to:
  /// **'養豆天數'**
  String get beanRestDays;

  /// No description provided for @beanRestHintRef.
  ///
  /// In zh_TW, this message translates to:
  /// **'依烘焙度與保存狀況而異'**
  String get beanRestHintRef;

  /// No description provided for @beanRestHint0to3.
  ///
  /// In zh_TW, this message translates to:
  /// **'排氣旺盛期,風味尚未穩定'**
  String get beanRestHint0to3;

  /// No description provided for @beanRestHint4to14.
  ///
  /// In zh_TW, this message translates to:
  /// **'適飲期'**
  String get beanRestHint4to14;

  /// No description provided for @beanRestHint15to30.
  ///
  /// In zh_TW, this message translates to:
  /// **'穩定期'**
  String get beanRestHint15to30;

  /// No description provided for @beanRestHintOver30.
  ///
  /// In zh_TW, this message translates to:
  /// **'風味可能已衰退'**
  String get beanRestHintOver30;

  /// No description provided for @beanRestHintInvalid.
  ///
  /// In zh_TW, this message translates to:
  /// **'烘焙日期異常'**
  String get beanRestHintInvalid;

  /// No description provided for @meTitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'我的'**
  String get meTitle;

  /// No description provided for @meEquipment.
  ///
  /// In zh_TW, this message translates to:
  /// **'器材'**
  String get meEquipment;

  /// No description provided for @meGrinder.
  ///
  /// In zh_TW, this message translates to:
  /// **'磨豆機'**
  String get meGrinder;

  /// No description provided for @meDripper.
  ///
  /// In zh_TW, this message translates to:
  /// **'濾杯'**
  String get meDripper;

  /// No description provided for @meFilter.
  ///
  /// In zh_TW, this message translates to:
  /// **'濾紙'**
  String get meFilter;

  /// No description provided for @meKettle.
  ///
  /// In zh_TW, this message translates to:
  /// **'水壺'**
  String get meKettle;

  /// No description provided for @meScale.
  ///
  /// In zh_TW, this message translates to:
  /// **'電子秤'**
  String get meScale;

  /// No description provided for @meLanguage.
  ///
  /// In zh_TW, this message translates to:
  /// **'語言'**
  String get meLanguage;

  /// No description provided for @meSettings.
  ///
  /// In zh_TW, this message translates to:
  /// **'設定'**
  String get meSettings;

  /// No description provided for @meSubscription.
  ///
  /// In zh_TW, this message translates to:
  /// **'訂閱'**
  String get meSubscription;

  /// No description provided for @meAbout.
  ///
  /// In zh_TW, this message translates to:
  /// **'關於'**
  String get meAbout;

  /// No description provided for @mePrivacyPolicy.
  ///
  /// In zh_TW, this message translates to:
  /// **'隱私政策'**
  String get mePrivacyPolicy;

  /// No description provided for @meTermsOfService.
  ///
  /// In zh_TW, this message translates to:
  /// **'服務條款'**
  String get meTermsOfService;

  /// No description provided for @meLangZh.
  ///
  /// In zh_TW, this message translates to:
  /// **'繁體中文'**
  String get meLangZh;

  /// No description provided for @meLangEn.
  ///
  /// In zh_TW, this message translates to:
  /// **'English'**
  String get meLangEn;

  /// No description provided for @paywallTitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'升級 BrewLog Pro'**
  String get paywallTitle;

  /// No description provided for @paywallSubtitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'解鎖完整診斷、配方庫、歷史比對與萃取控制圖'**
  String get paywallSubtitle;

  /// No description provided for @paywallMonthly.
  ///
  /// In zh_TW, this message translates to:
  /// **'月訂閱 NT\$99'**
  String get paywallMonthly;

  /// No description provided for @paywallYearly.
  ///
  /// In zh_TW, this message translates to:
  /// **'年訂閱 NT\$690(省 42%)'**
  String get paywallYearly;

  /// No description provided for @paywallLifetime.
  ///
  /// In zh_TW, this message translates to:
  /// **'買斷 NT\$1,290'**
  String get paywallLifetime;

  /// No description provided for @paywallRestore.
  ///
  /// In zh_TW, this message translates to:
  /// **'恢復購買'**
  String get paywallRestore;

  /// No description provided for @paywallLimitBrew.
  ///
  /// In zh_TW, this message translates to:
  /// **'已達免費版 30 筆上限'**
  String get paywallLimitBrew;

  /// No description provided for @paywallLimitRecipe.
  ///
  /// In zh_TW, this message translates to:
  /// **'免費版最多 3 組配方'**
  String get paywallLimitRecipe;

  /// No description provided for @paywallLimitBean.
  ///
  /// In zh_TW, this message translates to:
  /// **'免費版最多 5 支豆子'**
  String get paywallLimitBean;

  /// No description provided for @paywallLimitDiagnosis.
  ///
  /// In zh_TW, this message translates to:
  /// **'本週診斷次數已用完'**
  String get paywallLimitDiagnosis;

  /// No description provided for @commonSave.
  ///
  /// In zh_TW, this message translates to:
  /// **'儲存'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In zh_TW, this message translates to:
  /// **'取消'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In zh_TW, this message translates to:
  /// **'刪除'**
  String get commonDelete;

  /// No description provided for @commonConfirm.
  ///
  /// In zh_TW, this message translates to:
  /// **'確認'**
  String get commonConfirm;

  /// No description provided for @commonEdit.
  ///
  /// In zh_TW, this message translates to:
  /// **'編輯'**
  String get commonEdit;

  /// No description provided for @commonCopy.
  ///
  /// In zh_TW, this message translates to:
  /// **'複製'**
  String get commonCopy;

  /// No description provided for @commonUnitGrams.
  ///
  /// In zh_TW, this message translates to:
  /// **'g'**
  String get commonUnitGrams;

  /// No description provided for @commonUnitCelsius.
  ///
  /// In zh_TW, this message translates to:
  /// **'°C'**
  String get commonUnitCelsius;

  /// No description provided for @commonUnitPercent.
  ///
  /// In zh_TW, this message translates to:
  /// **'%'**
  String get commonUnitPercent;

  /// No description provided for @commonYes.
  ///
  /// In zh_TW, this message translates to:
  /// **'是'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In zh_TW, this message translates to:
  /// **'否'**
  String get commonNo;

  /// No description provided for @commonSelect.
  ///
  /// In zh_TW, this message translates to:
  /// **'請選擇'**
  String get commonSelect;

  /// No description provided for @commonDate.
  ///
  /// In zh_TW, this message translates to:
  /// **'日期'**
  String get commonDate;

  /// No description provided for @commonRequired.
  ///
  /// In zh_TW, this message translates to:
  /// **'必填'**
  String get commonRequired;

  /// No description provided for @commonAdd.
  ///
  /// In zh_TW, this message translates to:
  /// **'新增'**
  String get commonAdd;

  /// No description provided for @commonAll.
  ///
  /// In zh_TW, this message translates to:
  /// **'全部'**
  String get commonAll;

  /// No description provided for @commonFilter.
  ///
  /// In zh_TW, this message translates to:
  /// **'篩選'**
  String get commonFilter;

  /// No description provided for @commonSort.
  ///
  /// In zh_TW, this message translates to:
  /// **'排序'**
  String get commonSort;

  /// No description provided for @commonSearch.
  ///
  /// In zh_TW, this message translates to:
  /// **'搜尋'**
  String get commonSearch;

  /// No description provided for @commonError.
  ///
  /// In zh_TW, this message translates to:
  /// **'錯誤'**
  String get commonError;

  /// No description provided for @commonEmpty.
  ///
  /// In zh_TW, this message translates to:
  /// **'無資料'**
  String get commonEmpty;

  /// No description provided for @commonRetry.
  ///
  /// In zh_TW, this message translates to:
  /// **'重試'**
  String get commonRetry;

  /// No description provided for @commonOk.
  ///
  /// In zh_TW, this message translates to:
  /// **'確定'**
  String get commonOk;

  /// No description provided for @commonMore.
  ///
  /// In zh_TW, this message translates to:
  /// **'更多'**
  String get commonMore;

  /// No description provided for @commonActions.
  ///
  /// In zh_TW, this message translates to:
  /// **'操作'**
  String get commonActions;

  /// No description provided for @commonDuplicated.
  ///
  /// In zh_TW, this message translates to:
  /// **'已複製'**
  String get commonDuplicated;

  /// No description provided for @commonShowMore.
  ///
  /// In zh_TW, this message translates to:
  /// **'展開'**
  String get commonShowMore;

  /// No description provided for @commonShowLess.
  ///
  /// In zh_TW, this message translates to:
  /// **'收合'**
  String get commonShowLess;

  /// No description provided for @commonPercent.
  ///
  /// In zh_TW, this message translates to:
  /// **'%'**
  String get commonPercent;

  /// No description provided for @commonSeconds.
  ///
  /// In zh_TW, this message translates to:
  /// **'秒'**
  String get commonSeconds;

  /// No description provided for @commonMinutes.
  ///
  /// In zh_TW, this message translates to:
  /// **'分'**
  String get commonMinutes;

  /// No description provided for @commonToday.
  ///
  /// In zh_TW, this message translates to:
  /// **'今天'**
  String get commonToday;

  /// No description provided for @commonThisWeek.
  ///
  /// In zh_TW, this message translates to:
  /// **'本週'**
  String get commonThisWeek;

  /// No description provided for @commonThisMonth.
  ///
  /// In zh_TW, this message translates to:
  /// **'本月'**
  String get commonThisMonth;

  /// No description provided for @commonDraft.
  ///
  /// In zh_TW, this message translates to:
  /// **'草稿'**
  String get commonDraft;

  /// No description provided for @commonResume.
  ///
  /// In zh_TW, this message translates to:
  /// **'繼續沖煮'**
  String get commonResume;

  /// No description provided for @commonSavedAsDraft.
  ///
  /// In zh_TW, this message translates to:
  /// **'已存為草稿'**
  String get commonSavedAsDraft;

  /// No description provided for @commonLoading.
  ///
  /// In zh_TW, this message translates to:
  /// **'載入中…'**
  String get commonLoading;

  /// No description provided for @commonClose.
  ///
  /// In zh_TW, this message translates to:
  /// **'關閉'**
  String get commonClose;

  /// No description provided for @commonTodayCountUnit.
  ///
  /// In zh_TW, this message translates to:
  /// **'杯'**
  String get commonTodayCountUnit;

  /// No description provided for @commonRatio.
  ///
  /// In zh_TW, this message translates to:
  /// **'粉水比'**
  String get commonRatio;

  /// No description provided for @commonTemp.
  ///
  /// In zh_TW, this message translates to:
  /// **'水溫'**
  String get commonTemp;

  /// No description provided for @commonTime.
  ///
  /// In zh_TW, this message translates to:
  /// **'時間'**
  String get commonTime;

  /// No description provided for @commonNote.
  ///
  /// In zh_TW, this message translates to:
  /// **'備註'**
  String get commonNote;

  /// No description provided for @commonPhoto.
  ///
  /// In zh_TW, this message translates to:
  /// **'照片'**
  String get commonPhoto;

  /// No description provided for @commonTakePhoto.
  ///
  /// In zh_TW, this message translates to:
  /// **'拍照'**
  String get commonTakePhoto;

  /// No description provided for @commonPickPhoto.
  ///
  /// In zh_TW, this message translates to:
  /// **'從相簿選擇'**
  String get commonPickPhoto;

  /// No description provided for @commonNoPhoto.
  ///
  /// In zh_TW, this message translates to:
  /// **'無照片'**
  String get commonNoPhoto;

  /// No description provided for @commonAddPhoto.
  ///
  /// In zh_TW, this message translates to:
  /// **'新增照片'**
  String get commonAddPhoto;

  /// No description provided for @beanAddTitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'新增豆子'**
  String get beanAddTitle;

  /// No description provided for @beanEditTitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'編輯豆子'**
  String get beanEditTitle;

  /// No description provided for @beanDeleteConfirm.
  ///
  /// In zh_TW, this message translates to:
  /// **'確定要刪除「{name}」?'**
  String beanDeleteConfirm(String name);

  /// No description provided for @beanFieldRequired.
  ///
  /// In zh_TW, this message translates to:
  /// **'{field}為必填'**
  String beanFieldRequired(String field);

  /// No description provided for @beanUse.
  ///
  /// In zh_TW, this message translates to:
  /// **'使用這支豆子沖煮'**
  String get beanUse;

  /// No description provided for @beanRestDaysShort.
  ///
  /// In zh_TW, this message translates to:
  /// **'養豆 {days} 天'**
  String beanRestDaysShort(int days);

  /// No description provided for @beanUnspecified.
  ///
  /// In zh_TW, this message translates to:
  /// **'未指定豆子'**
  String get beanUnspecified;

  /// No description provided for @beanDeletedTag.
  ///
  /// In zh_TW, this message translates to:
  /// **'已刪除的豆子'**
  String get beanDeletedTag;

  /// No description provided for @beanNoBeans.
  ///
  /// In zh_TW, this message translates to:
  /// **'還沒有任何豆子,從右下角新增第一支'**
  String get beanNoBeans;

  /// No description provided for @beanPickDate.
  ///
  /// In zh_TW, this message translates to:
  /// **'選擇日期'**
  String get beanPickDate;

  /// No description provided for @beanOptional.
  ///
  /// In zh_TW, this message translates to:
  /// **'(選填)'**
  String get beanOptional;

  /// No description provided for @meAddEquipment.
  ///
  /// In zh_TW, this message translates to:
  /// **'新增器材'**
  String get meAddEquipment;

  /// No description provided for @meEquipmentName.
  ///
  /// In zh_TW, this message translates to:
  /// **'名稱'**
  String get meEquipmentName;

  /// No description provided for @meEquipmentNotes.
  ///
  /// In zh_TW, this message translates to:
  /// **'備註'**
  String get meEquipmentNotes;

  /// No description provided for @meEquipmentType.
  ///
  /// In zh_TW, this message translates to:
  /// **'類型'**
  String get meEquipmentType;

  /// No description provided for @meEquipmentTypeGrinder.
  ///
  /// In zh_TW, this message translates to:
  /// **'磨豆機'**
  String get meEquipmentTypeGrinder;

  /// No description provided for @meEquipmentTypeDripper.
  ///
  /// In zh_TW, this message translates to:
  /// **'濾杯'**
  String get meEquipmentTypeDripper;

  /// No description provided for @meEquipmentTypeFilter.
  ///
  /// In zh_TW, this message translates to:
  /// **'濾紙'**
  String get meEquipmentTypeFilter;

  /// No description provided for @meEquipmentTypeKettle.
  ///
  /// In zh_TW, this message translates to:
  /// **'水壺'**
  String get meEquipmentTypeKettle;

  /// No description provided for @meEquipmentTypeScale.
  ///
  /// In zh_TW, this message translates to:
  /// **'電子秤'**
  String get meEquipmentTypeScale;

  /// No description provided for @meEquipmentDeleteConfirm.
  ///
  /// In zh_TW, this message translates to:
  /// **'確定刪除「{name}」?'**
  String meEquipmentDeleteConfirm(String name);

  /// No description provided for @grinderAdd.
  ///
  /// In zh_TW, this message translates to:
  /// **'新增自訂磨豆機'**
  String get grinderAdd;

  /// No description provided for @grinderName.
  ///
  /// In zh_TW, this message translates to:
  /// **'磨豆機名稱'**
  String get grinderName;

  /// No description provided for @grinderUnit.
  ///
  /// In zh_TW, this message translates to:
  /// **'刻度單位'**
  String get grinderUnit;

  /// No description provided for @grinderRange.
  ///
  /// In zh_TW, this message translates to:
  /// **'刻度範圍'**
  String get grinderRange;

  /// No description provided for @grinderStep.
  ///
  /// In zh_TW, this message translates to:
  /// **'最小調整單位'**
  String get grinderStep;

  /// No description provided for @grinderCustomSection.
  ///
  /// In zh_TW, this message translates to:
  /// **'自訂磨豆機'**
  String get grinderCustomSection;

  /// No description provided for @grinderBuiltInSection.
  ///
  /// In zh_TW, this message translates to:
  /// **'內建磨豆機'**
  String get grinderBuiltInSection;

  /// No description provided for @grinderActive.
  ///
  /// In zh_TW, this message translates to:
  /// **'使用中'**
  String get grinderActive;

  /// No description provided for @grinderSetActive.
  ///
  /// In zh_TW, this message translates to:
  /// **'設為使用中'**
  String get grinderSetActive;

  /// No description provided for @grinderDeleteConfirm.
  ///
  /// In zh_TW, this message translates to:
  /// **'確定刪除自訂磨豆機「{name}」?'**
  String grinderDeleteConfirm(String name);

  /// No description provided for @brewSelectBeanHint.
  ///
  /// In zh_TW, this message translates to:
  /// **'選擇一支豆子開始'**
  String get brewSelectBeanHint;

  /// No description provided for @brewNoBeanChoice.
  ///
  /// In zh_TW, this message translates to:
  /// **'不指定豆子(實驗配方)'**
  String get brewNoBeanChoice;

  /// No description provided for @brewMethodPicker.
  ///
  /// In zh_TW, this message translates to:
  /// **'選擇沖煮方式'**
  String get brewMethodPicker;

  /// No description provided for @brewMethodTempNA.
  ///
  /// In zh_TW, this message translates to:
  /// **'N/A'**
  String get brewMethodTempNA;

  /// No description provided for @brewMethodRatio.
  ///
  /// In zh_TW, this message translates to:
  /// **'預設 1:{ratio} · {temp}°C'**
  String brewMethodRatio(String ratio, String temp);

  /// No description provided for @espressoModeHint.
  ///
  /// In zh_TW, this message translates to:
  /// **'espresso 模式:顯示 粉重 / 液重 / 時間,隱藏悶蒸與注水排程'**
  String get espressoModeHint;

  /// No description provided for @espressoDoseLabel.
  ///
  /// In zh_TW, this message translates to:
  /// **'粉重'**
  String get espressoDoseLabel;

  /// No description provided for @espressoBeverageLabel.
  ///
  /// In zh_TW, this message translates to:
  /// **'液重'**
  String get espressoBeverageLabel;

  /// No description provided for @espressoPressureLabel.
  ///
  /// In zh_TW, this message translates to:
  /// **'壓力'**
  String get espressoPressureLabel;

  /// No description provided for @paramGrindSettingFormat.
  ///
  /// In zh_TW, this message translates to:
  /// **'{grinder} · {value} {unit}'**
  String paramGrindSettingFormat(String grinder, String value, String unit);

  /// No description provided for @paramBeverageEst.
  ///
  /// In zh_TW, this message translates to:
  /// **'估算'**
  String get paramBeverageEst;

  /// No description provided for @paramRatioNa.
  ///
  /// In zh_TW, this message translates to:
  /// **'—'**
  String get paramRatioNa;

  /// No description provided for @paramNeedTds.
  ///
  /// In zh_TW, this message translates to:
  /// **'需輸入 TDS'**
  String get paramNeedTds;

  /// No description provided for @paramTdsLow.
  ///
  /// In zh_TW, this message translates to:
  /// **'TDS 偏低'**
  String get paramTdsLow;

  /// No description provided for @paramTdsHigh.
  ///
  /// In zh_TW, this message translates to:
  /// **'TDS 偏高'**
  String get paramTdsHigh;

  /// No description provided for @paramInvalidNumber.
  ///
  /// In zh_TW, this message translates to:
  /// **'數值不合法'**
  String get paramInvalidNumber;

  /// No description provided for @timerResume.
  ///
  /// In zh_TW, this message translates to:
  /// **'繼續'**
  String get timerResume;

  /// No description provided for @timerElapsed.
  ///
  /// In zh_TW, this message translates to:
  /// **'已沖 {time}'**
  String timerElapsed(String time);

  /// No description provided for @timerNextPour.
  ///
  /// In zh_TW, this message translates to:
  /// **'下一段:{label} 目標 {g} g'**
  String timerNextPour(String label, String g);

  /// No description provided for @timerCurrentSection.
  ///
  /// In zh_TW, this message translates to:
  /// **'目前:{label}'**
  String timerCurrentSection(String label);

  /// No description provided for @timerAllDone.
  ///
  /// In zh_TW, this message translates to:
  /// **'完成注水'**
  String get timerAllDone;

  /// No description provided for @timerWakelockOn.
  ///
  /// In zh_TW, this message translates to:
  /// **'螢幕保持開啟'**
  String get timerWakelockOn;

  /// No description provided for @timerWakelockOff.
  ///
  /// In zh_TW, this message translates to:
  /// **'螢幕正常休眠'**
  String get timerWakelockOff;

  /// No description provided for @timerBackgroundAccurate.
  ///
  /// In zh_TW, this message translates to:
  /// **'背景計時(誤差 < 1s)'**
  String get timerBackgroundAccurate;

  /// No description provided for @timerConfirmFinish.
  ///
  /// In zh_TW, this message translates to:
  /// **'確定完成這次沖煮?'**
  String get timerConfirmFinish;

  /// No description provided for @timerSaveDraft.
  ///
  /// In zh_TW, this message translates to:
  /// **'存成草稿'**
  String get timerSaveDraft;

  /// No description provided for @timerStepBloom.
  ///
  /// In zh_TW, this message translates to:
  /// **'悶蒸'**
  String get timerStepBloom;

  /// No description provided for @timerStepMain.
  ///
  /// In zh_TW, this message translates to:
  /// **'主段'**
  String get timerStepMain;

  /// No description provided for @timerStepCustom.
  ///
  /// In zh_TW, this message translates to:
  /// **'注水'**
  String get timerStepCustom;

  /// No description provided for @rateHelperAcidityLow.
  ///
  /// In zh_TW, this message translates to:
  /// **'平淡'**
  String get rateHelperAcidityLow;

  /// No description provided for @rateHelperAcidityMid.
  ///
  /// In zh_TW, this message translates to:
  /// **'中等'**
  String get rateHelperAcidityMid;

  /// No description provided for @rateHelperAcidityHigh.
  ///
  /// In zh_TW, this message translates to:
  /// **'明亮'**
  String get rateHelperAcidityHigh;

  /// No description provided for @rateHelperBitternessLow.
  ///
  /// In zh_TW, this message translates to:
  /// **'溫和'**
  String get rateHelperBitternessLow;

  /// No description provided for @rateHelperBitternessHigh.
  ///
  /// In zh_TW, this message translates to:
  /// **'苦澀'**
  String get rateHelperBitternessHigh;

  /// No description provided for @rateHelperSweetnessLow.
  ///
  /// In zh_TW, this message translates to:
  /// **'薄弱'**
  String get rateHelperSweetnessLow;

  /// No description provided for @rateHelperSweetnessHigh.
  ///
  /// In zh_TW, this message translates to:
  /// **'飽滿'**
  String get rateHelperSweetnessHigh;

  /// No description provided for @rateHelperBodyLow.
  ///
  /// In zh_TW, this message translates to:
  /// **'水感'**
  String get rateHelperBodyLow;

  /// No description provided for @rateHelperBodyHigh.
  ///
  /// In zh_TW, this message translates to:
  /// **'厚實'**
  String get rateHelperBodyHigh;

  /// No description provided for @rateHelperAftertasteShort.
  ///
  /// In zh_TW, this message translates to:
  /// **'短'**
  String get rateHelperAftertasteShort;

  /// No description provided for @rateHelperAftertasteLong.
  ///
  /// In zh_TW, this message translates to:
  /// **'悠長'**
  String get rateHelperAftertasteLong;

  /// No description provided for @rateHelperBalanceOff.
  ///
  /// In zh_TW, this message translates to:
  /// **'失衡'**
  String get rateHelperBalanceOff;

  /// No description provided for @rateHelperBalanceGood.
  ///
  /// In zh_TW, this message translates to:
  /// **'和諧'**
  String get rateHelperBalanceGood;

  /// No description provided for @rateNoFlavor.
  ///
  /// In zh_TW, this message translates to:
  /// **'尚未選風味'**
  String get rateNoFlavor;

  /// No description provided for @rateFlavorSearchHint.
  ///
  /// In zh_TW, this message translates to:
  /// **'搜尋詞彙(中英皆可)'**
  String get rateFlavorSearchHint;

  /// No description provided for @rateFlavorSelected.
  ///
  /// In zh_TW, this message translates to:
  /// **'已選 {count}/8'**
  String rateFlavorSelected(int count);

  /// No description provided for @rateDefectNone.
  ///
  /// In zh_TW, this message translates to:
  /// **'無明顯缺陷'**
  String get rateDefectNone;

  /// No description provided for @rateDefectUnder.
  ///
  /// In zh_TW, this message translates to:
  /// **'萃取不足-尖酸'**
  String get rateDefectUnder;

  /// No description provided for @rateDefectOver.
  ///
  /// In zh_TW, this message translates to:
  /// **'過萃澀感'**
  String get rateDefectOver;

  /// No description provided for @rateDefectWeak.
  ///
  /// In zh_TW, this message translates to:
  /// **'味道太淡'**
  String get rateDefectWeak;

  /// No description provided for @rateDefectStrong.
  ///
  /// In zh_TW, this message translates to:
  /// **'味道太濃'**
  String get rateDefectStrong;

  /// No description provided for @rateDefectOff.
  ///
  /// In zh_TW, this message translates to:
  /// **'雜味'**
  String get rateDefectOff;

  /// No description provided for @rateComplete.
  ///
  /// In zh_TW, this message translates to:
  /// **'完成並看建議'**
  String get rateComplete;

  /// No description provided for @diagHeader.
  ///
  /// In zh_TW, this message translates to:
  /// **'本杯診斷'**
  String get diagHeader;

  /// No description provided for @diagSuccessTitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'🎉 這杯很成功'**
  String get diagSuccessTitle;

  /// No description provided for @diagSuccessDesc.
  ///
  /// In zh_TW, this message translates to:
  /// **'建議存成配方,並重現本次關鍵參數'**
  String get diagSuccessDesc;

  /// No description provided for @diagSuccessKey.
  ///
  /// In zh_TW, this message translates to:
  /// **'本次關鍵參數'**
  String get diagSuccessKey;

  /// No description provided for @diagApply.
  ///
  /// In zh_TW, this message translates to:
  /// **'套用建議並開始下一杯'**
  String get diagApply;

  /// No description provided for @diagSaveRecipe.
  ///
  /// In zh_TW, this message translates to:
  /// **'存成配方'**
  String get diagSaveRecipe;

  /// No description provided for @diagItemPrefix.
  ///
  /// In zh_TW, this message translates to:
  /// **'建議 {n}'**
  String diagItemPrefix(String n);

  /// No description provided for @diagNotEnoughData.
  ///
  /// In zh_TW, this message translates to:
  /// **'資料不足以診斷,請補上風味評分或 TDS'**
  String get diagNotEnoughData;

  /// No description provided for @recipeAddTitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'新增配方'**
  String get recipeAddTitle;

  /// No description provided for @recipeEditTitle.
  ///
  /// In zh_TW, this message translates to:
  /// **'編輯配方'**
  String get recipeEditTitle;

  /// No description provided for @recipeDeleteConfirm.
  ///
  /// In zh_TW, this message translates to:
  /// **'確定刪除配方「{name}」?'**
  String recipeDeleteConfirm(String name);

  /// No description provided for @recipeNoRecipes.
  ///
  /// In zh_TW, this message translates to:
  /// **'還沒有配方'**
  String get recipeNoRecipes;

  /// No description provided for @recipeProLimit.
  ///
  /// In zh_TW, this message translates to:
  /// **'免費版最多 3 組配方'**
  String get recipeProLimit;

  /// No description provided for @recipeApply.
  ///
  /// In zh_TW, this message translates to:
  /// **'套用'**
  String get recipeApply;

  /// No description provided for @recipeFavorite.
  ///
  /// In zh_TW, this message translates to:
  /// **'我的最愛'**
  String get recipeFavorite;

  /// No description provided for @recipePourSchedule.
  ///
  /// In zh_TW, this message translates to:
  /// **'注水排程'**
  String get recipePourSchedule;

  /// No description provided for @recipeAddPourStep.
  ///
  /// In zh_TW, this message translates to:
  /// **'新增注水段'**
  String get recipeAddPourStep;

  /// No description provided for @recipeStepAt.
  ///
  /// In zh_TW, this message translates to:
  /// **'於 {sec} 秒'**
  String recipeStepAt(String sec);

  /// No description provided for @recipeStepCumulative.
  ///
  /// In zh_TW, this message translates to:
  /// **'累計 {g} g'**
  String recipeStepCumulative(String g);

  /// No description provided for @logTotal.
  ///
  /// In zh_TW, this message translates to:
  /// **'共 {count} 杯'**
  String logTotal(int count);

  /// No description provided for @logThisWeek.
  ///
  /// In zh_TW, this message translates to:
  /// **'本週 {count} 杯'**
  String logThisWeek(int count);

  /// No description provided for @logMethodDistribution.
  ///
  /// In zh_TW, this message translates to:
  /// **'常用方式'**
  String get logMethodDistribution;

  /// No description provided for @logCompareSelect2.
  ///
  /// In zh_TW, this message translates to:
  /// **'選 2 筆並列比對'**
  String get logCompareSelect2;

  /// No description provided for @logComparePicked.
  ///
  /// In zh_TW, this message translates to:
  /// **'已選 {n}/2'**
  String logComparePicked(int n);

  /// No description provided for @logCompareSame.
  ///
  /// In zh_TW, this message translates to:
  /// **'相同'**
  String get logCompareSame;

  /// No description provided for @logCompareDiff.
  ///
  /// In zh_TW, this message translates to:
  /// **'差異'**
  String get logCompareDiff;

  /// No description provided for @logBrewControlChart.
  ///
  /// In zh_TW, this message translates to:
  /// **'萃取控制圖'**
  String get logBrewControlChart;

  /// No description provided for @logChartX.
  ///
  /// In zh_TW, this message translates to:
  /// **'萃取率 EY (%)'**
  String get logChartX;

  /// No description provided for @logChartY.
  ///
  /// In zh_TW, this message translates to:
  /// **'濃度 TDS (%)'**
  String get logChartY;

  /// No description provided for @logChartRefZone.
  ///
  /// In zh_TW, this message translates to:
  /// **'參考區間 EY 18–22 / TDS 1.15–1.45'**
  String get logChartRefZone;

  /// No description provided for @logProLocked.
  ///
  /// In zh_TW, this message translates to:
  /// **'Pro 限定功能'**
  String get logProLocked;

  /// No description provided for @logFilterByBean.
  ///
  /// In zh_TW, this message translates to:
  /// **'依豆子篩選'**
  String get logFilterByBean;

  /// No description provided for @logFilterByMethod.
  ///
  /// In zh_TW, this message translates to:
  /// **'依方式篩選'**
  String get logFilterByMethod;

  /// No description provided for @logFilterByRating.
  ///
  /// In zh_TW, this message translates to:
  /// **'依評分篩選'**
  String get logFilterByRating;

  /// No description provided for @logFilterByDate.
  ///
  /// In zh_TW, this message translates to:
  /// **'依日期篩選'**
  String get logFilterByDate;

  /// No description provided for @paywallFeatureBrews.
  ///
  /// In zh_TW, this message translates to:
  /// **'無限筆沖煮記錄'**
  String get paywallFeatureBrews;

  /// No description provided for @paywallFeatureRecipes.
  ///
  /// In zh_TW, this message translates to:
  /// **'無限組配方'**
  String get paywallFeatureRecipes;

  /// No description provided for @paywallFeatureBeans.
  ///
  /// In zh_TW, this message translates to:
  /// **'無限支豆子'**
  String get paywallFeatureBeans;

  /// No description provided for @paywallFeatureDiag.
  ///
  /// In zh_TW, this message translates to:
  /// **'無限次診斷'**
  String get paywallFeatureDiag;

  /// No description provided for @paywallFeatureChart.
  ///
  /// In zh_TW, this message translates to:
  /// **'萃取控制圖'**
  String get paywallFeatureChart;

  /// No description provided for @paywallFeatureCompare.
  ///
  /// In zh_TW, this message translates to:
  /// **'兩筆並列比對'**
  String get paywallFeatureCompare;

  /// No description provided for @paywallFeatureExport.
  ///
  /// In zh_TW, this message translates to:
  /// **'資料匯出(規劃中)'**
  String get paywallFeatureExport;

  /// No description provided for @paywallSubscribe.
  ///
  /// In zh_TW, this message translates to:
  /// **'訂閱 Pro'**
  String get paywallSubscribe;

  /// No description provided for @paywallTermsNote.
  ///
  /// In zh_TW, this message translates to:
  /// **'訂閱將透過 App Store / Google Play 自動續訂,可隨時取消。'**
  String get paywallTermsNote;

  /// No description provided for @disclaimer.
  ///
  /// In zh_TW, this message translates to:
  /// **'本 App 提供的沖煮建議與參考區間僅供參考,實際風味受豆子狀態、器材、水質與個人口味影響。最終以你的味覺為準。'**
  String get disclaimer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
