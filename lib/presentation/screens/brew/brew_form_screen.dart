// S2:F1 沖煮記錄 CRUD 參數設定頁
// §9.4 S2 規格:豆子 → 沖煮方式 → 設定參數 → 計時 → 評分 → 診斷
// §F1.1 必填 / §F1.2 選填(漸進揭露),§F4 萃取計算即時
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brewlog/core/theme/brew_theme.dart';
import 'package:brewlog/application/providers/providers.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/l10n/gen/app_localizations.dart';
import 'package:brewlog/presentation/screens/brew/timer_screen.dart';

class BrewFormScreen extends ConsumerStatefulWidget {
  /// 從既有 brew 帶入參數(編輯/複製用)
  final Brew? initial;
  final Bean? presetBean;
  final Recipe? presetRecipe;
  const BrewFormScreen({
    super.key,
    this.initial,
    this.presetBean,
    this.presetRecipe,
  });
  @override
  ConsumerState<BrewFormScreen> createState() => _BrewFormScreenState();
}

class _BrewFormScreenState extends ConsumerState<BrewFormScreen> {
  final _doseC = TextEditingController();
  final _waterC = TextEditingController();
  final _grindC = TextEditingController();
  final _tempC = TextEditingController();
  final _bloomWC = TextEditingController();
  final _bloomSC = TextEditingController();
  final _beverageC = TextEditingController();
  final _tdsC = TextEditingController();
  final _notesC = TextEditingController();
  final _filterC = TextEditingController();

  String? _beanId;
  String _methodId = 'v60';
  String? _grinderId;
  bool _moreOpen = false;
  String? _errDose;
  String? _errWater;

  @override
  void initState() {
    super.initState();
    final b = widget.initial;
    if (b != null) {
      _beanId = widget.presetBean?.id ?? b.beanId;
      _methodId = widget.presetRecipe?.brewMethodId ?? b.brewMethodId;
      _grinderId = widget.presetRecipe?.grinderId ?? b.grinderId;
      _doseC.text = b.doseGrams > 0 ? b.doseGrams.toString() : '';
      _waterC.text = b.waterGrams > 0 ? b.waterGrams.toString() : '';
      _grindC.text = b.grindSetting?.toString() ?? '';
      _tempC.text = b.waterTempC?.toString() ?? '';
      _bloomWC.text = b.bloomWaterGrams?.toString() ?? '';
      _bloomSC.text = b.bloomSeconds?.toString() ?? '';
      _beverageC.text = b.beverageMassGrams?.toString() ?? '';
      _tdsC.text = b.tdsPercent?.toString() ?? '';
      _notesC.text = b.notes ?? '';
      _filterC.text = b.filterType ?? '';
    } else {
      _beanId = widget.presetBean?.id;
      _methodId = widget.presetRecipe?.brewMethodId ?? 'v60';
      _grinderId = widget.presetRecipe?.grinderId;
    }
    if (widget.presetBean != null) _beanId = widget.presetBean!.id;
  }

  @override
  void dispose() {
    for (final c in [
      _doseC,
      _waterC,
      _grindC,
      _tempC,
      _bloomWC,
      _bloomSC,
      _beverageC,
      _tdsC,
      _notesC,
      _filterC,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double get _dose => double.tryParse(_doseC.text) ?? 0;
  double get _water => double.tryParse(_waterC.text) ?? 0;
  double? get _grind => double.tryParse(_grindC.text);
  double? get _temp => double.tryParse(_tempC.text);
  double? get _tds => double.tryParse(_tdsC.text);
  double? get _beverage => double.tryParse(_beverageC.text);
  int? get _bloomS => int.tryParse(_bloomSC.text);
  double? get _bloomW => double.tryParse(_bloomWC.text);

  String get _ratioDisplay {
    if (_dose <= 0) return '—';
    return '1:${(_water / _dose).toStringAsFixed(1)}';
  }

  ExtractionYield? get _ey {
    if (_dose <= 0) return null;
    if (_tds == null) return null;
    final mass = _beverage ?? (_water - _dose * 2.0);
    return ExtractionYield(
      eyPercent: (_tds! * mass) / _dose,
      isEstimatedMass: _beverage == null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final method = ref.watch(brewMethodCatalogProvider).byId(_methodId);
    final beansAsync = ref.watch(beansProvider);
    final isEspresso = method.isEspresso;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initial == null ? l.brewStart : l.commonEdit),
        actions: [
          if (widget.initial != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l.commonDelete,
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 豆子
          Text(
            l.brewSelectBean,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          beansAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (beans) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l.beanUnspecified),
                  selected: _beanId == null,
                  onSelected: (_) => setState(() => _beanId = null),
                ),
                ...beans.map(
                  (b) => ChoiceChip(
                    label: Text(b.name),
                    selected: _beanId == b.id,
                    onSelected: (_) => setState(() => _beanId = b.id),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 沖煮方式
          Text(
            l.brewSelectMethod,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 96,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ref.watch(brewMethodCatalogProvider).all.map((m) {
                final sel = m.id == _methodId;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    selected: sel,
                    label: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            m.nameZh,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '1:${m.defaultRatioDenominator.toStringAsFixed(0)} · '
                            '${m.defaultWaterTempC == 0 ? l.brewMethodTempNA : '${m.defaultWaterTempC}°C'}',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    onSelected: (_) => setState(() => _methodId = m.id),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // 粉重 / 水重(必填) + 粉水比即時
          Row(
            children: [
              Expanded(
                child: _numField(
                  controller: _doseC,
                  label: l.paramDose,
                  unit: l.commonUnitGrams,
                  required: true,
                  error: _errDose,
                  onChanged: (_) => setState(() => _errDose = null),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _numField(
                  controller: _waterC,
                  label: l.paramWater,
                  unit: l.commonUnitGrams,
                  required: true,
                  error: _errWater,
                  onChanged: (_) => setState(() => _errWater = null),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 粉水比即時(§S2 規格)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: BrewColors.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.scale, size: 18),
                const SizedBox(width: 6),
                Text(
                  '${l.paramRatio} $_ratioDisplay',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                if (_ey != null) _eyChip(_ey!),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 更多設定(漸進揭露 §9.4)
          ExpansionTile(
            title: Text(l.paramMore),
            initiallyExpanded: _moreOpen,
            onExpansionChanged: (v) => setState(() => _moreOpen = v),
            children: [
              const SizedBox(height: 4),
              if (isEspresso)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: BrewColors.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l.espressoModeHint,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              _grinderPicker(),
              const SizedBox(height: 8),
              _numField(
                controller: _tempC,
                label: l.paramWaterTemp,
                unit: l.commonUnitCelsius,
                hint: isEspresso
                    ? null
                    : '${method.defaultWaterTempC == 0 ? '' : method.defaultWaterTempC.toString()}',
              ),
              const SizedBox(height: 8),
              if (!isEspresso) ...[
                Row(
                  children: [
                    Expanded(
                      child: _numField(
                        controller: _bloomWC,
                        label: l.paramBloomWater,
                        unit: l.commonUnitGrams,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _numField(
                        controller: _bloomSC,
                        label: l.paramBloomTime,
                        unit: l.commonSeconds,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              _numField(
                controller: _beverageC,
                label: l.paramBeverageMass,
                unit: l.commonUnitGrams,
              ),
              const SizedBox(height: 8),
              _numField(
                controller: _tdsC,
                label: l.paramTds,
                unit: l.commonUnitPercent,
              ),
              const SizedBox(height: 8),
              _textField(
                controller: _filterC,
                label: l.paramGrind,
                hint: 'e.g. V60 漂白濾紙',
              ),
              const SizedBox(height: 8),
              _textField(controller: _notesC, label: l.commonNote, maxLines: 3),
            ],
          ),
          const SizedBox(height: 16),

          // 開始沖煮 CTA → 計時器
          SizedBox(
            height: 56,
            child: Semantics(
              label: '開始沖煮計時',
              button: true,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow, size: 28),
                label: const Text('開始計時', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: BrewColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: _startTimer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eyChip(ExtractionYield ey) {
    final l = AppLocalizations.of(context)!;
    final ok = ey.eyPercent >= 18 && ey.eyPercent <= 22;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: (ok ? BrewColors.success : BrewColors.warning).withValues(
          alpha: 0.15,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'EY ${ey.eyPercent.toStringAsFixed(1)}%${ey.isEstimatedMass ? ' (${l.paramBeverageEst})' : ''}',
        style: TextStyle(
          fontSize: 12,
          color: ok ? BrewColors.success : BrewColors.warning,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _grinderPicker() {
    final l = AppLocalizations.of(context)!;
    final catalog = ref.watch(grinderCatalogProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        initialValue: _grinderId,
        decoration: InputDecoration(
          labelText: l.paramGrind,
          suffixIcon: _grinderId == null
              ? null
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    width: 60,
                    child: TextField(
                      controller: _grindC,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: catalog.byId(_grinderId)?.unitLabelZh ?? '0',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ),
        ),
        items: catalog.all
            .map(
              (g) => DropdownMenuItem(
                value: g.id,
                child: Text(
                  '${g.name} · ${g.minSetting.toInt()}-${g.maxSetting.toInt()} ${g.unitLabelZh}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() {
          _grinderId = v;
          _grindC.clear();
        }),
      ),
    );
  }

  Widget _numField({
    required TextEditingController controller,
    required String label,
    required String unit,
    String? hint,
    bool required = false,
    String? error,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          hintText: hint,
          suffixText: unit,
          errorText: error,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, hintText: hint),
      ),
    );
  }

  Future<void> _startTimer() async {
    final l = AppLocalizations.of(context)!;
    if (_dose <= 0) {
      setState(() => _errDose = l.paramInvalidNumber);
      return;
    }
    if (_water <= 0) {
      setState(() => _errWater = l.paramInvalidNumber);
      return;
    }
    final method = ref.read(brewMethodCatalogProvider).byId(_methodId);
    final draft = _buildBrew();
    // 進計時器(§F2 計時器由 S3 完整實作;此處傳 draft)
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TimerScreen(draft: draft, method: method),
      ),
    );
  }

  Brew _buildBrew() {
    final now = DateTime.now();
    final method = ref.read(brewMethodCatalogProvider).byId(_methodId);
    return Brew(
      id: widget.initial?.id ?? genId(),
      brewedAt: widget.initial?.brewedAt ?? now,
      beanId: _beanId,
      brewMethodId: _methodId,
      recipeId: widget.presetRecipe?.id ?? widget.initial?.recipeId,
      doseGrams: _dose,
      waterGrams: _water,
      grindSetting: _grind,
      grinderId: _grinderId,
      waterTempC:
          _temp ??
          (method.defaultWaterTempC == 0
              ? null
              : method.defaultWaterTempC.toDouble()),
      bloomWaterGrams: _bloomW,
      bloomSeconds: _bloomS,
      pourSchedule:
          widget.presetRecipe?.pourSchedule ??
          widget.initial?.pourSchedule ??
          const [],
      beverageMassGrams: _beverage,
      tdsPercent: _tds,
      filterType: _filterC.text.trim().isEmpty ? null : _filterC.text.trim(),
      notes: _notesC.text.trim().isEmpty ? null : _notesC.text.trim(),
      createdAt: widget.initial?.createdAt ?? now,
      updatedAt: now,
    );
  }

  Future<void> _confirmDelete() async {
    if (widget.initial == null) return;
    final l = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(l.beanDeleteConfirm('這筆沖煮')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.commonDelete),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(brewsProvider.notifier).delete(widget.initial!.id);
      if (mounted) Navigator.pop(context);
    }
  }
}
