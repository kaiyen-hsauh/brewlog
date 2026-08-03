// S4:F3 風味評分
// §F3.1 六維 1–10 滑桿(預設 5)
// §F3.2 總體 1–5 星
// §F3.3 風味標籤(§6.5 自有 8 大類),上限 8
// §F3.4 缺陷快選
// §F3.5 未評分可儲存
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brewlog/core/theme/brew_theme.dart';
import 'package:brewlog/core/constants/flavor_taxonomy.dart';
import 'package:brewlog/application/providers/providers.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/l10n/gen/app_localizations.dart';
import 'package:brewlog/presentation/screens/brew/diagnosis_screen.dart';

class RatingScreen extends ConsumerStatefulWidget {
  final Brew draft;
  const RatingScreen({super.key, required this.draft});
  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  late double _acidity;
  late double _sweetness;
  late double _body;
  late double _bitterness;
  late double _aftertaste;
  late double _balance;
  late double _overall;
  final Set<String> _flavors = {};
  final Set<String> _defects = {};
  final _notesC = TextEditingController();

  @override
  void initState() {
    super.initState();
    final d = widget.draft;
    _acidity = d.acidity ?? 5;
    _sweetness = d.sweetness ?? 5;
    _body = d.body ?? 5;
    _bitterness = d.bitterness ?? 5;
    _aftertaste = d.aftertaste ?? 5;
    _balance = d.balance ?? 5;
    _overall = d.overallRating ?? 3;
    _flavors.addAll(d.flavorTags);
    _defects.addAll(d.defects);
    _notesC.text = d.notes ?? '';
  }

  @override
  void dispose() {
    _notesC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.brewRate)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(l.ratingFlavorTags, '${_flavors.length}/8'),
          const SizedBox(height: 8),
          _flavorPicker(l),
          const SizedBox(height: 24),
          _sectionTitle(l.brewRate, ''),
          const SizedBox(height: 8),
          _dimSlider(l.ratingAcidity, _acidity, 1, 10, (v) => setState(() => _acidity = v),
              low: l.rateHelperAcidityLow, mid: l.rateHelperAcidityMid, high: l.rateHelperAcidityHigh),
          _dimSlider(l.ratingSweetness, _sweetness, 1, 10, (v) => setState(() => _sweetness = v),
              low: l.rateHelperSweetnessLow, high: l.rateHelperSweetnessHigh),
          _dimSlider(l.ratingBody, _body, 1, 10, (v) => setState(() => _body = v),
              low: l.rateHelperBodyLow, high: l.rateHelperBodyHigh),
          _dimSlider(l.ratingBitterness, _bitterness, 1, 10, (v) => setState(() => _bitterness = v),
              low: l.rateHelperBitternessLow, high: l.rateHelperBitternessHigh),
          _dimSlider(l.ratingAftertaste, _aftertaste, 1, 10, (v) => setState(() => _aftertaste = v),
              low: l.rateHelperAftertasteShort, high: l.rateHelperAftertasteLong),
          _dimSlider(l.ratingBalance, _balance, 1, 10, (v) => setState(() => _balance = v),
              low: l.rateHelperBalanceOff, high: l.rateHelperBalanceGood),
          const SizedBox(height: 12),
          _starRow(l.ratingOverall, _overall, (v) => setState(() => _overall = v)),
          const SizedBox(height: 24),
          _sectionTitle(l.ratingDefects, ''),
          const SizedBox(height: 8),
          _defectChips(l),
          const SizedBox(height: 24),
          TextField(
            controller: _notesC,
            maxLines: 3,
            decoration: InputDecoration(labelText: l.commonNote),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _complete,
              style: ElevatedButton.styleFrom(
                  backgroundColor: BrewColors.primary,
                  foregroundColor: Colors.white),
              child: Text(l.rateComplete,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, String right) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          if (right.isNotEmpty)
            Text(right, style: const TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      );

  Widget _dimSlider(
    String label,
    double v,
    double min,
    double max,
    ValueChanged<double> onChanged, {
    String? low,
    String? mid,
    String? high,
  }) {
    String helper = '';
    if (v <= 3) {
      helper = low ?? '';
    } else if (v >= 7) {
      helper = high ?? '';
    } else {
      helper = mid ?? '';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 72,
              child: Text(label, style: const TextStyle(fontSize: 14))),
          Expanded(
            child: Slider(
              value: v,
              min: min,
              max: max,
              divisions: (max - min).toInt(),
              label: v.toStringAsFixed(0),
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              '${v.toStringAsFixed(0)} · $helper',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _starRow(String label, double v, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(width: 72, child: Text(label)),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final filled = (i + 1) <= v;
              final half = !filled && (i + 0.5) <= v;
              return Semantics(
                label: '${i + 1} 星',
                button: true,
                child: IconButton(
                  tooltip: '${i + 1} 星',
                  onPressed: () {
                    if (v == i + 1) {
                      onChanged(i + 0.5);
                    } else {
                      onChanged((i + 1).toDouble());
                    }
                  },
                  icon: Icon(
                    half
                        ? Icons.star_half
                        : (filled ? Icons.star : Icons.star_border),
                    color: Colors.amber,
                    size: 32,
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(
            width: 32,
            child: Text(v.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w600))),
      ],
    );
  }

  Widget _flavorPicker(AppLocalizations l) {
    final queryC = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: queryC,
          decoration: InputDecoration(
            hintText: l.rateFlavorSearchHint,
            prefixIcon: const Icon(Icons.search, size: 18),
            isDense: true,
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        for (final cat in FlavorTaxonomy.categories)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cat.zh,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: cat.children.map((it) {
                    final sel = _flavors.contains(it.id);
                    if (queryC.text.isNotEmpty &&
                        !it.zh.contains(queryC.text) &&
                        !it.en.toLowerCase().contains(queryC.text.toLowerCase())) {
                      return const SizedBox.shrink();
                    }
                    return FilterChip(
                      label: Text(it.zh, style: const TextStyle(fontSize: 12)),
                      selected: sel,
                      onSelected: (v) {
                        if (v && _flavors.length >= 8) {
                          // §F3.3 MUST 上限 8 個,給使用者回饋
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(milliseconds: 1500),
                              content: Text('最多選 8 個風味標籤'),
                            ),
                          );
                          return;
                        }
                        setState(() {
                          if (v) {
                            _flavors.add(it.id);
                          } else {
                            _flavors.remove(it.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _defectChips(AppLocalizations l) {
    final labels = {
      BrewDefect.underExtracted: l.rateDefectUnder,
      BrewDefect.overExtracted: l.rateDefectOver,
      BrewDefect.tooWeak: l.rateDefectWeak,
      BrewDefect.tooStrong: l.rateDefectStrong,
      BrewDefect.offFlavor: l.rateDefectOff,
      BrewDefect.noDefect: l.rateDefectNone,
    };
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: labels.entries.map((e) {
        final sel = _defects.contains(e.key);
        return FilterChip(
          label: Text(e.value, style: const TextStyle(fontSize: 12)),
          selected: sel,
          selectedColor: BrewColors.warning.withValues(alpha: 0.3),
          onSelected: (v) {
            setState(() {
              if (v) {
                _defects.add(e.key);
              } else {
                _defects.remove(e.key);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Future<void> _complete() async {
    // §F3.5 評分可選,但若使用者填了整體,才寫入
    final updated = widget.draft.copyWith(
      acidity: _acidity,
      sweetness: _sweetness,
      body: _body,
      bitterness: _bitterness,
      aftertaste: _aftertaste,
      balance: _balance,
      overallRating: _overall == 0 ? null : _overall,
      flavorTags: _flavors.toList(),
      defects: _defects.toList(),
      notes: _notesC.text.trim().isEmpty ? null : _notesC.text.trim(),
      updatedAt: DateTime.now(),
    );
    // 儲存
    await ref.read(brewsProvider.notifier).save(updated);
    if (!mounted) return;
    // 進診斷頁
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DiagnosisScreen(brew: updated),
      ),
    );
  }
}
