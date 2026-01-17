# iOS 実機クラッシュ引き継ぎ（2026-01-17）

## 概要
- 目的: Flutter iOS 実機（iPhone15,4 / iOS 26.2）でアプリ起動までの動作確認
- 現状: **インストール成功**するが、起動時にクラッシュ/白画面停止が発生
- 開発者証明書の「信頼」設定は実施済み

## 最終的に確認できたクラッシュ原因（ログより）
### 1) Firebase Storage プラグイン登録時の SIGSEGV（解決済み）
- クラッシュログ:
  - `static FLTFirebaseStoragePlugin.register(with:)` で `swift_getObjectType` が NULL 参照
- 対応:
  - Firebase 関連を **最新版へ更新**
  - プロジェクト全体のクリーン（Pods / build / .dart_tool / .symlinks など）を実施

### 2) Google Mobile Ads SDK の App ID 未設定（解決済み）
- エラー:
  - `GADInvalidInitializationException: ... initialized without an application ID`
- 対応:
  - `ios/Runner/Info.plist` に **テスト用 App ID** を追加
  - 追加済み:
    - `GADApplicationIdentifier = ca-app-pub-3940256099942544~1458002511`

### 3) それでも **起動時クラッシュ継続**
- 上記対応後も起動時に落ちる/白画面で停止
- 最新のクラッシュログはまだ取得できていない（次回取得が必要）

---

## 実施した主な変更
### pubspec.yaml
- Firebase / share_plus を最新版に更新
  - `firebase_core: ^4.3.0`
  - `firebase_auth: ^6.1.3`
  - `cloud_firestore: ^6.1.1`
  - `firebase_storage: ^13.0.5`
  - `share_plus: ^12.0.1`

### ios/Podfile
- iOS deployment target を **15.0 に引き上げ**
- CocoaPods の gRPC modulemap パス補正フックを追加
- RevenueCat の `SubscriptionPeriod` 競合回避パッチを追加
- 最終状態: `use_frameworks! :linkage => :static` で構成

### ios/Runner/Info.plist
- AdMob テスト App ID を追加済み
  - `GADApplicationIdentifier = ca-app-pub-3940256099942544~1458002511`

### 削除/クリーン
- 一度すべてクリーンして再生成済み
  - `ios/Pods`, `ios/Podfile.lock`, `ios/.symlinks`, `build`, `.dart_tool`, `packages/firebase_*`

---

## 重要なログ（抜粋）
### A. Firebase Storage プラグイン登録時の SIGSEGV
```
static FLTFirebaseStoragePlugin.register(with:)
GeneratedPluginRegistrant.registerWithRegistry
AppDelegate.application(_:didFinishLaunchingWithOptions:)
EXC_BAD_ACCESS (SIGSEGV)
```

### B. AdMob App ID 未設定
```
GADInvalidInitializationException
reason: The Google Mobile Ads SDK was initialized without an application ID.
```

---

## 現在のビルド/実行フロー
1. `flutter pub get`
2. `pod install` (ios/)
3. `flutter run -d 00008120-001670D43498201E`

---

## 次回やること（推奨順）
1. **最新のクラッシュログ取得**
   - Xcode → Window → Devices and Simulators → iPhone → View Device Logs
   - 直近の `Runner` のクラッシュログを貼り付け
2. もし白画面で固まるだけなら、**起動直後のログ取得**
   - `flutter logs -d 00008120-001670D43498201E`
3. AdMob / Firebase の初期化コード側で例外がないか確認
   - `main.dart` や `AppDelegate` で Firebase 初期化が二重になっていないか

---

## 参考情報
- デバイス: iPhone15,4
- iOS: 26.2 (23C55)
- チームID: 5CMYP437MX
- バンドルID: com.example.firstSteps
- アプリバージョン: 1.1.0 (2)

