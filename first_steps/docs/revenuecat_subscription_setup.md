# RevenueCat + App Store Connect サブスク設定手順（週額/月額/年額）

目的: Pro版を **自動更新サブスクリプション**（週額・月額・年額）で提供する。  
無料トライアルは無し。無料版は広告あり・機能制限。

---

## 前提

- Bundle ID はアプリ側と一致していること
- RevenueCat でアプリを作成済みであること
- App Store Connect にアプリが作成済みであること

---

## 1. App Store Connect 側（商品作成）

### 1-1. サブスクリプショングループ作成

- App Store Connect → 対象アプリ
- Monetization → Subscriptions
- **Subscription Group** を作成
  - 例: `Pro` など

### 1-2. サブスク商品作成（週額/月額/年額）

各商品ごとに作成する。

共通項目:

- **Type**: Auto-Renewable Subscription
- **Subscription Group**: 上で作成したグループ
- **Product ID**: RevenueCat と一致させる
  - 例:
    - `pro_weekly`
    - `pro_monthly`
    - `pro_yearly`
- **Duration**:
  - 週額: 1 week
  - 月額: 1 month
  - 年額: 1 year
- **Introductory Offer / Free Trial**: なし
- **Price**: それぞれ設定

注意:

- 商品作成後、**App Store Connect 側の反映に時間（最大1時間程度）**がかかることがある

---

## 2. RevenueCat 側（Apple連携）

RevenueCat が App Store Connect から商品情報を取得できるようにする。

### 2-1. App Store Connect API Key を作成

- App Store Connect → Users and Access → Keys
- **App Store Connect API Key** を作成
- `Issuer ID` / `Key ID` / `.p8` を取得

### 2-2. RevenueCat に API Key を登録

- RevenueCat → App → App Settings → App Store Connect
- **App Store Connect API Key** を登録

### 2-3. In-App Purchase Key を作成

- App Store Connect → Users and Access → Keys
- **In-App Purchase Key** を作成
- `Key ID` / `.p8` を取得

### 2-4. RevenueCat に IAP Key を登録

- RevenueCat → App → App Settings → App Store Connect
- **In-App Purchase Key** を登録

---

## 3. RevenueCat 側（Products / Entitlements / Offerings）

### 3-1. Products を取り込む

- RevenueCat → Products
- **Import products** で App Store から取り込み
  - または手動で Product ID を追加

### 3-2. Entitlement を作成

- RevenueCat → Entitlements
- **Entitlement ID**: `pro`
- Products に `pro_weekly` / `pro_monthly` / `pro_yearly` を紐付け

### 3-3. Offering を作成して Current に設定

- RevenueCat → Offerings
- Offering を作成（例: `default`）
- Packages を追加（Weekly / Monthly / Annual）
- **Current Offering** に設定

---

## 4. アプリ側の確認点

- `entitlementId` が `pro` と一致していること
- SDKキーは **public app-specific API key**（`appl_...`）
- Pro版の特典反映:
  - 広告非表示
  - 複数人登録
  - バックアップ

---

## 5. 実機検証メモ

Offerings が空のときは以下が原因の可能性が高い:

- App Store Connect 側の商品が未作成
- Product ID が不一致
- RevenueCat で Offerings に追加されていない
- App Store Connect のキー未登録
- App Store Connect の反映待ち

---

## 6. 決めた前提（このドキュメントの前提）

- 料金プラン: 週額 / 月額 / 年額
- 無料トライアル: なし
- 無料版: 広告あり + 機能制限

