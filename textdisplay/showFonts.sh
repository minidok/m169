#!/bin/sh
# Zeigt alle installierten flf-Fonts fuer filget an

for font in /usr/share/figlet/fonts/*.flf; do
    echo "Font: $(basename "$font")"
    figlet -f "$(basename "$font" .flf)" "Schrift"
done
