#!/bin/bash
#
# RedditRadon Mono Ligaturizer
# 
# This script:
# 1. Adds FiraCode ligatures to non-italic RedditRadon Mono fonts
# 2. Processes italic fonts through FontForge for consistency
# 3. Outputs all 10 fonts ready for installation
#
# Usage: bash fonts/RedditRadonMono/RedditRadonMono.sh
#

set -e  # Exit on error

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
INPUT_DIR="$SCRIPT_DIR"
OUTPUT_DIR="$PROJECT_DIR/fonts/output/RedditRadonMono"

cd "$PROJECT_DIR"

echo "=============================================="
echo "  RedditRadon Mono Ligaturizer"
echo "=============================================="
echo ""
echo "Source:  $INPUT_DIR"
echo "Output:  $OUTPUT_DIR"
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Step 1: Ligaturize non-italic fonts
echo "=== Step 1: Adding ligatures to non-italic fonts ==="
echo ""

for weight in Bold Light Medium Regular SemiBold; do
    input_file="$INPUT_DIR/RedditRadonMono-${weight}.otf"
    if [ -f "$input_file" ]; then
        echo "Processing: RedditRadonMono-${weight}.otf"
        fontforge -lang py -script ligaturize.py "$input_file" \
            --output-dir="$OUTPUT_DIR" \
            --preserve-metadata 2>&1 | grep -E "Ligaturizing|saving to|ligatures from" || true
        echo ""
    else
        echo "Warning: $input_file not found, skipping"
    fi
done

# Step 2: Process italic fonts through FontForge for consistency
echo "=== Step 2: Processing italic fonts for consistency ==="
echo ""

for weight in Bold Light Medium Regular SemiBold; do
    # Map weight to italic filename
    if [ "$weight" = "Regular" ]; then
        italic_file="$INPUT_DIR/RedditRadonMono-Italic.otf"
        output_name="RedditRadonMono-Italic.otf"
    else
        italic_file="$INPUT_DIR/RedditRadonMono-${weight}Italic.otf"
        output_name="RedditRadonMono-${weight}Italic.otf"
    fi
    
    if [ -f "$italic_file" ]; then
        echo "Processing: $(basename "$italic_file")"
        fontforge -lang py -c "
import fontforge
font = fontforge.open('$italic_file')
font.upos += font.uwidth  # Same workaround as ligaturize.py
font.generate('$OUTPUT_DIR/$output_name')
font.close()
" 2>&1 | grep -v "^Copyright\|^License\|^Based on\|^Version:\|^Core python\|^Error saving\|contextual rule" || true
        echo "  Saved to: $OUTPUT_DIR/$output_name"
    else
        echo "Warning: $italic_file not found, skipping"
    fi
done

echo ""
echo "=============================================="
echo "  Done!"
echo "=============================================="
echo ""
echo "All fonts are ready in:"
echo "  $OUTPUT_DIR"
echo ""
echo "Contents:"
for f in "$OUTPUT_DIR"/*.otf; do
    echo "  $(basename "$f")"
done
echo ""
echo "Install all fonts from this directory for proper Font Book grouping."
