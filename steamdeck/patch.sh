#!/bin/bash

GAME_DIR="$HOME/.local/share/Steam/steamapps/common/Mewgenics/"
PROTON_BIN="$HOME/.local/share/Steam/steamapps/common/Proton 10.0/proton"
MUSIC_ROOT="Output/audio/music"
GAMEFILE="resources.gpak"
HASHFILE="hashsum.txt"
EXCEPTIONS_FILE="exceptions.txt"

cd "$GAME_DIR"

#Initial cleanup
rm -rf Output output.gpak



if [ ! -f "$GAMEFILE" ]; then
  echo "resources.gpak not found"
  exit 1
fi

if [ ! -f "GPAK.Extractor.exe" ]; then
  wget https://github.com/ShootMe/GPAK-Extractor/releases/download/1.1/GPAK.Extractor.exe || "$PROTON_BIN" run Mewgenics.exe
  exit 1
fi

CURRENT_HASH=$(sha256sum "$GAMEFILE" | awk '{print $1}')

if [ -f "$HASHFILE" ]; then
  STORED_HASH=$(cat "$HASHFILE")
  if [ "$CURRENT_HASH" == "$STORED_HASH" ]; then
    echo "Game already patched."
    "$PROTON_BIN" run Mewgenics.exe
    exit 0
  fi
fi

#Patching process
echo "Patching game"
"$PROTON_BIN" run GPAK.Extractor.exe resources.gpak


replaceSongs() {
    local dir="$1"

    # find a battle file (first match)
    local battle
    battle=$(find "$dir" -maxdepth 1 -name '*_battle.ogg' | head -n 1)

    # no battle file → nothing to do
    [[ -z "$battle" ]] && return

    find "$dir" -maxdepth 1 -name '*_boss*.ogg' | while read -r boss; do
        echo "Replacing $(basename "$boss") with $(basename "$battle")"
        cp -f "$battle" "$boss"
    done
}

while read -r dir; do
    folder="$(basename "$dir")"

    # skip folders listed in exceptions.txt (exact match)
    if grep -Fxq "$folder" "$EXCEPTIONS_FILE"; then
        echo "Skipped folder (exception): $folder"
        continue
    fi

    replaceSongs "$dir"
done < <(find "$MUSIC_ROOT" -mindepth 1 -maxdepth 1 -type d)


"$PROTON_BIN" run GPAK.Extractor.exe Output

rm -rf Output
mv output.gpak resources.gpak

sha256sum resources.gpak | awk '{print $1}' > "$HASHFILE"

echo "Patching done. The voices are gone."
"$PROTON_BIN" run Mewgenics.exe
