# BrewLog — App Store 上架素材

這批素材由設計規格（`../BrewLog_精品咖啡App_開發規格.md`）§14 規範產出，含 4 種規格的 PNG 已對齊 App Store Connect 上架表單會檢查的解析度。

## 目錄結構

```
app-store-screenshots/
├── raw-*.png                     1320×2868 (iPhone 16 Pro Max native,主版)
├── 6.7in/                        1290×2796 (App Store Connect 必填的 6.7" iPhone)
├── 6.5in/                        1242×2688 (iPhone 11 Pro Max,6.5")
├── marketing/                    1320×3188 (帶品牌封膜,用於部落格/社群/官網)
└── brewlog-app-store-screenshots.zip    (全部內容,ASO/PM 一鍵夾走)
```

## 5 張順序與文案對應

| # | 標題 | 副標題 | 對應 SPEC |
|---|---|---|---|
| 1 | 開始每一杯 | 打開 App 就是沖煮模式 | §4.1 S1 沖煮首頁 |
| 2 | 從一支豆開始 | 完整養豆天數、烘焙日、品種 | §F6 豆子管理 |
| 3 | 好味道不再流失 | 記錄完整參數,下一次重現 | §F9 歷史記錄 |
| 4 | 用你的器材 | Comandante / 1Zpresso / Fellow … 都支援 | §6.4 磨豆機庫 |
| 5 | 每一杯都在進步 | 診斷引擎告訴你下一杯要改什麼 | §F7 核心差異化 |

## 怎麼上 App Store Connect

1. App Store Connect → My Apps → BrewLog → Prepare for Submission
2. 左側 **6.7" iPhone Display** → 上傳 `6.7in/` 5 張 (1→5)
3. 左側 **6.5" iPhone Display** → 上傳 `6.5in/` 5 張
4. iPad 可選 (v1 不上,免)

## 行銷素材

`marketing/` 5 張附品牌頂部 + BrewLog mark + 頁碼,可貼到：
- 部落格 / 文章
- 個人 Twitter / Threads / Instagram
- App Store 元資料的可選 promotional text

## 法務 / 授權

- 圖內文字皆自有編排,視覺未抄 SCA 風味輪(SPEC §9.2 + §F3 MUST)
- 字型用系統內建 PingFang TC 渲染
- 文案來自 SPEC §14 中性行銷語,不含醫療/食安宣稱
