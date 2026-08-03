// S5:F7 診斷結果頁
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brewlog/core/theme/brew_theme.dart';
import 'package:brewlog/core/constants/grinders.dart';
import 'package:brewlog/application/providers/providers.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/domain/services/diagnosis_engine.dart';
import 'package:brewlog/l10n/gen/app_localizations.dart';
import 'package:brewlog/presentation/screens/brew/brew_form_screen.dart';

class DiagnosisScreen extends ConsumerWidget {
  final Brew brew;
  const DiagnosisScreen({super.key, required this.brew});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final beansAsync = ref.watch(beansProvider);
    final grinder = GrinderCatalog.instance.byId(brew.grinderId);
    final unit = grinder?.unitLabelZh ?? '格';
    final bean = beansAsync.value
        ?.where((b) => b.id == brew.beanId)
        .firstOrNull;
    final suggestions = DiagnosisEngine.diagnose(
      brew,
      bean: bean,
      grindUnit: unit,
    );
    final isSuccess =
        suggestions.isNotEmpty && suggestions.first.kind == DiagKind.success;

    return Scaffold(
      appBar: AppBar(title: Text(l.diagHeader)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 結論
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (isSuccess ? BrewColors.success : BrewColors.accent)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  isSuccess ? Icons.celebration : Icons.lightbulb_outline,
                  color: isSuccess ? BrewColors.success : BrewColors.accent,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isSuccess ? l.diagSuccessTitle : _summary(suggestions),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (isSuccess) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.diagSuccessDesc,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    _kv('粉水比', brew.ratioDisplay),
                    _kv(
                      '研磨',
                      brew.grindSetting != null
                          ? '${brew.grindSetting} $unit'
                          : '—',
                    ),
                    _kv(
                      '水溫',
                      brew.waterTempC != null
                          ? '${brew.waterTempC!.toStringAsFixed(0)}°C'
                          : '—',
                    ),
                    _kv(
                      '總時間',
                      brew.totalBrewSeconds != null
                          ? '${brew.totalBrewSeconds! ~/ 60}:${(brew.totalBrewSeconds! % 60).toString().padLeft(2, '0')}'
                          : '—',
                    ),
                    if (brew.extractionYield != null)
                      _kv(
                        'EY',
                        '${brew.extractionYield!.eyPercent.toStringAsFixed(1)}%',
                      ),
                  ],
                ),
              ),
            ),
          ] else
            for (final s in suggestions.take(3))
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: s.isPrimary
                            ? BrewColors.accent
                            : BrewColors.secondary,
                        child: Text(
                          s.order.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          s.text,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: 8),
          if (!isSuccess)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BrewColors.warning.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: BrewColors.warning,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l.diagnosisOneChangeAtATime,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _saveAsRecipe(context, ref),
                  icon: const Icon(Icons.bookmark_add_outlined),
                  label: Text(l.diagSaveRecipe),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            BrewFormScreen(initial: brew.duplicate()),
                      ),
                    );
                  },
                  icon: const Icon(Icons.replay),
                  label: Text(l.diagApply),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: BrewColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (r) => r.isFirst);
            },
            child: const Text('回首頁'),
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(k, style: const TextStyle(color: Colors.black54)),
        ),
        Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );

  String _summary(List<Suggestion> ss) {
    if (ss.isEmpty) return '需要更多資料';
    switch (ss.first.kind) {
      case DiagKind.underExtraction:
        return '這杯萃取略微不足';
      case DiagKind.overExtraction:
        return '這杯略微過萃';
      case DiagKind.weak:
        return '濃度偏低';
      case DiagKind.strong:
        return '濃度偏高';
      case DiagKind.eyLow:
        return '萃取率偏低';
      case DiagKind.eyHigh:
        return '萃取率偏高';
      case DiagKind.microTweak:
        return '可以微調';
      default:
        return '看起來不錯';
    }
  }

  Future<void> _saveAsRecipe(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final nameC = TextEditingController(
      text: '${l.brewStart} ${DateTime.now().month}/${DateTime.now().day}',
    );
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.diagSaveRecipe),
        content: TextField(
          controller: nameC,
          decoration: const InputDecoration(labelText: '配方名稱'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.commonSave),
          ),
        ],
      ),
    );
    final name = nameC.text.trim();
    nameC.dispose(); // §F8.1 避免 controller leak
    if (ok != true) return;
    final recipe = Recipe(
      id: genId(),
      name: name,
      brewMethodId: brew.brewMethodId,
      ratioDenominator: brew.waterGrams / brew.doseGrams,
      grindSetting: brew.grindSetting,
      grinderId: brew.grinderId,
      waterTempC: brew.waterTempC,
      bloomWaterGrams: brew.bloomWaterGrams,
      bloomSeconds: brew.bloomSeconds,
      pourSchedule: brew.pourSchedule,
      isFavorite: true,
      createdAt: DateTime.now(),
    );
    await ref.read(recipesProvider.notifier).save(recipe);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已存成配方')));
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
