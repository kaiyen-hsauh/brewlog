// S2 base + S6 加上比對入口
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brewlog/application/providers/providers.dart';
import 'package:brewlog/core/theme/brew_theme.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/l10n/gen/app_localizations.dart';
import 'package:brewlog/presentation/screens/brew/brew_form_screen.dart';
import 'package:brewlog/presentation/screens/log/compare_screen.dart';
import 'package:brewlog/presentation/screens/recipes/recipes_screen.dart';

class LogScreen extends ConsumerWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final brewsAsync = ref.watch(brewsProvider);
    final catalog = ref.watch(brewMethodCatalogProvider);
    final beansAsync = ref.watch(beansProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.logTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            tooltip: l.logCompare,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CompareScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            tooltip: l.recipeAddTitle,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RecipesScreen()),
            ),
          ),
        ],
      ),
      body: brewsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (brews) {
          if (brews.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.list_alt, size: 64, color: Colors.black26),
                    const SizedBox(height: 12),
                    Text(l.logEmpty,
                        style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            );
          }
          // §F8 v1 簡單統計
          final avg = brews
              .map((b) => b.overallRating ?? 0)
              .where((v) => v > 0)
              .fold<double>(0, (s, v) => s + v);
          final rated = brews.where((b) => b.overallRating != null).length;
          final avgRating = rated == 0 ? 0 : avg / rated;
          final methodCount = <String, int>{};
          for (final b in brews) {
            methodCount[b.brewMethodId] = (methodCount[b.brewMethodId] ?? 0) + 1;
          }
          final favMethodId = methodCount.entries.isEmpty
              ? null
              : (methodCount.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value)))
                  .first
                  .key;
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            children: [
              // 統計卡
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      _stat(l.logTotal(brews.length), BrewColors.primary),
                      const VerticalDivider(width: 16),
                      _stat(
                          rated == 0
                              ? '— ★'
                              : l.logAvgRating(avgRating.toStringAsFixed(1)),
                          BrewColors.accent),
                      const VerticalDivider(width: 16),
                      _stat(
                          favMethodId == null
                              ? '—'
                              : catalog.byId(favMethodId).nameZh,
                          BrewColors.success),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              for (int i = 0; i < brews.length; i++) ...[
                _BrewTile(
                  brew: brews[i],
                  methodName: catalog.byId(brews[i].brewMethodId).nameZh,
                  beanName: beansAsync.value
                      ?.where((b) => b.id == brews[i].beanId)
                      .map((b) => b.name)
                      .firstOrNull,
                ),
                if (i < brews.length - 1) const SizedBox(height: 8),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _stat(String s, Color c) => Expanded(
        child: Column(
          children: [
            Text(s, style: TextStyle(color: c, fontWeight: FontWeight.w600, fontSize: 14), textAlign: TextAlign.center),
          ],
        ),
      );
}

class _BrewTile extends ConsumerWidget {
  final Brew brew;
  final String methodName;
  final String? beanName;
  const _BrewTile({required this.brew, required this.methodName, this.beanName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BrewFormScreen(initial: brew)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: BrewColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    brew.overallRating != null
                        ? brew.overallRating!.toStringAsFixed(1)
                        : '–',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      beanName ?? l.beanUnspecified,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '$methodName · 1:${(brew.waterGrams / brew.doseGrams).toStringAsFixed(1)}'
                      '${brew.totalBrewSeconds == null ? '' : ' · ${(brew.totalBrewSeconds! ~/ 60)}:${(brew.totalBrewSeconds! % 60).toString().padLeft(2, '0')}'}',
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    Text(
                      '${brew.brewedAt.year}/${brew.brewedAt.month.toString().padLeft(2, '0')}/${brew.brewedAt.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.black45, fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (brew.extractionYield != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: BrewColors.secondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'EY ${brew.extractionYield!.eyPercent.toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
