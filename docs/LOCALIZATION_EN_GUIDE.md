# 英語対応（全画面） 指示書

目的
- 既存の日本語版アプリをベースに、全画面を英語対応する。
- 端末言語が英語のとき、アプリ名は "First Steps" にする。

対象プロジェクト
- /Users/yuyafujita/Desktop/workspaces/FirstSteps/first_steps

前提（現状確認）
- Flutter アプリ。
- lib/main.dart に `locale: const Locale('ja')` があるため、現在は日本語固定。
- Android は `AndroidManifest.xml` の android:label が直接文字列。


---

1. Flutter の多言語化（画面テキスト）

1) 日本語固定を解除
- 対象: first_steps/lib/main.dart
- `locale: const Locale('ja')` を削除。
  - 端末言語で自動切替にする。
  - 言語切替UIを作る場合は、この locale を動的に設定。

2) l10n 設定を用意
- `first_steps/l10n.yaml` を追加。
- 例:

  arb-dir: lib/l10n
  template-arb-file: app_ja.arb
  output-localization-file: app_localizations.dart
  output-class: AppLocalizations
  preferred-supported-locales: [ja, en]
  use-deferred-loading: false

3) ARB を作成
- `first_steps/lib/l10n/app_ja.arb`
- `first_steps/lib/l10n/app_en.arb`
- 画面内の日本語文字列をすべて ARB に集約。
- 例:

  // app_ja.arb
  {
    "appTitle": "はじめてメモ",
    "ok": "OK"
  }

  // app_en.arb
  {
    "appTitle": "First Steps",
    "ok": "OK"
  }

4) 画面の文字列置換
- `AppLocalizations.of(context)!` を使って文字列を参照。
- 例:

  AppLocalizations.of(context)!.appTitle

- 対象フォルダ: `first_steps/lib/` 配下の画面・ウィジェット。
  - 目安: `lib/screens/`, `lib/widgets/` を中心に全置換。

5) テキストのフォーマット
- 既に intl を使用しているため、日付/数値のフォーマットは
  `DateFormat` などを locale 付きで使う。
- 例: `DateFormat.yMMMd(Localizations.localeOf(context).toString())`

6) 動作確認
- 端末言語を英語/日本語に切り替えて画面表示を確認。
- フォールバック: 未翻訳キーがあればすべて埋める。


---

2. Android のアプリ名（言語別）

1) Manifest の label を文字列参照にする
- 対象: `first_steps/android/app/src/main/AndroidManifest.xml`
- 変更:
  - Before: android:label="はじめてメモ"
  - After:  android:label="@string/app_name"

2) strings.xml を言語別に追加
- デフォルト（values）:
  - `first_steps/android/app/src/main/res/values/strings.xml`
  - 内容例:
    <resources>
      <string name="app_name">はじめてメモ</string>
    </resources>

- 英語（values-en）:
  - `first_steps/android/app/src/main/res/values-en/strings.xml`
  - 内容例:
    <resources>
      <string name="app_name">First Steps</string>
    </resources>

3) 確認
- 端末言語を英語にすると、ホーム画面のアプリ名が "First Steps" になる。


---

3. iOS のアプリ名（言語別）

- Xcode の `Runner/Info.plist` ではなく、
  `Runner/InfoPlist.strings` を言語別に作成する。
- 例:
  - `ios/Runner/en.lproj/InfoPlist.strings`
  - `ios/Runner/ja.lproj/InfoPlist.strings`

- キー:
  - CFBundleDisplayName = "First Steps" / "はじめてメモ"


---

4. 仕上げチェックリスト

- [ ] 画面内の固定文言が ARB に全移動
- [ ] `locale: const Locale('ja')` を削除
- [ ] 英語表示で UI 崩れがないか（特にボタン/ラベル幅）
- [ ] Android アプリ名の英語切替 OK
- [ ] Store 文言（説明文/スクリーンショット）も英語化が必要なら別途対応


---

