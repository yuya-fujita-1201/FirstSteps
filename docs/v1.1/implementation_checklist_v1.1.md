# v1.1 実装チェックリスト

このチェックリストは、AI開発エージェント（Claude CLI、Codexなど）がv1.1の実装を完了したかを確認するためのものです。

---

## 1. 依存関係の追加

- [ ] `google_mobile_ads` パッケージが `pubspec.yaml` に追加されている
- [ ] `purchases_flutter` (RevenueCat) パッケージが追加されている
- [ ] `image` パッケージが追加されている
- [ ] `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage` が追加されている
- [ ] `flutter pub get` が正常に完了している

---

## 2. 品質改善

### 2.1. 画像の最適化

- [ ] 画像を最適化するヘルパー関数が実装されている
- [ ] 長辺が1024pxを超える画像がリサイズされる
- [ ] JPEG形式、品質85%で圧縮される
- [ ] `record_screen.dart` で画像保存時にこの関数が呼び出されている
- [ ] `profile_registration_screen.dart` で画像保存時にこの関数が呼び出されている

### 2.2. エラーハンドリング

- [ ] `database_service.dart` の全メソッドが `try-catch` で囲まれている
- [ ] `record_screen.dart` の画像選択・保存処理が `try-catch` で囲まれている
- [ ] エラー発生時に `SnackBar` でユーザーフレンドリーなメッセージが表示される

---

## 3. 広告機能 (Google AdMob)

### 3.1. 初期化

- [ ] `main.dart` で `MobileAds.instance.initialize()` が呼び出されている

### 3.2. バナー広告

- [ ] `widgets/banner_ad_widget.dart` が作成されている
- [ ] `home_screen.dart` にバナー広告が配置されている
- [ ] `timeline_screen.dart` にバナー広告が配置されている
- [ ] `milestones_screen.dart` にバナー広告が配置されている

### 3.3. インタースティシャル広告

- [ ] `services/ad_service.dart` が作成されている
- [ ] 3回に1回の頻度で広告が表示されるロジックが実装されている
- [ ] `record_screen.dart` で記録保存後に `showInterstitialAd()` が呼び出されている

---

## 4. アプリ内課金 (RevenueCat) とPro版機能

### 4.1. 基本設定

- [ ] `providers/purchase_provider.dart` が作成されている
- [ ] RevenueCatの初期化ロジックが実装されている
- [ ] `isPro` 状態が管理されている
- [ ] 購入処理が実装されている
- [ ] `main.dart` で `PurchaseProvider` が `MultiProvider` に追加されている

### 4.2. UI統合

- [ ] `settings_screen.dart` に「Pro版にアップグレード」ボタンが表示される（未購入時）
- [ ] `settings_screen.dart` に「Pro版をご利用中です」が表示される（購入済み時）
- [ ] Pro版ユーザーには広告が表示されない

### 4.3. クラウドバックアップ (Firebase)

- [ ] `firebase_options.dart` がプロジェクトに追加されている
- [ ] `main.dart` で `Firebase.initializeApp()` が呼び出されている
- [ ] `services/backup_service.dart` が作成されている
- [ ] 匿名認証でサインインするロジックが実装されている
- [ ] `backupToFirebase()` メソッドが実装されている
- [ ] `restoreFromFirebase()` メソッドが実装されている
- [ ] `settings_screen.dart` に「バックアップ」ボタンが追加されている（Pro版限定）
- [ ] `settings_screen.dart` に「復元」ボタンが追加されている（Pro版限定）

### 4.4. 複数人の子供登録

- [ ] `child_provider.dart` が `List<ChildProfile>` を管理するように変更されている
- [ ] `currentChild` プロパティが追加されている
- [ ] `home_screen.dart` に子供切り替えUIが追加されている（2人以上の場合のみ表示）
- [ ] 新しい子供を追加する導線が追加されている（Pro版限定）

---

## 5. ドキュメント更新

- [ ] `README.md` が更新されている
- [ ] 追加された機能（広告、Pro版）が記載されている
- [ ] Firebaseのセットアップ手順が記載されている

---

## 6. テスト

- [ ] アプリがビルドエラーなくコンパイルできる
- [ ] 広告が正しく表示される（テストIDを使用）
- [ ] Pro版購入フローが動作する（テスト環境）
- [ ] 画像最適化が正しく動作する
- [ ] エラーハンドリングが正しく動作する
