// S7:F11 in_app_purchase 整合
// §11.2 MUST 走 App Store / Google Play 內購
// §11.3 付費牆觸發時機:撞到上限時、點擊 Pro 專屬功能時
// §11.3 MUST NOT 不在 App 啟動時強制彈
// 開發期用 in_app_purchase mock;上商店前只需換 product ID

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// §11.2 產品 ID
class ProductIds {
  ProductIds._();
  // 替換為實際 Apple / Google 產品 ID 後即可上商店
  static const monthly = 'brewlog_pro_monthly';
  static const yearly = 'brewlog_pro_yearly';
  static const lifetime = 'brewlog_pro_lifetime';
}

class IAPService {
  IAPService._();
  static final IAPService instance = IAPService._();

  final _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  /// 初始化並開始監聽
  Future<void> init() async {
    _sub = _iap.purchaseStream.listen(_onPurchase);
  }

  void dispose() {
    _sub?.cancel();
  }

  void _onPurchase(List<PurchaseDetails> ps) {
    for (final p in ps) {
      if (p.status == PurchaseStatus.purchased ||
          p.status == PurchaseStatus.restored) {
        // 真實情境:用 entitlements API 驗證,本機給 pro
        // 簡化:任何成功購買都視為訂閱
        _markPro(true);
      } else if (p.status == PurchaseStatus.error) {
        debugPrint('IAP error: ${p.error}');
      }
    }
  }

  void _markPro(bool v) {
    // 透過 notifier
    // (這裡用靜態事件,Provider 端訂閱 rebuild)
    _proSink.add(v);
  }

  /// 公開:Notifiable stream
  final _proSink = StreamController<bool>.broadcast();
  Stream<bool> get proStream => _proSink.stream;

  /// 查詢產品資訊(失敗時 fallback)
  Future<List<ProductDetails>> queryProducts() async {
    try {
      final available = await _iap.isAvailable();
      if (!available) return const [];
      final res = await _iap.queryProductDetails({
        ProductIds.monthly,
        ProductIds.yearly,
        ProductIds.lifetime,
      });
      return res.productDetails;
    } catch (e) {
      debugPrint('queryProducts error: $e');
      return const [];
    }
  }

  /// 觸發購買(真 IAP)
  Future<void> buy(ProductDetails p) async {
    try {
      await _iap.buyConsumable(purchaseParam: PurchaseParam(productDetails: p));
    } catch (e) {
      debugPrint('buy error: $e');
    }
  }

  /// 開發/測試用:直接給 Pro(上商店前移除)
  void debugGrantPro() => _markPro(true);
  void debugRevokePro() => _markPro(false);
}
