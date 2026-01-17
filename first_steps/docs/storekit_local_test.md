# StoreKit Configuration で Pro 版サブスクをローカルテストする手順

目的: 実機で Pro 版（週額 / 月額 / 年額サブスク）を StoreKit Configuration でテストする。

---

## 1. Xcode で .storekit を作成

1) `ios/Runner.xcworkspace` を Xcode で開く  
2) `Runner` プロジェクトを選択  
3) メニュー: **File > New > File...**  
4) **StoreKit Configuration File** を選択  
5) ファイル名: `ProSubscriptions.storekit`  
6) 保存先: `ios/` フォルダ  

---

## 2. サブスク商品を追加

StoreKit Configuration エディタで以下を作成:

### Subscription Group

- Name: `Pro`

### Products (Auto-Renewable Subscription)

例の Product ID（必要なら変更）:

- 週額: `pro_weekly`
- 月額: `pro_monthly`
- 年額: `pro_yearly`

各商品の設定:

- Type: Auto-Renewable Subscription
- Subscription Group: `Pro`
- Duration:
  - 週額: 1 week
  - 月額: 1 month
  - 年額: 1 year
- Price: テスト用の任意価格
- Introductory Offer / Trial: なし

---

## 3. Xcode の Run 設定で .storekit を指定

1) Xcode の `Runner` スキームを選択  
2) **Edit Scheme...**  
3) **Run > Options**  
4) **StoreKit Configuration** に `ProSubscriptions.storekit` を指定  

---

## 4. Flutter で実機起動

```bash
flutter run -d <device_id>
```

---

## 5. 確認ポイント

- Pro 版購入フローがローカルで表示される  
- 購入後に Pro 特典が有効になる（広告非表示、複数人登録、バックアップなど）  
- 購入復元もテストできる  

---

## 補足

- StoreKit Configuration での課金テストは App Store Connect の登録不要  
- Product ID は RevenueCat 側の Products / Entitlements / Offerings と一致させること  

