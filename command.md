今後、ご自身で実機確認する場合のコマンドをお伝えします。

# ディレクトリ移動

```bash
cd /Users/yuyafujita/Desktop/workspaces/FirstSteps/first_steps
# または、現在のディレクトリから:
cd ~/Desktop/workspaces/FirstSteps/first_steps
```

# iPhone実機で起動

```bash
flutter run -d 00008120-001670D43498201E
```

または、デバイスIDを指定せずに:

```bash
flutter run
```
（複数デバイスがある場合は選択画面が表示されます）

# ホットリロード（アプリ起動中）

アプリ起動中にコード変更した場合:

- `r` を入力してEnter - ホットリロード（画面更新）
- `R` を入力してEnter - ホットリスタート（アプリ全体再起動）
- `q` を入力してEnter - アプリ終了

# 便利なコマンド

## 接続されているデバイスを確認
```bash
flutter devices
```

## コードの問題をチェック
```bash
flutter analyze
```

## アプリをクリーンビルド（問題がある場合）
```bash
flutter clean && flutter run
```

# Gitコマンド（コードの同期）

## リモートの変更を取り込む（プル）
```bash
# プロジェクトのルートディレクトリに移動（もし first_steps 内にいる場合）
cd ..

# 変更を取り込む
git pull origin main
```

## ローカルの変更を保存して送信（コミット＆プッシュ）
```bash
# プロジェクトのルートディレクトリであることを確認
# 全ての変更をステージング
git add .

# 変更をコミット（メッセージは適宜変更してください）
git commit -m "変更内容の要約"

# リモートに送信
git push origin main
```