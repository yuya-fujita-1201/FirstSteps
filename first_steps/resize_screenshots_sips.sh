#!/bin/bash

# App Store用スクリーンショットリサイズスクリプト（sips版）
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

# 6.7"サイズにリサイズ (1290x2796)
TARGET_WIDTH=1290
TARGET_HEIGHT=2796

for file in "$INPUT_DIR"/*.png; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        output_file="$OUTPUT_DIR/$filename"

        echo "処理中: $filename"

        # ファイルをコピー
        cp "$file" "$output_file"

        # アスペクト比を保持しながらリサイズ
        sips -z "$TARGET_HEIGHT" "$TARGET_WIDTH" "$output_file" > /dev/null 2>&1

        echo "  → $output_file に保存しました (${TARGET_WIDTH}x${TARGET_HEIGHT})"
    fi
done

echo ""
echo "完了！リサイズされたスクリーンショットは以下のディレクトリにあります:"
echo "$OUTPUT_DIR"
echo ""
echo "リサイズ後のサイズを確認:"
for file in "$OUTPUT_DIR"/*.png; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        size=$(sips -g pixelWidth -g pixelHeight "$file" 2>/dev/null | grep -E 'pixelWidth|pixelHeight' | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
        echo "  $filename: $size"
    fi
done
echo ""
echo "次のステップ:"
echo "1. リサイズされたスクリーンショットを確認してください"
echo "2. App Store Connectでこれらのスクリーンショットをアップロードしてください"
