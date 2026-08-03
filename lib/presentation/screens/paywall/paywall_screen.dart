// S7:F11 付費牆完整版
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brewlog/application/providers/subscription.dart';
import 'package:brewlog/l10n/gen/app_localizations.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});
  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isPro = ref.watch(subscriptionProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.paywallTitle),
        actions: [
          if (isPro)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Chip(
                  label: Text('Pro 已啟用'),
                  backgroundColor: Color(0xFFFFE082),
                ),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l.paywallSubtitle,
              style: const TextStyle(fontSize: 15, color: Colors.black54)),
          const SizedBox(height: 20),
          for (final t in [
            l.paywallFeatureBrews,
            l.paywallFeatureRecipes,
            l.paywallFeatureBeans,
            l.paywallFeatureDiag,
            l.paywallFeatureChart,
            l.paywallFeatureCompare,
          ])
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(t),
              dense: true,
            ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _planTile(context, l.paywallMonthly, () => _onSubscribe()),
                  const Divider(),
                  _planTile(context, l.paywallYearly, () => _onSubscribe()),
                  const Divider(),
                  _planTile(context, l.paywallLifetime, () => _onSubscribe()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
              onPressed: _onRestore, child: Text(l.paywallRestore)),
          const SizedBox(height: 12),
          Text(l.paywallTermsNote,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black45)),
        ],
      ),
    );
  }

  Widget _planTile(BuildContext context, String label, VoidCallback onTap) {
    final l = AppLocalizations.of(context)!;
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: ElevatedButton(
          onPressed: onTap, child: Text(l.paywallSubscribe)),
    );
  }

  Future<void> _onSubscribe() async {
    // 開發期:直接給 Pro(上商店前會換成 _iapService.buy(p))
    // final isPro = ref.read(subscriptionProvider);
    // if (!isPro) {
    //   IAPService.instance.debugGrantPro();
    //   ref.read(subscriptionProvider.notifier).setPro(true);
    // }
    ref.read(subscriptionProvider.notifier).setPro(true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pro 已啟用(開發模式)')),
      );
      Navigator.pop(context, true);
    }
  }

  Future<void> _onRestore() async {
    // 實作 restore:
    // await IAPService.instance._iap.restorePurchases();
    ref.read(subscriptionProvider.notifier).restore();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已嘗試恢復購買')),
      );
    }
  }
}
