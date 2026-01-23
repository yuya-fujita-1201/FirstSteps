# iOS App Store リリースガイド

このガイドは、「はじめてメモ」をiOS App Storeに公開するための手順をまとめたものです。

## 前提条件

- ✅ Apple Developer Program 登録済み
- ✅ Bundle ID: `marumi.works.hajimetememo`
- ✅ スクリーンショット準備済み
- ✅ プライバシーポリシーURL準備済み

## ⚠️ 重要：Firebase設定の更新が必要

Bundle IDを変更したため、**Firebase Consoleで新しいiOSアプリを登録する必要があります**。

### Firebase Console での作業

1. [Firebase Console](https://console.firebase.google.com/) にアクセス
2. プロジェクト `first-steps-7d383` を選択
3. 「プロジェクトの設定」→「アプリを追加」→「iOS」を選択
4. Apple バンドルID: `marumi.works.hajimetememo` を入力
5. アプリのニックネーム: `はじめてメモ (iOS)` を入力
6. App Store ID: 公開後に追加（今は空欄でOK）
7. 「アプリを登録」をクリック
8. **新しい `GoogleService-Info.plist` をダウンロード**
9. ダウンロードしたファイルで `first_steps/ios/Runner/GoogleService-Info.plist` を置き換え

### Firebase サービスの有効化確認

- Authentication: 匿名認証が有効になっているか確認
- Firestore Database: データベースが作成されているか確認
- Storage: ストレージバケットが作成されているか確認

## 📱 Step 1: Xcodeでの署名設定

### 1.1 Xcodeでプロジェクトを開く

```bash
cd first_steps/ios
open Runner.xcworkspace
```

⚠️ **重要**: `Runner.xcodeproj` ではなく、**`Runner.xcworkspace`** を開いてください（CocoaPodsを使用しているため）。

### 1.2 署名とケイパビリティの設定

1. Xcodeの左ペインで `Runner` プロジェクトをクリック
2. `TARGETS` > `Runner` を選択
3. `Signing & Capabilities` タブを開く
4. `Team` を選択（Apple Developer Programのチーム）
5. `Bundle Identifier` が `marumi.works.hajimetememo` になっていることを確認
6. 自動署名を有効にする場合:
   - `Automatically manage signing` にチェック
7. 手動署名の場合:
   - プロビジョニングプロファイルを選択

### 1.3 ビルド設定の確認

1. `Runner` プロジェクト > `Build Settings` を開く
2. `Deployment Target` を確認（iOS 11.0以上）
3. `Marketing Version` が `1.1.0` になっているか確認
4. `Current Project Version` が `4` になっているか確認

## 📦 Step 2: アーカイブの作成

### 2.1 デバイスターゲットの選択

1. Xcodeの上部ツールバーで、スキーム（Runner）の横のデバイス選択メニューをクリック
2. `Any iOS Device (arm64)` を選択

### 2.2 アーカイブの実行

1. メニューバー > `Product` > `Archive` をクリック
2. ビルドが完了するまで待つ（数分かかる場合があります）
3. エラーが出た場合:
   - CocoaPods の依存関係を更新:
     ```bash
     cd ios
     pod install
     ```
   - Xcodeを再起動して再度 `Archive` を実行

### 2.3 アーカイブの確認

`Organizer` ウィンドウが自動的に開きます。
- アーカイブが一覧に表示されていることを確認
- バージョン番号（1.1.0）とビルド番号（4）を確認

## 🚀 Step 3: App Store Connect へのアップロード

### 3.1 アップロードの実行

1. `Organizer` ウィンドウで、作成したアーカイブを選択
2. `Distribute App` ボタンをクリック
3. 配信方法の選択:
   - `App Store Connect` を選択
   - `Next` をクリック
4. 配信オプション:
   - `Upload` を選択
   - `Next` をクリック
5. App Store Connect のオプション:
   - デフォルト設定のまま `Next` をクリック
6. 署名:
   - `Automatically manage signing` を選択（推奨）
   - `Next` をクリック
7. 確認画面:
   - 内容を確認して `Upload` をクリック
8. アップロード完了まで待つ（数分〜10分程度）

### 3.2 アップロード成功の確認

アップロードが成功すると、メールで通知が届きます（5〜15分後）。
- 件名: "App Store Connect: Version 1.1.0 (4) of はじめてメモ is being processed"

## 🎨 Step 4: App Store Connect での設定

### 4.1 App Store Connect にログイン

1. [App Store Connect](https://appstoreconnect.apple.com/) にアクセス
2. Apple ID でログイン

### 4.2 新規アプリの作成

1. `マイApp` をクリック
2. 左上の `+` ボタン > `新規App` をクリック
3. アプリ情報を入力:
   - **プラットフォーム**: iOS
   - **名前**: はじめてメモ
   - **プライマリ言語**: 日本語
   - **バンドルID**: `marumi.works.hajimetememo` を選択
   - **SKU**: `hajimetememo` (任意の一意な識別子)
   - **ユーザアクセス**: フルアクセス
4. `作成` をクリック

### 4.3 アプリ情報の入力

#### 一般情報
1. 左サイドバー > `一般` > `App情報` をクリック
2. 以下を入力:
   - **サブタイトル**: 赤ちゃんの成長の瞬間を記録
   - **カテゴリ**:
     - メイン: ライフスタイル
     - サブ: ヘルスケア/フィットネス（任意）
   - **年齢制限**: 4+

#### プライバシーポリシー
1. `App プライバシー` をクリック
2. `プライバシーポリシーを入力してください` をクリック
3. URL: `https://github.com/yuya-fujita-1201/FirstSteps/blob/main/first_steps/README.md`
4. `保存` をクリック

#### データの取り扱いについて
1. `App プライバシー` > `プライバシーの実践の編集` をクリック
2. 以下のデータ収集を申告:

**無料版で収集するデータ**:
- 識別子（広告用）
  - 目的: 広告配信
  - データはユーザーIDにリンクされていない

**Pro版で追加収集するデータ**:
- ユーザーコンテンツ（写真、テキスト）
  - 目的: クラウドバックアップ
  - データはユーザーIDにリンクされている
- 購入履歴
  - 目的: アプリ内課金の管理

### 4.4 価格と配信状況

1. 左サイドバー > `価格および配信可能状況` をクリック
2. 以下を設定:
   - **価格**: 無料
   - **配信地域**: すべての地域（または日本のみ）
3. `保存` をクリック

### 4.5 App内課金の設定

1. 左サイドバー > `App内課金` をクリック
2. RevenueCatで設定済みのサブスクリプションを登録:
   - `+` ボタンをクリック
   - サブスクリプションの詳細を入力（RevenueCatの設定に合わせる）

## 📝 Step 5: バージョン情報の入力

### 5.1 新規バージョンの準備

1. 左サイドバー > `App Store` タブをクリック
2. `iOS App` セクションで `+バージョンまたはプラットフォーム` をクリック
3. バージョン番号: `1.1.0` を入力
4. `作成` をクリック

### 5.2 バージョン情報の入力

#### 5.2.1 スクリーンショットのアップロード

1. `iPhone 6.7" ディスプレイ` セクションまでスクロール
2. スクリーンショットをドラッグ&ドロップ、または `+` をクリックしてアップロード
3. 順序を確認（ドラッグで並び替え可能）

⚠️ **スクリーンショットのサイズ要件**:
- 6.7": 1290 x 2796 px
- 6.5": 1242 x 2688 px
- 5.5": 1242 x 2208 px

現在のスクリーンショットサイズを確認:
```bash
cd first_steps/assets/store/screenshot
file *.png
```

必要に応じてリサイズ（ImageMagickなどを使用）:
```bash
# 例: 6.7"サイズにリサイズ
convert 01_YuiQRBYi.png -resize 1290x2796 01_resized.png
```

#### 5.2.2 プロモーション用テキスト（任意）

```
初めての笑顔、寝返り、ハイハイ…
特別な「はじめて」の瞬間を、写真とメモで簡単に記録。
シンプルで使いやすい育児マイルストーンアプリです。
```

#### 5.2.3 説明

`APP_STORE_LISTING.md` の「説明文」セクションをコピー&ペースト

#### 5.2.4 キーワード

```
育児,赤ちゃん,成長記録,マイルストーン,初めて,子育て,日記,アルバム,写真,メモ,タイムライン,共有,家族,子供,乳児,新生児,発達,記録
```

#### 5.2.5 サポートURL

```
https://github.com/yuya-fujita-1201/FirstSteps
```

#### 5.2.6 マーケティングURL（任意）

```
https://github.com/yuya-fujita-1201/FirstSteps
```

### 5.3 ビルドの選択

1. `ビルド` セクションまでスクロール
2. アップロードしたビルドが表示されない場合は、しばらく待ってページを更新
3. 表示されたら、`+` またはビルドを選択
4. 適切なビルド（1.1.0 / 4）を選択

### 5.4 一般App情報

#### 著作権
```
© 2026 Marumi Works
```

#### バージョンリリース
- `このバージョンを手動でリリース` を選択（推奨）
- または `このバージョンを審査後に自動的にリリース`

### 5.5 App審査情報

#### 連絡先情報
- 名前: （あなたの名前）
- 電話番号: （連絡可能な電話番号）
- メールアドレス: （連絡可能なメールアドレス）

#### サインイン情報（不要）
- デモアカウントは不要（アカウント不要のアプリのため）

#### 注意事項（任意）
```
このアプリは育児マイルストーン記録アプリです。
無料版では広告が表示されます。
Pro版のサブスクリプションで広告非表示、複数子供登録、クラウドバックアップが利用可能です。
```

## ✅ Step 6: 審査への提出

### 6.1 最終確認

すべての必須項目が入力されていることを確認:
- [ ] スクリーンショット
- [ ] 説明文
- [ ] キーワード
- [ ] サポートURL
- [ ] プライバシーポリシーURL
- [ ] ビルド選択
- [ ] 著作権
- [ ] 審査連絡先情報

### 6.2 提出

1. 右上の `審査に提出` ボタンをクリック
2. 確認ダイアログで `提出` をクリック
3. ステータスが「審査待ち」に変わることを確認

## 📊 審査プロセス

### 審査ステータス

1. **審査待ち** (Waiting for Review): 審査キューに入っている状態
2. **審査中** (In Review): 実際に審査されている状態（通常1〜3日）
3. **承認済み** (Approved): 審査に合格
4. **リリース準備完了** (Ready for Sale): App Storeで公開

### 審査期間

- 通常: 1〜3日
- 場合によっては: 数時間〜1週間

### 却下された場合

1. 却下理由を確認（App Store Connectとメールで通知）
2. 問題を修正
3. 必要に応じて新しいビルドをアップロード
4. 解決センターで返信
5. 再度審査に提出

### よくある却下理由

- スクリーンショットがガイドライン違反
- プライバシーポリシーが不十分
- アプリがクラッシュする
- 説明文と実際の機能が一致しない
- App内課金の説明が不明確

## 🎉 リリース後

### リリースの実行

審査承認後:
1. `手動リリース` を選択した場合:
   - App Store Connect > バージョン情報 > `このバージョンをリリース` をクリック
2. `自動リリース` を選択した場合:
   - 自動的にリリースされます

### App Storeでの公開確認

- App Storeアプリまたは https://apps.apple.com で検索
- 公開まで数時間かかる場合があります

### App Store ID の取得

1. App Store Connectでアプリを開く
2. `App情報` > `一般情報` に表示されているApp Store ID をコピー
3. Firebase Consoleに戻り、iOSアプリ設定にApp Store IDを追加（任意）

## 🔧 トラブルシューティング

### ビルドエラー

**エラー**: "No Provisioning Profile found"
- 解決: Xcode > Signing & Capabilities でチームを選択し、自動署名を有効化

**エラー**: CocoaPods関連のエラー
```bash
cd ios
pod deintegrate
pod install
```

**エラー**: Firebase関連のエラー
- 新しい `GoogleService-Info.plist` がダウンロードされているか確認
- Bundle IDが正しいか確認

### アップロードエラー

**エラー**: "App uses non-exempt encryption"
- App Store Connect > ビルド詳細 > Exportコンプライアンス情報を入力
- HTTPSのみを使用している場合は「いいえ」を選択

**エラー**: "Invalid Bundle"
- Info.plistの設定を確認
- Bundle IDが正しいか確認

### 審査での問題

**問題**: プライバシーポリシーが不十分
- プライバシーポリシーURLにアクセスできるか確認
- データ収集の詳細が記載されているか確認

**問題**: スクリーンショットがガイドライン違反
- スクリーンショットに誤解を招く表現がないか確認
- 実際のアプリ画面であることを確認

## 📚 参考リンク

- [App Store Connect](https://appstoreconnect.apple.com/)
- [App Store審査ガイドライン](https://developer.apple.com/jp/app-store/review/guidelines/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [App Store Connect ヘルプ](https://help.apple.com/app-store-connect/)

## 💡 ヒント

- 初回審査は時間がかかることがあります。余裕を持って提出しましょう
- スクリーンショットは最初に表示されるものが最も重要です
- キーワードは定期的に見直して最適化しましょう
- ユーザーレビューに迅速に対応することで、評価を維持できます
- アップデートは定期的に行い、ユーザーエンゲージメントを保ちましょう

---

準備が整ったら、自信を持って審査に提出しましょう！
