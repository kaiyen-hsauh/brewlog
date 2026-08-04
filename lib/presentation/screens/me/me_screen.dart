// S1:MeScreen — 器材 / 磨豆機 / 語言 / 訂閱入口
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brewlog/core/theme/brew_theme.dart';
import 'package:brewlog/core/constants/grinders.dart';
import 'package:brewlog/application/providers/providers.dart';
import 'package:brewlog/application/providers/locale_provider.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/l10n/gen/app_localizations.dart';
import 'package:brewlog/presentation/screens/paywall/paywall_screen.dart';

class MeScreen extends ConsumerStatefulWidget {
  const MeScreen({super.key});
  @override
  ConsumerState<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends ConsumerState<MeScreen> {
  /// §10 設定中的「使用中」磨豆機
  String? _activeGrinderId;

  @override
  void initState() {
    super.initState();
    // 預設第一個為 active
    final catalog = GrinderCatalog.instance;
    if (catalog.all.isNotEmpty) {
      _activeGrinderId = catalog.all.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final equipment = ref.watch(equipmentProvider);
    final catalog = ref.watch(grinderCatalogProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.meTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(l.grinderCustomSection, [
            if (catalog.custom.isEmpty)
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l.grinderCustomSection),
                subtitle: const Text('長按新增自訂磨豆機'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _addCustomGrinder(context),
              ),
            ...catalog.custom.map((g) => ListTile(
                  leading: const Icon(Icons.tune),
                  title: Text(g.name),
                  subtitle:
                      Text('${g.minSetting.toInt()}–${g.maxSetting.toInt()} ${g.unitLabelZh}'),
                  trailing: IconButton(
                    tooltip: l.commonDelete,
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.black54),
                    onPressed: () => catalog.removeCustom(g.id),
                  ),
                )),
            ListTile(
              leading: const Icon(Icons.add, color: BrewColors.accent),
              title: Text(l.grinderAdd),
              onTap: () => _addCustomGrinder(context),
            ),
          ]),
          _section(l.grinderBuiltInSection, [
            for (final g in catalog.builtIn)
              RadioListTile<String>(
                value: g.id,
                groupValue: _activeGrinderId,
                onChanged: (v) => setState(() => _activeGrinderId = v),
                title: Text(g.name),
                subtitle: Text(
                    '${g.minSetting.toInt()}–${g.maxSetting.toInt()} ${g.unitLabelZh}'),
                dense: true,
              ),
          ]),
          _section(l.meEquipment, [
            equipment.when(
              loading: () => const ListTile(title: Text('…')),
              error: (e, _) => ListTile(title: Text('$e')),
              data: (list) {
                if (list.isEmpty) {
                  return ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(l.meAddEquipment),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _addEquipment(context),
                  );
                }
                return Column(
                  children: [
                    ...list.map((e) => ListTile(
                          leading: Icon(_iconForType(e.type)),
                          title: Text(e.name),
                          subtitle:
                              e.notes == null ? null : Text(e.notes!),
                          trailing: IconButton(
                            tooltip: l.commonDelete,
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.black54),
                            onPressed: () =>
                                ref.read(equipmentProvider.notifier).delete(e.id),
                          ),
                        )),
                    ListTile(
                      leading:
                          const Icon(Icons.add, color: BrewColors.accent),
                      title: Text(l.meAddEquipment),
                      onTap: () => _addEquipment(context),
                    ),
                  ],
                );
              },
            ),
          ]),
          _section(l.meSettings, [
            _buildLanguageTile(context, l),
            const ListTile(
              leading: Icon(Icons.tune),
              title: Text('單位'),
              subtitle: Text('g · °C(§10 切換單位時資料以公制儲存)'),
            ),
          ]),
          _section(l.meSubscription, [
            ListTile(
              leading: const Icon(Icons.workspace_premium,
                  color: Colors.amber),
              title: const Text('BrewLog Pro'),
              subtitle: Text('${l.paywallYearly} / ${l.paywallLifetime}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PaywallScreen())),
            ),
          ]),
          _section('資料', [
            const ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('本機儲存 · 零追蹤'),
              subtitle: Text('v1 完全離線可用,§8.3 MUST'),
            ),
          ]),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'BrewLog v1.0.0',
                style: TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(String t) => switch (t) {
        'grinder' => Icons.tune,
        'dripper' => Icons.filter_alt,
        'filter' => Icons.water_drop_outlined,
        'kettle' => Icons.local_drink,
        'scale' => Icons.scale,
        _ => Icons.settings_input_component,
      };

  /// §10 MUST:語言切換 (跟隨系統 / 繁中 / English),持久化到 SharedPreferences
  Widget _buildLanguageTile(BuildContext context, AppLocalizations l) {
    final localeController = LocaleScope.of(context);
    final current = localeController.value;
    final groupVal =
        current == null ? '' : (current.languageCode == 'en' ? 'en' : 'zh_TW');

    void pick(Locale? locale) {
      localeController.value = locale;
      LocalePersistence.persist(locale);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(l.meLanguage),
        ),
        RadioListTile<String>(
          title: const Text('跟隨系統'),
          value: '',
          groupValue: groupVal,
          onChanged: (_) => pick(null),
        ),
        RadioListTile<String>(
          title: const Text('繁體中文'),
          subtitle: const Text('zh-TW'),
          value: 'zh_TW',
          groupValue: groupVal,
          onChanged: (_) => pick(const Locale('zh', 'TW')),
        ),
        RadioListTile<String>(
          title: const Text('English'),
          subtitle: const Text('en'),
          value: 'en',
          groupValue: groupVal,
          onChanged: (_) => pick(const Locale('en')),
        ),
      ],
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Text(title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54)),
          ),
          Card(child: Column(children: children)),
        ],
      ),
    );
  }

  Future<void> _addCustomGrinder(BuildContext context) async {
    final l = AppLocalizations.of(context)!;
    final name = TextEditingController();
    final unit = TextEditingController(text: '格');
    final minC = TextEditingController(text: '0');
    final maxC = TextEditingController(text: '40');
    final stepC = TextEditingController(text: '1');
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.grinderAdd),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: name, decoration: InputDecoration(labelText: l.grinderName)),
              TextField(controller: unit, decoration: InputDecoration(labelText: l.grinderUnit)),
              Row(
                children: [
                  Expanded(child: TextField(controller: minC, decoration: InputDecoration(labelText: 'min'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: maxC, decoration: InputDecoration(labelText: 'max'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: stepC, decoration: InputDecoration(labelText: l.grinderStep), keyboardType: TextInputType.number)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.commonCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.commonSave)),
        ],
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty) {
      ref.read(grinderCatalogProvider).addCustom(
            name: name.text.trim(),
            unitLabelZh: unit.text.trim().isEmpty ? '格' : unit.text.trim(),
            unitLabelEn: 'custom',
            minSetting: double.tryParse(minC.text) ?? 0,
            maxSetting: double.tryParse(maxC.text) ?? 40,
            step: double.tryParse(stepC.text) ?? 1,
          );
      setState(() {});
    }
  }

  Future<void> _addEquipment(BuildContext context) async {
    final l = AppLocalizations.of(context)!;
    final name = TextEditingController();
    final notes = TextEditingController();
    String type = 'dripper';
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: Text(l.meAddEquipment),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: InputDecoration(labelText: l.meEquipmentType),
                  items: const [
                    DropdownMenuItem(value: 'grinder', child: Text('磨豆機')),
                    DropdownMenuItem(value: 'dripper', child: Text('濾杯')),
                    DropdownMenuItem(value: 'filter', child: Text('濾紙')),
                    DropdownMenuItem(value: 'kettle', child: Text('水壺')),
                    DropdownMenuItem(value: 'scale', child: Text('電子秤')),
                  ],
                  onChanged: (v) => setSt(() => type = v ?? 'dripper'),
                ),
                TextField(controller: name, decoration: InputDecoration(labelText: l.meEquipmentName)),
                TextField(controller: notes, decoration: InputDecoration(labelText: l.meEquipmentNotes), maxLines: 2),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l.commonCancel)),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l.commonSave)),
          ],
        ),
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty) {
      await ref.read(equipmentProvider.notifier).save(Equipment(
            id: genId(),
            type: type,
            name: name.text.trim(),
            notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
          ));
    }
  }
}
