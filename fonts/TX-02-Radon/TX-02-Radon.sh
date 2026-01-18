#!/bin/bash
#
# TX-02-Radon Ligaturizer
# 
# This script:
# 1. Adds FiraCode ligatures to non-italic TX-02-Radon fonts
# 2. Processes italic fonts through FontForge for consistency
# 3. Outputs all 10 fonts ready for installation
#
# Usage: bash fonts/TX-02-Radon/TX-02-Radon.sh
#

set -e  # Exit on error

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
INPUT_DIR="$SCRIPT_DIR"
OUTPUT_DIR="$PROJECT_DIR/fonts/output/TX-02-Radon"

cd "$PROJECT_DIR"

echo "=============================================="
echo "  TX-02-Radon Ligaturizer"
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
    input_file="$INPUT_DIR/TX-02-Radon-${weight}.ttf"
    if [ -f "$input_file" ]; then
        echo "Processing: TX-02-Radon-${weight}.ttf"
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
        italic_file="$INPUT_DIR/TX-02-Radon-Italic.otf"
        output_name="TX-02-Radon-Italic.otf"
    else
        italic_file="$INPUT_DIR/TX-02-Radon-${weight}Italic.otf"
        output_name="TX-02-Radon-${weight}Italic.otf"
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

# Step 3: Make Regular consistent with other fonts (FontForge changes isFixedPitch inconsistently)
echo ""
echo "=== Step 3: Ensuring consistent metadata ==="

if [ -d "$PROJECT_DIR/.venv" ]; then
    source "$PROJECT_DIR/.venv/bin/activate"
    python3 << 'PYTHON_SCRIPT'
from fontTools.ttLib import TTFont
import os

output_dir = 'fonts/output/TX-02-Radon'

# Make all fonts have consistent isFixedPitch (match what FontForge does to most fonts: 0)
for filename in os.listdir(output_dir):
    if not (filename.endswith('.ttf') or filename.endswith('.otf')):
        continue
    
    path = os.path.join(output_dir, filename)
    font = TTFont(path)
    
    if font['post'].isFixedPitch != 0:
        font['post'].isFixedPitch = 0
        font.save(path)
        print(f"  {filename}: set isFixedPitch=0 for consistency")
    
    font.close()

print("  All fonts now have consistent metadata")
PYTHON_SCRIPT
else
    echo "Warning: .venv not found"
fi

echo ""
echo "=============================================="
echo "  Done!"
echo "=============================================="
echo ""
echo "All fonts are ready in:"
echo "  $OUTPUT_DIR"
echo ""
echo "Contents:"
for f in "$OUTPUT_DIR"/*; do
    if [ -f "$f" ]; then
        echo "  $(basename "$f")"
    fi
done
echo ""
echo "Install all fonts from this directory for proper Font Book grouping."
