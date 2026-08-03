# BrewLog — 精品咖啡沖煮記錄 App

> 給手沖與精品咖啡玩家的「可複製配方」工具。
> 記錄 → 評分 → 診斷 → 下一杯更好。

## 狀態:v1.0.0 MVP — 全部 8 Sprint 完成

| Sprint | 範圍 | 狀態 |
|---|---|---|
| S0 | 專案骨架 + Clean Architecture + 設計系統 + i18n + Hive | ✅ |
| S1 | F6 豆子 + F7 器材 + 磨豆機 JSON 庫 | ✅ |
| S2 | F1 沖煮記錄 CRUD + F4 萃取計算 | ✅ |
| S3 | F2 計時器(Wakelock + 背景準確 + 分段) | ✅ |
| S4 | F3 風味評分(6 維 + 星等 + 35 詞彙) | ✅ |
| S5 | F7 診斷引擎(10 條規則 + ≥20 測試) | ✅ |
| S6 | F5 配方庫 + F9 比對 + 萃取控制圖 | ✅ |
| S7 | F11 付費牆(in_app_purchase + Freemium) | ✅ |
| S8 | 測試補齊 + 無障礙 + 隱私政策 + 上架素材 | ✅ |

## 技術棧

- **Flutter 3.44** (stable) / Dart 3.12
- **Riverpod** 狀態管理
- **go_router** 路由(Sprint 補)
- **Hive** 本機儲存(零雲端、零追蹤)
- **fl_chart** 萃取控制圖
- **wakelock_plus** 螢幕常亮
- **in_app_purchase** Pro 訂閱
- **intl** 雙語(繁中 / English)
- 跨平台:iOS / Android / Web

## 開始

```bash
flutter pub get
flutter gen-l10n
flutter test
flutter run -d <device>
```

## 結構

```
lib/
├── core/           常數、設計系統、驗證
├── domain/         entities(純) + repositories(抽象) + services(規則引擎、IAP)
├── data/           Hive 實作
├── application/    Riverpod providers + 訂閱
├── presentation/   11 個螢幕
└── l10n/           雙語 ARB
```

## 測試

```
$ flutter test
…
All tests passed!
```

- 72+ 個測試,涵蓋 §13 MUST 要求:
  - ≥60 個單元測試(診斷引擎、計算、驗證、entity round-trip、Freemium 邏輯)
  - ≥15 個 widget 測試(底部導航、tab 切換、FAB、主題)
  - 4 個整合測試(完整沖煮流程、計時器背景準確、付費牆、持久化)
  - 1 個 i18n 同步測試(§10 MUST)

## 給 Apple Developer 帳號後要做的事(S8 之後)

1. 創建 App Store Connect app
2. 創建 In-App Purchase 產品(替換 `ProductIds.*` 為真 ID)
3. 創建 Privacy Policy URL + Terms URL
4. 設置 PrivacyInfo.xcprivacy(已建)
5. 截圖:6.7" / 6.1" 各 5 張
6. 實機 build + Archive → 上傳 → 送審
7. 第一次送審約 24-48 小時

## 授權

源碼:本倉庫私用。
SCA 風味輪:CC BY-NC-ND 4.0 — **本 App 嚴禁重製**。
本 App 使用自有 §6.5 風味分類(詞彙為通用名詞,不受著作權保護,但視覺原創)。
