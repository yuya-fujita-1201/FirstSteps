#!/bin/bash

# iPad用スクリーンショットリサイズスクリプト
# iPad 13インチ用: 2064 x 2752px

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INPUT_DIR="$SCRIPT_DIR/assets/store/screenshot"
OUTPUT_DIR="$SCRIPT_DIR/assets/store/screenshot_ipad"

# 出力ディレクトリを作成
mkdir -p "$OUTPUT_DIR"

echo "iPad用スクリーンショットを作成します..."
echo "入力ディレクトリ: $INPUT_DIR"
echo "出力ディレクトリ: $OUTPUT_DIR"
echo ""

# iPad 13インチサイズ (2064 x 2752)
TARGET_WIDTH=2064
TARGET_HEIGHT=2752

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
echo "完了！iPad用スクリーンショットは以下のディレクトリにあります:"
echo "$OUTPUT_DIR"
