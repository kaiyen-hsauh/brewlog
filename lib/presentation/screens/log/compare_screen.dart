// S6:F9 兩筆並列比對 + 萃取控制圖(Pro)
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brewlog/core/theme/brew_theme.dart';
import 'package:brewlog/application/providers/providers.dart';
import 'package:brewlog/application/providers/subscription.dart';
import 'package:brewlog/core/constants/brew_methods.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/l10n/gen/app_localizations.dart';
import 'package:brewlog/presentation/screens/paywall/paywall_screen.dart';

class CompareScreen extends ConsumerStatefulWidget {
  const CompareScreen({super.key});
  @override
  ConsumerState<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends ConsumerState<CompareScreen> {
  final Set<String> _picked = {};
  final List<String> _pickOrder = []; // 保留選擇順序

  void _toggle(String id) {
    setState(() {
      if (_picked.contains(id)) {
        _picked.remove(id);
        _pickOrder.remove(id);
      } else {
        if (_picked.length >= 2) {
          // 移除最舊的
          _picked.remove(_pickOrder.first);
          _pickOrder.removeAt(0);
        }
        _picked.add(id);
        _pickOrder.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final brewsAsync = ref.watch(brewsProvider);
    final catalog = ref.watch(brewMethodCatalogProvider);
    final isPro = ref.watch(subscriptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.logCompare),
        actions: [
          if (_picked.length == 2)
            IconButton(
              icon: const Icon(Icons.bar_chart),
              tooltip: l.logBrewControlChart,
              onPressed: () => _openChart(context, isPro),
            ),
        ],
      ),
      body: brewsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (brews) {
          if (brews.length < 2) {
            return const Center(
                child: Text('至少需要 2 筆沖煮才能比對',
                    style: TextStyle(color: Colors.black54)));
          }
          return Column(
            children: [
              if (_picked.length == 2) _comparePanel(brews, catalog),
              if (_picked.length == 2) const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: brews.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 4),
                  itemBuilder: (_, i) {
                    final b = brews[i];
                    final selected = _picked.contains(b.id);
                    return CheckboxListTile(
                      value: selected,
                      onChanged: (_) => _toggle(b.id),
                      title: Text(
                          '${b.brewedAt.month}/${b.brewedAt.day} · ${catalog.byId(b.brewMethodId).nameZh}'),
                      subtitle: Text(
                        '1:${(b.waterGrams / b.doseGrams).toStringAsFixed(1)}'
                        '${b.overallRating == null ? '' : ' · ${b.overallRating}★'}',
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _comparePanel(List<Brew> all, BrewMethodCatalog catalog) {
    final l = AppLocalizations.of(context)!;
    final a = all.firstWhere((b) => b.id == _pickOrder[0]);
    final c = all.firstWhere((b) => b.id == _pickOrder[1]);
    final diffs = <(String, String, String)>[]; // (label, a, c)
    final same = <String>[];

    void cmp(String label, dynamic va, dynamic vc) {
      final sa = va?.toString() ?? '—';
      final sc = vc?.toString() ?? '—';
      if (sa == sc) {
        same.add(label);
      } else {
        diffs.add((label, sa, sc));
      }
    }

    cmp('粉水比', a.ratioDisplay, c.ratioDisplay);
    cmp('粉重', '${a.doseGrams.toStringAsFixed(1)} g', '${c.doseGrams.toStringAsFixed(1)} g');
    cmp('水重', '${a.waterGrams.toStringAsFixed(0)} g', '${c.waterGrams.toStringAsFixed(0)} g');
    cmp('研磨', a.grindSetting?.toString(), c.grindSetting?.toString());
    cmp('水溫', a.waterTempC?.toStringAsFixed(0), c.waterTempC?.toStringAsFixed(0));
    cmp('總時間',
        a.totalBrewSeconds == null ? null : '${(a.totalBrewSeconds! ~/ 60)}:${(a.totalBrewSeconds! % 60).toString().padLeft(2, '0')}',
        c.totalBrewSeconds == null ? null : '${(c.totalBrewSeconds! ~/ 60)}:${(c.totalBrewSeconds! % 60).toString().padLeft(2, '0')}');
    cmp('整體評分', a.overallRating?.toStringAsFixed(1), c.overallRating?.toStringAsFixed(1));
    cmp('EY', a.extractionYield?.eyPercent.toStringAsFixed(1), c.extractionYield?.eyPercent.toStringAsFixed(1));
    cmp('TDS', a.tdsPercent?.toStringAsFixed(2), c.tdsPercent?.toStringAsFixed(2));

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${l.logCompare} (${a.brewedAt.month}/${a.brewedAt.day} vs ${c.brewedAt.month}/${c.brewedAt.day})',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          // 差異
          if (diffs.isNotEmpty) ...[
            for (final d in diffs)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: BrewColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    SizedBox(
                        width: 72,
                        child: Text(d.$1,
                            style: const TextStyle(color: Colors.black54))),
                    Expanded(
                        child: Text(d.$2,
                            style: const TextStyle(fontWeight: FontWeight.w600))),
                    const Icon(Icons.arrow_forward, size: 14, color: Colors.black45),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(d.$3,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: BrewColors.accent))),
                  ],
                ),
              ),
          ],
          if (same.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                  '${l.logCompareSame}: ${same.join(", ")}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ),
        ],
      ),
    );
  }

  Future<void> _openChart(BuildContext context, bool isPro) async {
    if (!isPro) {
      final ok = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const PaywallScreen()),
      );
      if (ok != true) return;
    }
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BrewControlChartScreen()),
    );
  }
}

/// §F4.2 萃取控制圖
class BrewControlChartScreen extends ConsumerStatefulWidget {
  const BrewControlChartScreen({super.key});
  @override
  ConsumerState<BrewControlChartScreen> createState() =>
      _BrewControlChartScreenState();
}

class _BrewControlChartScreenState
    extends ConsumerState<BrewControlChartScreen> {
  String _methodId = 'v60';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final brewsAsync = ref.watch(brewsProvider);
    final isEspresso = _methodId == 'espresso';
    final zone = BrewControlChartScope.referenceZone(_methodId);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.logBrewControlChart),
        actions: [
          DropdownButton<String>(
            value: _methodId,
            underline: const SizedBox(),
            items: ref
                .read(brewMethodCatalogProvider)
                .all
                .map((m) => DropdownMenuItem(
                      value: m.id,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(m.nameZh,
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _methodId = v ?? 'v60'),
          ),
        ],
      ),
      body: brewsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (brews) {
          final pts = <ScatterSpot>[];
          for (final b in brews) {
            if (b.brewMethodId != _methodId) continue;
            final ey = b.extractionYield;
            if (ey == null) continue;
            pts.add(ScatterSpot(ey.eyPercent, b.tdsPercent ?? 0,
                dotPainter: FlDotCirclePainter(
                  color: b.overallRating == null
                      ? BrewColors.secondary
                      : (b.overallRating! >= 4
                          ? BrewColors.success
                          : BrewColors.warning),
                  radius: 6,
                )));
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.logChartRefZone,
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 12),
                Expanded(
                  child: ScatterChart(
                    ScatterChartData(
                      minX: zone.minX,
                      maxX: zone.maxX,
                      minY: zone.minY,
                      maxY: zone.maxY,
                      scatterSpots: pts,
                      backgroundColor: Colors.white,
                      borderData: FlBorderData(
                          show: true,
                          border: const Border(
                              bottom: BorderSide(),
                              left: BorderSide())),
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (v, _) => Text(v.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 10)),
                        )),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          getTitlesWidget: (v, _) => Text(v.toStringAsFixed(0),
                              style: const TextStyle(fontSize: 10)),
                        )),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        getDrawingHorizontalLine: (_) => FlLine(
                            color: Colors.black12,
                            strokeWidth: 1,
                            dashArray: [4, 4]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isEspresso
                      ? 'espresso 模式 EY 14-26% / TDS 6-14%'
                      : '濾泡模式 EY 14-26% / TDS 0.8-1.8%',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
