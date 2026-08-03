// S6:F5 配方庫
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brewlog/core/theme/brew_theme.dart';
import 'package:brewlog/application/providers/providers.dart';
import 'package:brewlog/application/providers/subscription.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/l10n/gen/app_localizations.dart';
import 'package:brewlog/presentation/screens/brew/brew_form_screen.dart';
import 'package:brewlog/presentation/screens/paywall/paywall_screen.dart';

class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final recipesAsync = ref.watch(recipesProvider);
    final isPro = ref.watch(subscriptionProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.brewStart)), // 從 home 進來會被換
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context, ref, null),
        icon: const Icon(Icons.add),
        label: Text(l.recipeAddTitle),
      ),
      body: recipesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (recipes) {
          if (recipes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bookmark, size: 64, color: Colors.black26),
                    const SizedBox(height: 12),
                    Text(l.recipeNoRecipes,
                        style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
            itemCount: recipes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _RecipeCard(recipe: recipes[i], isPro: isPro),
          );
        },
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, WidgetRef ref, Recipe? r) async {
    final isPro = ref.read(subscriptionProvider);
    final recipes = ref.read(recipesProvider).value ?? [];
    if (!isPro && r == null) {
      final reason = FreemiumGuard.canAddRecipe(isPro, recipes.length);
      if (reason != null) {
        final ok = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const PaywallScreen()),
        );
        if (ok != true) return;
      }
    }
    if (!context.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecipeEditor(initial: r)),
    );
  }
}

class _RecipeCard extends ConsumerWidget {
  final Recipe recipe;
  final bool isPro;
  const _RecipeCard({required this.recipe, required this.isPro});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final method = ref.read(brewMethodCatalogProvider).byId(recipe.brewMethodId);
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => BrewFormScreen(presetRecipe: recipe)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      recipe.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (recipe.isFavorite)
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                  IconButton(
                    tooltip: l.commonDelete,
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.black54, size: 20),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: Text(l.recipeDeleteConfirm(recipe.name)),
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
                        await ref
                            .read(recipesProvider.notifier)
                            .delete(recipe.id);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${method.nameZh} · 1:${recipe.ratioDenominator.toStringAsFixed(0)}'
                '${recipe.waterTempC == null ? '' : ' · ${recipe.waterTempC!.toStringAsFixed(0)}°C'}'
                '${recipe.grindSetting == null ? '' : ' · ${recipe.grindSetting} 格'}',
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: Text(l.commonEdit),
                    onPressed: () async {
                      // 進 RecipeEditor 編輯
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeEditor(initial: recipe),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: Text(l.recipeApply),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BrewFormScreen(presetRecipe: recipe),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeEditor extends ConsumerStatefulWidget {
  final Recipe? initial;
  const RecipeEditor({super.key, this.initial});
  @override
  ConsumerState<RecipeEditor> createState() => _RecipeEditorState();
}

class _RecipeEditorState extends ConsumerState<RecipeEditor> {
  final _name = TextEditingController();
  final _ratioC = TextEditingController();
  final _tempC = TextEditingController();
  final _grindC = TextEditingController();
  final _bloomWC = TextEditingController();
  final _bloomSC = TextEditingController();
  String _methodId = 'v60';
  String? _grinderId;
  List<PourStep> _steps = [];
  bool _fav = false;

  @override
  void initState() {
    super.initState();
    final r = widget.initial;
    if (r != null) {
      _name.text = r.name;
      _ratioC.text = r.ratioDenominator.toStringAsFixed(0);
      _tempC.text = r.waterTempC?.toStringAsFixed(0) ?? '';
      _grindC.text = r.grindSetting?.toString() ?? '';
      _bloomWC.text = r.bloomWaterGrams?.toString() ?? '';
      _bloomSC.text = r.bloomSeconds?.toString() ?? '';
      _methodId = r.brewMethodId;
      _grinderId = r.grinderId;
      _steps = List.of(r.pourSchedule);
      _fav = r.isFavorite;
    } else {
      _ratioC.text = '16';
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _ratioC, _tempC, _grindC, _bloomWC, _bloomSC]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final catalog = ref.watch(brewMethodCatalogProvider);
    final grinders = ref.watch(grinderCatalogProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initial == null ? l.recipeAddTitle : l.recipeEditTitle),
        actions: [
          IconButton(
            icon: Icon(_fav ? Icons.star : Icons.star_border,
                color: _fav ? Colors.amber : null),
            tooltip: l.recipeFavorite,
            onPressed: () => setState(() => _fav = !_fav),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: '配方名稱'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _methodId,
            decoration: InputDecoration(labelText: l.brewSelectMethod),
            items: catalog.all
                .map((m) => DropdownMenuItem(
                    value: m.id, child: Text(m.nameZh)))
                .toList(),
            onChanged: (v) => setState(() => _methodId = v ?? 'v60'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ratioC,
                  decoration: const InputDecoration(
                    labelText: '粉水比 1:?',
                    suffixText: '1',
                    hintText: '16',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _tempC,
                  decoration: const InputDecoration(
                      labelText: '水溫', suffixText: '°C'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _grinderId,
            decoration: const InputDecoration(labelText: '磨豆機'),
            items: grinders.all
                .map((g) => DropdownMenuItem(
                    value: g.id,
                    child: Text('${g.name} · ${g.unitLabelZh}')))
                .toList(),
            onChanged: (v) => setState(() => _grinderId = v),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _grindC,
            decoration: const InputDecoration(labelText: '研磨刻度'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _bloomWC,
                  decoration:
                      const InputDecoration(labelText: '悶蒸水量', suffixText: 'g'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _bloomSC,
                  decoration: const InputDecoration(
                      labelText: '悶蒸時間', suffixText: '秒'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 注水排程
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.recipePourSchedule,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              TextButton.icon(
                onPressed: _addStep,
                icon: const Icon(Icons.add, size: 16),
                label: Text(l.recipeAddPourStep),
              ),
            ],
          ),
          for (int i = 0; i < _steps.length; i++)
            _StepRow(
              key: ValueKey('step_$i'), // §F8.1 刪除中間 step 後正確 rebuild
              index: i,
              step: _steps[i],
              onChanged: (s) => setState(() => _steps[i] = s),
              onDelete: () => setState(() => _steps.removeAt(i)),
            ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: Text(l.commonSave),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              backgroundColor: BrewColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // _stepRow helper 移除 — 改用 _StepRow stateful widget + ValueKey
  // (§F8.1 刪除中間 step 不會錯亂)

  void _addStep() {
    setState(() {
      final lastSec = _steps.isEmpty ? 0 : _steps.last.atSecond + 30;
      _steps.add(PourStep(
        order: _steps.length,
        atSecond: lastSec,
        cumulativeWaterGrams: 0,
        label: '注水段 ${_steps.length + 1}',
      ));
    });
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    final now = DateTime.now();
    final r = Recipe(
      id: widget.initial?.id ?? genId(),
      name: _name.text.trim(),
      brewMethodId: _methodId,
      ratioDenominator: double.tryParse(_ratioC.text) ?? 16,
      grindSetting: double.tryParse(_grindC.text),
      grinderId: _grinderId,
      waterTempC: double.tryParse(_tempC.text),
      bloomWaterGrams: double.tryParse(_bloomWC.text),
      bloomSeconds: int.tryParse(_bloomSC.text),
      pourSchedule: _steps,
      isFavorite: _fav,
      createdAt: widget.initial?.createdAt ?? now,
    );
    await ref.read(recipesProvider.notifier).save(r);
    if (mounted) Navigator.pop(context);
  }
}


/// 注水排程的單列(§F8.1 用 controller 取代 initialValue,避免刪除 step 後 state 錯亂)
class _StepRow extends StatefulWidget {
  final int index;
  final PourStep step;
  final ValueChanged<PourStep> onChanged;
  final VoidCallback onDelete;
  const _StepRow({
    super.key,
    required this.index,
    required this.step,
    required this.onChanged,
    required this.onDelete,
  });
  @override
  State<_StepRow> createState() => _StepRowState();
}

class _StepRowState extends State<_StepRow> {
  late final TextEditingController _secC;
  late final TextEditingController _gC;
  late final TextEditingController _labelC;

  @override
  void initState() {
    super.initState();
    _secC = TextEditingController(text: widget.step.atSecond.toString());
    _gC = TextEditingController(
        text: widget.step.cumulativeWaterGrams.toStringAsFixed(0));
    _labelC = TextEditingController(text: widget.step.label ?? '');
  }

  @override
  void dispose() {
    _secC.dispose();
    _gC.dispose();
    _labelC.dispose();
    super.dispose();
  }

  void _emit() {
    widget.onChanged(PourStep(
      order: widget.index,
      atSecond: int.tryParse(_secC.text) ?? widget.step.atSecond,
      cumulativeWaterGrams:
          double.tryParse(_gC.text) ?? widget.step.cumulativeWaterGrams,
      label: _labelC.text.isEmpty ? null : _labelC.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text('\${widget.index + 1}')),
          Expanded(
            child: TextField(
              controller: _secC,
              decoration: const InputDecoration(labelText: '秒', isDense: true),
              keyboardType: TextInputType.number,
              onChanged: (_) => _emit(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _gC,
              decoration: const InputDecoration(labelText: 'g', isDense: true),
              keyboardType: TextInputType.number,
              onChanged: (_) => _emit(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _labelC,
              decoration: const InputDecoration(labelText: '標籤', isDense: true),
              onChanged: (_) => _emit(),
            ),
          ),
          IconButton(
            tooltip: AppLocalizations.of(context)!.recipeRemoveStep,
            icon: const Icon(Icons.close, size: 18),
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }
}
