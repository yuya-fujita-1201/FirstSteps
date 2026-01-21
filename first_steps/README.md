# はじめてメモ ~First Steps~

「初めての瞬間」だけをシンプルに記録・共有する育児マイルストーン記録アプリ

## 概要

はじめてメモは、お子様の成長の節目となる「初めての瞬間」を記録するためのミニマルなアプリです。初めての笑顔、首すわり、ハイハイなど、特別な瞬間を写真とメモで記録し、家族と共有できます。

## 主な機能

### MVP (v1.0) の機能

- **子供のプロフィール登録**: 名前、生年月日、プロフィール写真を登録
- **マイルストーン一覧**: 月齢ごとに標準的なマイルストーンをテンプレートとして表示
- **マイルストーン記録**: 達成日、写真、メモを記録
- **タイムライン表示**: 記録したマイルストーンを時系列で一覧表示
- **共有機能**: 記録をテキストで共有

### v1.1 追加機能

- **広告表示 (AdMob)**: ホーム/タイムライン/マイルストーンにアダプティブバナー広告を表示
- **インタースティシャル広告**: 記録保存後に3回に1回の頻度で表示
- **Pro版 (RevenueCat)**: 広告非表示、複数人の子供登録、クラウドバックアップ
- **クラウドバックアップ (Firebase)**: 匿名認証でバックアップ/復元
- **画像最適化**: 保存前に長辺1024px制限・JPEG品質85%で圧縮
- **エラーハンドリング強化**: 主要処理でユーザーフレンドリーな通知

## プライバシーポリシー

はじめてメモ ~First Steps~（以下「本アプリ」といいます）は、ユーザーのプライバシーを尊重し、個人情報の保護に努めます。本プライバシーポリシーは、本アプリにおける個人情報の取り扱いについて説明するものです。

### 1. 収集する情報

本アプリは、以下の情報を収集する場合があります。

【無料版】
・広告配信のための匿名利用情報
※お子様の名前、生年月日、マイルストーン記録（達成日、メモ、写真）などの入力情報は、無料版では本アプリ運営者に送信・収集されません（端末内のローカル保存のみ）。

【Pro版】
・クラウドバックアップ用の匿名認証情報
・バックアップ機能の利用時に、端末内の入力情報（お子様の名前、生年月日、マイルストーン記録など）がクラウドに保存される場合があります
・購入情報（RevenueCatを通じた課金情報）

### 2. 情報の利用目的

収集した情報は、以下の目的で利用されます。

・本アプリのサービス提供
・データのバックアップおよび復元（Pro版）
・広告の配信（無料版）
・アプリの改善および新機能の開発
・お問い合わせへの対応

### 3. データの保存場所

【ローカルストレージ】
お子様のプロフィールやマイルストーン記録は、デバイス内のローカルストレージに保存されます。

【クラウドストレージ（Pro版のみ）】
バックアップ機能を利用する場合、データはFirebase（Google Cloud Platform）に保存されます。通信は暗号化され、安全に管理されます。

### 4. 第三者への提供

本アプリは、以下の場合を除き、ユーザーの個人情報を第三者に提供することはありません。

・ユーザーの同意がある場合
・法令に基づく場合
・人の生命、身体または財産の保護のために必要がある場合

### 5. 第三者サービスの利用

本アプリは、以下の第三者サービスを利用しています。各サービスのプライバシーポリシーもご確認ください。

【無料版】
・Google AdMob（広告配信）

【Pro版】
・Firebase Authentication（匿名認証）
・Cloud Firestore（データ保存）
・RevenueCat（課金管理）

### 6. データの削除

ユーザーは、アプリをアンインストールすることで、ローカルに保存されたすべてのデータを削除できます。クラウドに保存されたデータについては、お問い合わせいただければ削除いたします。

### 7. 子どものプライバシー

本アプリは、13歳未満の子どもから直接個人情報を収集することを意図していません。保護者の方が、お子様の情報を記録する形でご利用ください。

### 8. プライバシーポリシーの変更

本プライバシーポリシーは、必要に応じて変更されることがあります。変更後のプライバシーポリシーは、本アプリ内に掲示された時点より効力を生じます。

### 9. お問い合わせ

本プライバシーポリシーに関するお問い合わせは、アプリ内の「お問い合わせ」よりご連絡ください。

制定日：2026年1月18日

## 技術スタック

- **フレームワーク**: Flutter 3.10+
- **状態管理**: Provider
- **ローカルDB**: Hive
- **広告**: Google AdMob
- **アプリ内課金**: RevenueCat
- **クラウドバックアップ**: Firebase (Auth/Firestore/Storage)
- **主要パッケージ**:
  - google_fonts: Noto Sans JP フォント
  - image_picker: 画像選択
  - image: 画像最適化
  - share_plus: 共有機能
  - intl: 日付フォーマット
  - google_mobile_ads: 広告
  - purchases_flutter: RevenueCat
  - firebase_core/firebase_auth/cloud_firestore/firebase_storage: バックアップ

## プロジェクト構造

```
lib/
├── main.dart                    # アプリエントリーポイント
├── firebase_options.dart        # Firebase設定
├── theme/
│   └── app_theme.dart          # デザインシステム、カラーパレット
├── models/
│   ├── child_profile.dart      # 子供のプロフィールモデル
│   └── milestone_record.dart   # マイルストーン記録モデル
├── services/
│   ├── database_service.dart   # Hive データベースサービス
│   ├── milestone_service.dart  # マイルストーンテンプレート管理
│   ├── ad_service.dart         # AdMob広告管理
│   ├── backup_service.dart     # Firebaseバックアップ/復元
│   └── image_optimizer.dart    # 画像最適化ヘルパー
├── providers/
│   ├── child_provider.dart     # 子供プロフィール状態管理
│   └── milestone_provider.dart # マイルストーン記録状態管理
│   └── purchase_provider.dart  # Pro版購入状態管理
├── screens/
│   ├── main_screen.dart                    # メイン画面（ボトムナビゲーション）
│   ├── profile_registration_screen.dart    # プロフィール登録画面
│   ├── home_screen.dart                    # ホーム画面
│   ├── milestones_screen.dart              # マイルストーン一覧画面
│   ├── record_screen.dart                  # 記録画面
│   ├── timeline_screen.dart                # タイムライン画面
│   └── settings_screen.dart                # 設定画面
└── widgets/
    ├── milestone_card.dart     # マイルストーンカードウィジェット
    └── banner_ad_widget.dart   # バナー広告ウィジェット
```

## セットアップ手順

### 前提条件

- Flutter SDK 3.10.4 以上
- Dart 3.10.0 以上
- iOS: Xcode 14 以上 (iOS 11.0+)
- Android: Android Studio (Android 5.0+)

### インストール

1. **リポジトリのクローンまたはプロジェクトのダウンロード**

2. **依存関係のインストール**

```bash
cd first_steps
flutter pub get
```

3. **Firebase セットアップ**

- FlutterFire CLI で `firebase_options.dart` を生成してください。
- Firebase Authentication / Firestore / Storage を有効化してください。

4. **RevenueCat/AdMob の設定**

- `lib/providers/purchase_provider.dart` の `REVENUECAT_PUBLIC_API_KEY` を設定
- `lib/services/ad_service.dart` / `lib/widgets/banner_ad_widget.dart` の広告ユニットIDを設定

5. **Hive アダプターの生成**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### ビルドと実行

#### iOS シミュレーター / デバイスで実行

```bash
# シミュレーターで実行
flutter run

# 特定のデバイスを指定
flutter devices
flutter run -d <device_id>
```

#### Android エミュレーター / デバイスで実行

```bash
# エミュレーターで実行
flutter run

# 特定のデバイスを指定
flutter devices
flutter run -d <device_id>
```

#### リリースビルド

```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release
# または
flutter build appbundle --release
```

## デザインコンセプト

### カラーパレット

- **メインテキスト**: ダークネイビー (#2C3E50)
- **アクセント**: ベビーブルー (#87CEEB)
- **背景**: ホワイト (#FFFFFF)
- **カード背景**: ライトグレー (#F5F5F5)
- **成功/完了**: グリーン (#4CAF50)

### タイポグラフィ

- **フォント**: Noto Sans JP
- モダンなサンセリフ体で統一
- 情報の優先度をフォントサイズと太さで表現

### UIコンポーネント

- 角丸のコンポーネントで柔らかい印象
- シンプルなラインアイコンで統一
- 十分な余白でミニマルなデザイン

## 開発のポイント

### 状態管理

- Providerパターンを採用
- `ChildProvider`: 子供のプロフィール管理
- `MilestoneProvider`: マイルストーン記録管理

### データ永続化

- Hiveを使用したローカルストレージ
- TypeAdapterによる型安全なデータ管理
- 2つのBox:
  - `child_profile`: 子供のプロフィール
  - `milestone_records`: マイルストーン記録

### アーキテクチャ

- レイヤーの明確な分離:
  - **Presentation**: Screens & Widgets
  - **Business Logic**: Providers
  - **Data**: Services & Models
- 保守性と拡張性を重視した設計

## 今後の機能拡張 (Pro版)

- 広告の非表示
- 複数の子供登録
- PDF/画像一括出力
- クラウドバックアップ
- カスタムマイルストーン

## ライセンス

このプロジェクトは個人開発のMVPです。

## 問い合わせ

アプリに関するお問い合わせは、設定画面の「お問い合わせ」からご連絡ください。
