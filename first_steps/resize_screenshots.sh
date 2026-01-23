#!/bin/bash

# App Store用スクリーンショットリサイズスクリプト
# 現在のサイズ: 768x1376 px
# 必要なサイズ: 1290x2796 px (iPhone 6.7")

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INPUT_DIR="$SCRIPT_DIR/assets/store/screenshot"
OUTPUT_DIR="$SCRIPT_DIR/assets/store/screenshot_resized"

# 出力ディレクトリを作成
mkdir -p "$OUTPUT_DIR"

echo "スクリーンショットをApp Store用にリサイズします..."
echo "入力ディレクトリ: $INPUT_DIR"
echo "出力ディレクトリ: $OUTPUT_DIR"
echo ""

# ImageMagickがインストールされているか確認
if ! command -v convert &> /dev/null; then
    echo "エラー: ImageMagickがインストールされていません。"
    echo "以下のコマンドでインストールしてください:"
    echo "  brew install imagemagick"
    exit 1
fi

# 6.7"サイズにリサイズ (1290x2796)
TARGET_WIDTH=1290
TARGET_HEIGHT=2796

for file in "$INPUT_DIR"/*.png; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        output_file="$OUTPUT_DIR/$filename"

        echo "処理中: $filename"

        # 背景を白にしてアスペクト比を保ちながらリサイズ
        # -resize: 画像を指定サイズに収まるようにリサイズ
        # -background white: 背景を白に
        # -gravity center: 中央配置
        # -extent: キャンバスサイズを指定
        convert "$file" \
            -resize "${TARGET_WIDTH}x${TARGET_HEIGHT}" \
            -background white \
            -gravity center \
            -extent "${TARGET_WIDTH}x${TARGET_HEIGHT}" \
            "$output_file"

        echo "  → $output_file に保存しました"
    fi
done

echo ""
echo "完了！リサイズされたスクリーンショットは以下のディレクトリにあります:"
echo "$OUTPUT_DIR"
echo ""
echo "次のステップ:"
echo "1. リサイズされたスクリーンショットを確認してください"
echo "2. App Store Connectでこれらのスクリーンショットをアップロードしてください"
