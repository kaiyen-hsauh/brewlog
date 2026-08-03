// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BrewLog';

  @override
  String get tabBrew => 'Brew';

  @override
  String get tabLog => 'Log';

  @override
  String get tabBeans => 'Beans';

  @override
  String get tabMe => 'Me';

  @override
  String get brewStart => 'Start Brewing';

  @override
  String get brewQuickRepeat => 'Quick repeat last';

  @override
  String get brewNoPrevious => 'No brew yet. Start your first cup here.';

  @override
  String brewTodayCount(int count) {
    return '$count brewed today';
  }

  @override
  String get brewSelectBean => 'Pick a bean';

  @override
  String get brewSelectMethod => 'Pick a method';

  @override
  String get brewSetParams => 'Set parameters';

  @override
  String get brewTimer => 'Brewing timer';

  @override
  String get brewRate => 'Flavor rating';

  @override
  String get brewDiagnosis => 'Diagnosis';

  @override
  String get brewSaveAsRecipe => 'Save as recipe';

  @override
  String get brewApplyAndStartNext => 'Apply and start next cup';

  @override
  String get paramDose => 'Dose';

  @override
  String get paramWater => 'Water';

  @override
  String get paramRatio => 'Ratio';

  @override
  String get paramGrind => 'Grind';

  @override
  String get paramWaterTemp => 'Water temp';

  @override
  String get paramBloomWater => 'Bloom water';

  @override
  String get paramBloomTime => 'Bloom time';

  @override
  String get paramTotalTime => 'Total brew time';

  @override
  String get paramBeverageMass => 'Beverage mass';

  @override
  String get paramTds => 'TDS';

  @override
  String get paramMore => 'More settings';

  @override
  String paramGrams(String value) {
    return '$value g';
  }

  @override
  String paramTempC(String value) {
    return '$value °C';
  }

  @override
  String get timerStart => 'Start';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerReset => 'Reset';

  @override
  String get timerFinish => 'Finish';

  @override
  String timerCurrentWater(String g) {
    return 'Current water $g g';
  }

  @override
  String get timerPourTarget => 'Pour target';

  @override
  String get ratingAcidity => 'Acidity';

  @override
  String get ratingSweetness => 'Sweetness';

  @override
  String get ratingBody => 'Body';

  @override
  String get ratingBitterness => 'Bitterness';

  @override
  String get ratingAftertaste => 'Aftertaste';

  @override
  String get ratingBalance => 'Balance';

  @override
  String get ratingOverall => 'Overall';

  @override
  String get ratingFlavorTags => 'Flavor tags';

  @override
  String get ratingDefects => 'Defects';

  @override
  String get diagnosisOneChangeAtATime =>
      'Adjust only item ① first. Change one variable at a time so you know what affected the flavor.';

  @override
  String get diagnosisYourTasteFirst => 'Your taste comes first.';

  @override
  String get diagnosisSuccess => '🎉 This cup was great. Save it as a recipe.';

  @override
  String get diagnosisNoSuggestion => 'This cup looks good. Keep going.';

  @override
  String get logTitle => 'History';

  @override
  String get logEmpty => 'No brews yet';

  @override
  String get logCompare => 'Compare two';

  @override
  String get logStats => 'Stats';

  @override
  String get logTotalBrews => 'Total brews';

  @override
  String logAvgRating(String n) {
    return 'Avg $n ★';
  }

  @override
  String get logFavoriteMethod => 'Favorite method';

  @override
  String get beanTitle => 'Beans';

  @override
  String get beanAdd => 'Add bean';

  @override
  String get beanName => 'Name';

  @override
  String get beanRoaster => 'Roaster';

  @override
  String get beanOrigin => 'Origin';

  @override
  String get beanFarm => 'Farm';

  @override
  String get beanVariety => 'Variety';

  @override
  String get beanProcessing => 'Processing';

  @override
  String get beanRoastLevel => 'Roast level';

  @override
  String get beanRoastDate => 'Roast date';

  @override
  String get beanPurchaseDate => 'Purchase date';

  @override
  String get beanWeight => 'Weight';

  @override
  String get beanPrice => 'Price';

  @override
  String get beanAltitude => 'Altitude';

  @override
  String get beanRestDays => 'Rest days';

  @override
  String get beanRestHintRef => 'Depends on roast and storage';

  @override
  String get beanRestHint0to3 => 'Active degassing — flavor not stable';

  @override
  String get beanRestHint4to14 => 'Optimal';

  @override
  String get beanRestHint15to30 => 'Stable';

  @override
  String get beanRestHintOver30 => 'Flavor may be fading';

  @override
  String get beanRestHintInvalid => 'Invalid roast date';

  @override
  String get meTitle => 'Me';

  @override
  String get meEquipment => 'Equipment';

  @override
  String get meGrinder => 'Grinder';

  @override
  String get meDripper => 'Dripper';

  @override
  String get meFilter => 'Filter';

  @override
  String get meKettle => 'Kettle';

  @override
  String get meScale => 'Scale';

  @override
  String get meLanguage => 'Language';

  @override
  String get meSettings => 'Settings';

  @override
  String get meSubscription => 'Subscription';

  @override
  String get meAbout => 'About';

  @override
  String get mePrivacyPolicy => 'Privacy policy';

  @override
  String get meTermsOfService => 'Terms of service';

  @override
  String get meLangZh => '繁體中文';

  @override
  String get meLangEn => 'English';

  @override
  String get paywallTitle => 'Upgrade to BrewLog Pro';

  @override
  String get paywallSubtitle =>
      'Unlimited diagnosis, recipes, history compare, and brew control chart';

  @override
  String get paywallMonthly => 'Monthly NT\$99';

  @override
  String get paywallYearly => 'Yearly NT\$690 (save 42%)';

  @override
  String get paywallLifetime => 'Lifetime NT\$1,290';

  @override
  String get paywallRestore => 'Restore purchase';

  @override
  String get paywallLimitBrew => 'Free tier limit of 30 brews reached';

  @override
  String get paywallLimitRecipe => 'Free tier limit of 3 recipes reached';

  @override
  String get paywallLimitBean => 'Free tier limit of 5 beans reached';

  @override
  String get paywallLimitDiagnosis => 'Weekly diagnosis limit reached';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonUnitGrams => 'g';

  @override
  String get commonUnitCelsius => '°C';

  @override
  String get commonUnitPercent => '%';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonSelect => 'Select';

  @override
  String get commonDate => 'Date';

  @override
  String get commonRequired => 'Required';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonAll => 'All';

  @override
  String get commonFilter => 'Filter';

  @override
  String get commonSort => 'Sort';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonError => 'Error';

  @override
  String get commonEmpty => 'Empty';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonOk => 'OK';

  @override
  String get commonMore => 'More';

  @override
  String get commonActions => 'Actions';

  @override
  String get commonDuplicated => 'Copied';

  @override
  String get commonShowMore => 'Show more';

  @override
  String get commonShowLess => 'Show less';

  @override
  String get commonPercent => '%';

  @override
  String get commonSeconds => 's';

  @override
  String get commonMinutes => 'm';

  @override
  String get commonToday => 'Today';

  @override
  String get commonThisWeek => 'This week';

  @override
  String get commonThisMonth => 'This month';

  @override
  String get commonDraft => 'Draft';

  @override
  String get commonResume => 'Resume brew';

  @override
  String get commonSavedAsDraft => 'Saved as draft';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonClose => 'Close';

  @override
  String get commonTodayCountUnit => 'brews';

  @override
  String get commonRatio => 'Ratio';

  @override
  String get commonTemp => 'Temp';

  @override
  String get commonTime => 'Time';

  @override
  String get commonNote => 'Notes';

  @override
  String get commonPhoto => 'Photo';

  @override
  String get commonTakePhoto => 'Take photo';

  @override
  String get commonPickPhoto => 'Pick from album';

  @override
  String get commonNoPhoto => 'No photo';

  @override
  String get commonAddPhoto => 'Add photo';

  @override
  String get beanAddTitle => 'Add bean';

  @override
  String get beanEditTitle => 'Edit bean';

  @override
  String beanDeleteConfirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String beanFieldRequired(String field) {
    return '$field is required';
  }

  @override
  String get beanUse => 'Use this bean to brew';

  @override
  String beanRestDaysShort(int days) {
    return '$days days rest';
  }

  @override
  String get beanUnspecified => 'Unspecified bean';

  @override
  String get beanDeletedTag => 'Deleted bean';

  @override
  String get beanNoBeans => 'No beans yet. Tap + to add the first one.';

  @override
  String get beanPickDate => 'Pick date';

  @override
  String get beanOptional => '(optional)';

  @override
  String get meAddEquipment => 'Add equipment';

  @override
  String get meEquipmentName => 'Name';

  @override
  String get meEquipmentNotes => 'Notes';

  @override
  String get meEquipmentType => 'Type';

  @override
  String get meEquipmentTypeGrinder => 'Grinder';

  @override
  String get meEquipmentTypeDripper => 'Dripper';

  @override
  String get meEquipmentTypeFilter => 'Filter';

  @override
  String get meEquipmentTypeKettle => 'Kettle';

  @override
  String get meEquipmentTypeScale => 'Scale';

  @override
  String meEquipmentDeleteConfirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get grinderAdd => 'Add custom grinder';

  @override
  String get grinderName => 'Grinder name';

  @override
  String get grinderUnit => 'Unit label';

  @override
  String get grinderRange => 'Setting range';

  @override
  String get grinderStep => 'Min step';

  @override
  String get grinderCustomSection => 'Custom grinders';

  @override
  String get grinderBuiltInSection => 'Built-in grinders';

  @override
  String get grinderActive => 'Active';

  @override
  String get grinderSetActive => 'Set as active';

  @override
  String grinderDeleteConfirm(String name) {
    return 'Delete custom grinder \"$name\"?';
  }

  @override
  String get brewSelectBeanHint => 'Pick a bean to start';

  @override
  String get brewNoBeanChoice => 'No bean (test recipe)';

  @override
  String get brewMethodPicker => 'Pick a brew method';

  @override
  String get brewMethodTempNA => 'N/A';

  @override
  String brewMethodRatio(String ratio, String temp) {
    return 'Default 1:$ratio · $temp°C';
  }

  @override
  String get espressoModeHint =>
      'Espresso mode: dose / beverage / time, hide bloom and pour schedule';

  @override
  String get espressoDoseLabel => 'Dose';

  @override
  String get espressoBeverageLabel => 'Beverage';

  @override
  String get espressoPressureLabel => 'Pressure';

  @override
  String paramGrindSettingFormat(String grinder, String value, String unit) {
    return '$grinder · $value $unit';
  }

  @override
  String get paramBeverageEst => 'est';

  @override
  String get paramRatioNa => '—';

  @override
  String get paramNeedTds => 'TDS required';

  @override
  String get paramTdsLow => 'TDS too low';

  @override
  String get paramTdsHigh => 'TDS too high';

  @override
  String get paramInvalidNumber => 'Invalid number';

  @override
  String get timerResume => 'Resume';

  @override
  String timerElapsed(String time) {
    return 'Brewed $time';
  }

  @override
  String timerNextPour(String label, String g) {
    return 'Next: $label target $g g';
  }

  @override
  String timerCurrentSection(String label) {
    return 'Current: $label';
  }

  @override
  String get timerAllDone => 'Pour complete';

  @override
  String get timerWakelockOn => 'Screen kept awake';

  @override
  String get timerWakelockOff => 'Screen sleeps normally';

  @override
  String get timerBackgroundAccurate => 'Background-accurate timer';

  @override
  String get timerConfirmFinish => 'Finish this brew?';

  @override
  String get timerSaveDraft => 'Save as draft';

  @override
  String get timerStepBloom => 'Bloom';

  @override
  String get timerStepMain => 'Main';

  @override
  String get timerStepCustom => 'Pour';

  @override
  String get rateHelperAcidityLow => 'Flat';

  @override
  String get rateHelperAcidityMid => 'Medium';

  @override
  String get rateHelperAcidityHigh => 'Bright';

  @override
  String get rateHelperBitternessLow => 'Mild';

  @override
  String get rateHelperBitternessHigh => 'Astringent';

  @override
  String get rateHelperSweetnessLow => 'Weak';

  @override
  String get rateHelperSweetnessHigh => 'Full';

  @override
  String get rateHelperBodyLow => 'Watery';

  @override
  String get rateHelperBodyHigh => 'Heavy';

  @override
  String get rateHelperAftertasteShort => 'Short';

  @override
  String get rateHelperAftertasteLong => 'Long';

  @override
  String get rateHelperBalanceOff => 'Off';

  @override
  String get rateHelperBalanceGood => 'Harmonious';

  @override
  String get rateNoFlavor => 'No flavor picked';

  @override
  String get rateFlavorSearchHint => 'Search (EN/ZH)';

  @override
  String rateFlavorSelected(int count) {
    return '$count/8 picked';
  }

  @override
  String get rateDefectNone => 'No defect';

  @override
  String get rateDefectUnder => 'Under-extracted';

  @override
  String get rateDefectOver => 'Over-extracted';

  @override
  String get rateDefectWeak => 'Too weak';

  @override
  String get rateDefectStrong => 'Too strong';

  @override
  String get rateDefectOff => 'Off-flavor';

  @override
  String get rateComplete => 'Complete & see diagnosis';

  @override
  String get diagHeader => 'Diagnosis for this cup';

  @override
  String get diagSuccessTitle => '🎉 This cup was great';

  @override
  String get diagSuccessDesc => 'Save as recipe and reuse the key parameters';

  @override
  String get diagSuccessKey => 'Key parameters';

  @override
  String get diagApply => 'Apply & start next cup';

  @override
  String get diagSaveRecipe => 'Save as recipe';

  @override
  String diagItemPrefix(String n) {
    return 'Tip $n';
  }

  @override
  String get diagNotEnoughData => 'Not enough data. Add rating or TDS.';

  @override
  String get recipeAddTitle => 'Add recipe';

  @override
  String get recipeEditTitle => 'Edit recipe';

  @override
  String recipeDeleteConfirm(String name) {
    return 'Delete recipe \"$name\"?';
  }

  @override
  String get recipeNoRecipes => 'No recipes yet';

  @override
  String get recipeProLimit => 'Free tier: max 3 recipes';

  @override
  String get recipeApply => 'Apply';

  @override
  String get recipeFavorite => 'Favorite';

  @override
  String get recipePourSchedule => 'Pour schedule';

  @override
  String get recipeAddPourStep => 'Add pour step';

  @override
  String recipeStepAt(String sec) {
    return 'at $sec s';
  }

  @override
  String recipeStepCumulative(String g) {
    return 'cumulative $g g';
  }

  @override
  String logTotal(int count) {
    return '$count brews total';
  }

  @override
  String logThisWeek(int count) {
    return '$count this week';
  }

  @override
  String get logMethodDistribution => 'Method distribution';

  @override
  String get logCompareSelect2 => 'Pick 2 to compare';

  @override
  String logComparePicked(int n) {
    return '$n/2 picked';
  }

  @override
  String get logCompareSame => 'Same';

  @override
  String get logCompareDiff => 'Diff';

  @override
  String get logBrewControlChart => 'Brew control chart';

  @override
  String get logChartX => 'EY (%)';

  @override
  String get logChartY => 'TDS (%)';

  @override
  String get logChartRefZone => 'Ref zone: EY 18–22 / TDS 1.15–1.45';

  @override
  String get logProLocked => 'Pro only';

  @override
  String get logFilterByBean => 'Filter by bean';

  @override
  String get logFilterByMethod => 'Filter by method';

  @override
  String get logFilterByRating => 'Filter by rating';

  @override
  String get logFilterByDate => 'Filter by date';

  @override
  String get paywallFeatureBrews => 'Unlimited brews';

  @override
  String get paywallFeatureRecipes => 'Unlimited recipes';

  @override
  String get paywallFeatureBeans => 'Unlimited beans';

  @override
  String get paywallFeatureDiag => 'Unlimited diagnosis';

  @override
  String get paywallFeatureChart => 'Brew control chart';

  @override
  String get paywallFeatureCompare => 'Side-by-side compare';

  @override
  String get paywallFeatureExport => 'Export (planned)';

  @override
  String get paywallSubscribe => 'Subscribe to Pro';

  @override
  String get paywallTermsNote =>
      'Subscription auto-renews via App Store / Google Play. Cancel anytime.';

  @override
  String get disclaimer =>
      'Brewing suggestions and reference ranges are for guidance only. Actual flavor depends on bean condition, gear, water, and personal taste. Your taste comes first.';
}
