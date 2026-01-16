# AI開発エージェント向け指示書 (v1.1): 「はじめてメモ」機能追加・品質改善

## 0. あなたの役割

あなたは、既存のFlutterアプリケーション「はじめてメモ ~First Steps~」のv1.0コードベースを元に、v1.1へのアップデート作業を担当するシニアモバイルアプリ開発者です。提供されるv1.1仕様書に基づき、機能追加と品質改善を段階的に実装してください。

---

## 1. プロジェクトのゴール

現在のMVP (v1.0) に対し、以下の要件を実装し、ストア公開に向けた準備を整える。

1.  **広告機能 (Google AdMob) の実装**
2.  **Pro版 (買い切り) の導入 (RevenueCat)**
3.  **品質改善 (エラーハンドリング、画像最適化)**

**参照ドキュメント:** `app_specification_v2.md`

---

## 2. 開発ステップ

既存のコードベース (`/home/ubuntu/FirstSteps/first_steps`) に対して、以下の順序で変更を加えてください。

### Step 1: 準備と依存関係の追加

1.  `pubspec.yaml` を開き、以下のパッケージを `dependencies` に追加してください。

    ```yaml
    # 広告
    google_mobile_ads: ^5.1.0

    # アプリ内課金
    purchases_flutter: ^6.30.0 # RevenueCat

    # 画像処理
    image: ^4.1.7

    # Firebase (クラウドバックアップ用)
    firebase_core: ^3.1.1
    firebase_auth: ^5.1.1
    cloud_firestore: ^5.0.2
    firebase_storage: ^12.1.0
    ```

2.  ターミナルで `flutter pub get` を実行し、パッケージをインストールします。

### Step 2: 品質改善

#### A. 画像の最適化

1.  `image_picker` で画像を選択する処理（`record_screen.dart` や `profile_registration_screen.dart`）を修正します。
2.  選択された画像を保存する前に、`image` パッケージを使用して以下の処理を行うヘルパー関数を作成してください。
    - 長辺が1024pxを超える場合はリサイズする。
    - JPEG形式、品質85%で圧縮する。
3.  このヘルパー関数を呼び出し、最適化された画像を保存するように変更します。

#### B. エラーハンドリングの強化

1.  `database_service.dart` の各メソッド（データの読み書き）を `try-catch` ブロックで囲みます。
2.  `record_screen.dart` での画像選択・保存処理も同様に `try-catch` で囲みます。
3.  `catch` ブロック内で、`ScaffoldMessenger.of(context).showSnackBar()` を使用し、「処理に失敗しました。もう一度お試しください。」といったユーザーフレンドリーなエラーメッセージを表示してください。

### Step 3: 広告 (Google AdMob) の実装

1.  `main.dart` の `main` 関数内で `MobileAds.instance.initialize()` を呼び出し、AdMobを初期化します。
2.  `widgets` ディレクトリに `banner_ad_widget.dart` を作成します。このウィジェットは、アダプティブバナー広告をロードして表示する責務を持ちます。
3.  `home_screen.dart`, `timeline_screen.dart`, `milestones_screen.dart` のScaffoldの `bottomNavigationBar` の直前（またはbodyの最下部）に、作成した `BannerAdWidget` を配置します。
4.  `services` ディレクトリに `ad_service.dart` を作成します。
    - インタースティシャル広告をロードし、保持するロジックを実装します。
    - 広告を表示する `showInterstitialAd()` メソッドを定義します。このメソッドは、3回に1回の頻度で広告を表示するように内部でカウンターを管理します。
5.  `record_screen.dart` で記録の保存が成功した直後に、`AdService` の `showInterstitialAd()` を呼び出します。

### Step 4: アプリ内課金 (RevenueCat) とPro版機能の導入

#### A. 基本設定

1.  `providers` に `purchase_provider.dart` を作成します。このProviderは以下の役割を担います。
    - RevenueCatの初期化
    - ユーザーのPro版購入状態 (`isPro`) の管理
    - 購入処理の実行と状態の更新
2.  `main.dart` で `PurchaseProvider` を `MultiProvider` に追加します。
3.  `settings_screen.dart` を修正し、`PurchaseProvider` の状態に応じて以下のUIを表示します。
    - 未購入の場合: 「Pro版にアップグレード」ボタンを表示。
    - 購入済みの場合: 「Pro版をご利用中です」というテキストを表示。
4.  広告表示ロジック（Step 3で実装）を `PurchaseProvider` の `isPro` の値で囲み、Pro版ユーザーには広告が表示されないようにします。

#### B. クラウドバックアップ機能 (Firebase)

1.  Firebaseプロジェクトをセットアップし、`firebase_options.dart` をプロジェクトに追加します。（このステップは、あなたがFirebaseコンソールで行うことを想定しています）
2.  `main.dart` で `Firebase.initializeApp()` を呼び出します。
3.  `services` に `backup_service.dart` を作成します。
    - **ユーザー認証:** `firebase_auth` を使用して匿名認証でサインインするロジックを実装します。
    - **バックアップ:** HiveのBox（プロフィール、記録）の内容をFirestoreにアップロードする `backupToFirebase()` メソッドを実装します。画像は `firebase_storage` にアップロードします。
    - **リストア:** FirestoreとStorageからデータをダウンロードし、HiveのBoxを復元する `restoreFromFirebase()` メソッドを実装します。
4.  `settings_screen.dart` のPro版限定セクションに、「バックアップ」と「復元」ボタンを追加し、`BackupService` の各メソッドを呼び出すようにします。

#### C. 複数人の子供登録機能

1.  `child_provider.dart` をリファクタリングします。
    - 単一の `ChildProfile` ではなく、`List<ChildProfile>` を管理するように変更します。
    - 現在選択されている子供を管理する `currentChild` プロパティを追加します。
2.  `home_screen.dart` のAppBarなどに、子供を切り替えるためのUI（例: `DropdownButton`）を追加します。このUIは、子供が2人以上登録されている場合にのみ表示します。
3.  プロフィール登録画面 (`profile_registration_screen.dart`) を、新しい子供を追加する画面としても再利用できるように修正します。この画面への導線は、Pro版ユーザーにのみ表示します。

---

## 3. 成果物

- 上記のv1.1要件をすべて満たした、更新版のFlutterソースコード一式。
- `README.md` を更新し、追加された機能（広告、Pro版）や新しいセットアップ手順（Firebase関連など）を追記すること。
- 各機能がモジュール化され、既存のアーキテクチャに沿った形で実装されていること。
