// S1:F6 豆子 CRUD UI
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brewlog/core/theme/brew_theme.dart';
import 'package:brewlog/core/constants/bean_enums.dart';
import 'package:brewlog/application/providers/providers.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/l10n/gen/app_localizations.dart';
import 'package:brewlog/presentation/screens/paywall/paywall_screen.dart';
import 'package:brewlog/application/providers/subscription.dart';

class BeansScreen extends ConsumerWidget {
  const BeansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final beansAsync = ref.watch(beansProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.beanTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context, ref, null),
        icon: const Icon(Icons.add),
        label: Text(l.beanAdd),
        tooltip: l.beanAdd, // §9.5 無障礙
      ),
      body: beansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (beans) {
          if (beans.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bubble_chart,
                        size: 64, color: Colors.black26),
                    const SizedBox(height: 12),
                    Text(l.beanNoBeans,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
            itemCount: beans.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) => _BeanCard(bean: beans[i]),
          );
        },
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, WidgetRef ref, Bean? bean) async {
    final l = AppLocalizations.of(context)!;
    if (bean == null) {
      final isPro = ref.read(subscriptionProvider);
      final beans = ref.read(beansProvider).value ?? [];
      final reason = FreemiumGuard.canAddBean(isPro, beans.length);
      if (reason != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.paywallLimitBean)),
        );
        await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const PaywallScreen()),
        );
        if (!context.mounted) return;
        if (!ref.read(subscriptionProvider)) return;
      }
    }
    if (!context.mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _BeanEditor(initial: bean),
    );
  }
}

class _BeanCard extends ConsumerWidget {
  final Bean bean;
  const _BeanCard({required this.bean});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final rest = bean.restDays;
    final restHint = bean.restDaysHintZh;
    return Card(
      child: InkWell(
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => _BeanEditor(initial: bean),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(bean.name,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600)),
                  ),
                  if (rest != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: rest <= 3
                            ? BrewColors.warning.withValues(alpha: 0.15)
                            : rest > 30
                                ? BrewColors.error.withValues(alpha: 0.15)
                                : BrewColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        l.beanRestDaysShort(rest),
                        style: TextStyle(
                          fontSize: 12,
                          color: rest <= 3
                              ? BrewColors.warning
                              : rest > 30
                                  ? BrewColors.error
                                  : BrewColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  IconButton(
                    tooltip: l.commonDelete,
                    icon: const Icon(Icons.delete_outline,
                        size: 20, color: Colors.black54),
                    onPressed: () => _confirmDelete(context, ref),
                  ),
                ],
              ),
              if (bean.roaster != null || bean.origin != null) ...[
                const SizedBox(height: 2),
                Text(
                  [bean.roaster, bean.origin].whereType<String>().join(' · '),
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
              if (restHint != null) ...[
                const SizedBox(height: 4),
                Text('· $restHint',
                    style: const TextStyle(fontSize: 12, color: Colors.black45)),
              ],
              if (bean.roastLevelKey != null || bean.processingKey != null) ...[
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [
                    if (bean.roastLevelKey != null)
                      _chip(RoastLevel.zh(bean.roastLevelKey!)),
                    if (bean.processingKey != null)
                      _chip(Processing.zh(bean.processingKey!)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String s) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: BrewColors.secondary.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(s, style: const TextStyle(fontSize: 11)),
      );

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(l.beanDeleteConfirm(bean.name)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.commonCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.commonDelete)),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(beansProvider.notifier).delete(bean.id);
    }
  }
}

class _BeanEditor extends ConsumerStatefulWidget {
  final Bean? initial;
  const _BeanEditor({this.initial});
  @override
  ConsumerState<_BeanEditor> createState() => _BeanEditorState();
}

class _BeanEditorState extends ConsumerState<_BeanEditor> {
  late final TextEditingController _name;
  late final TextEditingController _roaster;
  late final TextEditingController _origin;
  late final TextEditingController _farm;
  late final TextEditingController _variety;
  late final TextEditingController _altitude;
  late final TextEditingController _notes;
  late final TextEditingController _weight;
  late final TextEditingController _price;
  String? _processingKey;
  String? _roastLevelKey;
  DateTime? _roastDate;
  DateTime? _purchaseDate;
  String? _errName;

  @override
  void initState() {
    super.initState();
    final b = widget.initial;
    _name = TextEditingController(text: b?.name ?? '');
    _roaster = TextEditingController(text: b?.roaster ?? '');
    _origin = TextEditingController(text: b?.origin ?? '');
    _farm = TextEditingController(text: b?.farm ?? '');
    _variety = TextEditingController(text: b?.variety ?? '');
    _altitude = TextEditingController(text: b?.altitude ?? '');
    _notes = TextEditingController(text: b?.notes ?? '');
    _weight = TextEditingController(text: b?.weightGrams?.toString() ?? '');
    _price = TextEditingController(text: b?.price?.toString() ?? '');
    _processingKey = b?.processingKey;
    _roastLevelKey = b?.roastLevelKey;
    _roastDate = b?.roastDate;
    _purchaseDate = b?.purchaseDate;
  }

  @override
  void dispose() {
    _name.dispose();
    _roaster.dispose();
    _origin.dispose();
    _farm.dispose();
    _variety.dispose();
    _altitude.dispose();
    _notes.dispose();
    _weight.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final isEdit = widget.initial != null;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36, height: 4, margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                    color: Colors.black12, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Text(isEdit ? l.beanEditTitle : l.beanAddTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _f(l.beanName, _name, required: true, error: _errName),
            _f(l.beanRoaster, _roaster),
            _f(l.beanOrigin, _origin),
            _f(l.beanFarm, _farm),
            _f(l.beanVariety, _variety),
            _f(l.beanAltitude, _altitude,
                hint: 'e.g. 1500-1800m'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _dropdown(
                    context,
                    label: l.beanProcessing,
                    value: _processingKey,
                    options: Processing.all,
                    labelOf: Processing.zh,
                    onChanged: (v) => setState(() => _processingKey = v),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _dropdown(
                    context,
                    label: l.beanRoastLevel,
                    value: _roastLevelKey,
                    options: RoastLevel.all,
                    labelOf: RoastLevel.zh,
                    onChanged: (v) => setState(() => _roastLevelKey = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _dateRow(context, l.beanRoastDate, _roastDate,
                (d) => setState(() => _roastDate = d)),
            _dateRow(context, l.beanPurchaseDate, _purchaseDate,
                (d) => setState(() => _purchaseDate = d)),
            Row(
              children: [
                Expanded(
                    child: _f(l.beanWeight, _weight,
                        hint: 'g', keyboardType: TextInputType.number)),
                const SizedBox(width: 8),
                Expanded(
                    child: _f(l.beanPrice, _price,
                        hint: 'TWD', keyboardType: TextInputType.number)),
              ],
            ),
            _f(l.commonNote, _notes, maxLines: 3),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l.commonCancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _save,
                    child: Text(l.commonSave),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _f(
    String label,
    TextEditingController c, {
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool required = false,
    String? error,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: c,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          hintText: hint,
          errorText: error,
        ),
      ),
    );
  }

  Widget _dropdown(
    BuildContext context, {
    required String label,
    required String? value,
    required Map<String, (String, String)> options,
    required String Function(String) labelOf,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: options.entries
            .map((e) => DropdownMenuItem(value: e.key, child: Text(labelOf(e.key))))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _dateRow(BuildContext context, String label, DateTime? value,
      ValueChanged<DateTime?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: value ?? now,
            firstDate: DateTime(now.year - 5),
            lastDate: now,
          );
          if (picked != null) onChanged(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(
              labelText: label,
              suffixIcon: value == null
                  ? const Icon(Icons.calendar_today, size: 18)
                  : IconButton(
                      tooltip: AppLocalizations.of(context)!.commonClear,
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => onChanged(null))),
          child: Text(value == null
              ? AppLocalizations.of(context)!.commonSelect
              : '${value.year}/${value.month.toString().padLeft(2, '0')}/${value.day.toString().padLeft(2, '0')}'),
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _errName = null);
    if (_name.text.trim().isEmpty) {
      setState(() => _errName = '必填');
      return;
    }
    final now = DateTime.now();
    final b = widget.initial;
    final bean = (b ??
            Bean(
              id: genId(),
              name: _name.text.trim(),
              createdAt: now,
              updatedAt: now,
            ))
        .copyWith(
      name: _name.text.trim(),
      roaster: _roaster.text.trim().isEmpty ? null : _roaster.text.trim(),
      origin: _origin.text.trim().isEmpty ? null : _origin.text.trim(),
      farm: _farm.text.trim().isEmpty ? null : _farm.text.trim(),
      variety: _variety.text.trim().isEmpty ? null : _variety.text.trim(),
      altitude: _altitude.text.trim().isEmpty ? null : _altitude.text.trim(),
      processingKey: _processingKey,
      roastLevelKey: _roastLevelKey,
      roastDate: _roastDate,
      purchaseDate: _purchaseDate,
      weightGrams: double.tryParse(_weight.text),
      price: double.tryParse(_price.text),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      updatedAt: now,
    );
    await ref.read(beansProvider.notifier).save(bean);
    if (mounted) Navigator.pop(context);
  }
}
