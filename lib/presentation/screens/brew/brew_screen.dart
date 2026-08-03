// §9.4 S1 沖煮首頁 — 入口、問候、今日次數、快速重複、最愛配方
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brewlog/core/theme/brew_theme.dart';
import 'package:brewlog/application/providers/providers.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/l10n/gen/app_localizations.dart';
import 'package:brewlog/presentation/screens/brew/brew_form_screen.dart';
import 'package:brewlog/presentation/screens/paywall/paywall_screen.dart';
import 'package:brewlog/application/providers/subscription.dart';

class BrewScreen extends ConsumerWidget {
  const BrewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final brewsAsync = ref.watch(brewsProvider);
    final recipesAsync = ref.watch(recipesProvider);
    final beansAsync = ref.watch(beansProvider);
    final catalog = ref.watch(brewMethodCatalogProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('BrewLog')),
      body: SafeArea(
        child: brewsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (brews) {
            final today = DateTime.now();
            final todayCount = brews.where((b) {
              return b.brewedAt.year == today.year &&
                  b.brewedAt.month == today.month &&
                  b.brewedAt.day == today.day;
            }).length;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 12),
                Text('早安 ☕', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 4),
                Text(
                  l.brewTodayCount(todayCount),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 24),

                // §S1 大型「開始沖煮」按鈕
                SizedBox(
                  height: 120,
                  child: ElevatedButton.icon(
                    onPressed: () => _onStartBrew(context, ref, brews),
                    icon: const Icon(Icons.play_circle_fill, size: 40),
                    label: Text(
                      l.brewStart,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BrewColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 快速重複上次
                if (brews.isNotEmpty)
                  _lastBrewCard(context, ref, brews.first, beansAsync.value),
                if (brews.isEmpty)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.replay, size: 28),
                      title: Text(l.brewQuickRepeat),
                      subtitle: Text(l.brewNoPrevious),
                    ),
                  ),
                const SizedBox(height: 16),

                // 我的最愛配方
                Text(l.brewStart, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                recipesAsync.when(
                  loading: () => const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Text('$e'),
                  data: (recipes) {
                    if (recipes.isEmpty) {
                      return SizedBox(
                        height: 90,
                        child: Center(
                          child: Text(
                            l.recipeNoRecipes,
                            style: const TextStyle(color: Colors.black45),
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recipes.length,
                        itemBuilder: (_, i) {
                          final r = recipes[i];
                          final m = catalog.byId(r.brewMethodId);
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BrewFormScreen(presetRecipe: r),
                                ),
                              ),
                              child: Container(
                                width: 160,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: BrewColors.secondary,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      r.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${m.nameZh} · 1:${r.ratioDenominator.toStringAsFixed(0)}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _onStartBrew(
    BuildContext context,
    WidgetRef ref,
    List<Brew> brews,
  ) async {
    final l = AppLocalizations.of(context)!;
    final isPro = ref.read(subscriptionProvider);
    final reason = FreemiumGuard.canAddBrew(isPro, brews.length);
    if (reason != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.paywallLimitBrew)));
      await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const PaywallScreen()),
      );
      if (!context.mounted) return;
      if (!ref.read(subscriptionProvider)) return;
    }
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BrewFormScreen()),
    );
  }

  Widget _lastBrewCard(
    BuildContext context,
    WidgetRef ref,
    Brew last,
    List<Bean>? beans,
  ) {
    final l = AppLocalizations.of(context)!;
    final bean = beans?.where((b) => b.id == last.beanId).firstOrNull;
    final method = ref.read(brewMethodCatalogProvider).byId(last.brewMethodId);
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BrewFormScreen(initial: last.duplicate()),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.replay, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.brewQuickRepeat,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${bean?.name ?? l.beanUnspecified} · ${method.nameZh} · 1:${(last.waterGrams / last.doseGrams).toStringAsFixed(1)}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
