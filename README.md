# mewgenics_lyrics_patcher

**mewgenics_lyrics_patcher** replaces all boss music in *Mewgenics* with the regular battle theme (where possible) to remove the annoying lyrics.

---

## Features

- Automatically replaces all `*_boss*.ogg` files with corresponding `_battle.ogg`.
- Supports **Windows** and **Linux/Steam Deck**.
- Exception list via `exceptions.txt` to skip specific folders.
- Non-destructive: you can revert changes using Steam’s **Verify Game Files** feature.

---

## Installation

1. **Unpack the respective folder** (`windows` or `steamdeck`) into your **Mewgenics directory**.

2. **Windows only:**
   Download the [GPAK Extractor](https://github.com/ShootMe/GPAK-Extractor/releases) into the same directory to extract the game files.

3. **Linux/Steam Deck:**
   The script handles download of GPAK Extractor automatically.

---

## Usage

### Windows

1. Run `patch.bat` to patch the music.
2. If using Steam, you can add the script to **Steam Launch Options**:

### Linux / Steam Deck

1. Make sure scripts are executable:
```bash
chmod +x patch.sh patch_wrapper.sh
```
2. Add patch_wrapper.sh to your Steam Launch Options:
3. Patching may take some time on Steam Deck.

### Exceptions
Do you like a certain song and do not want it removed? I like the moon song for example. Simply add the level name to exceptions.txt, this works on linux and windows.
A picture with all the level names is attached. Naturally this contains SPOILERS!!!.

<details>
  <summary>Spoiler warning</summary>
![Level Names](https://github.com/nosebeggar/mewgenics_lyrics_patcher/blob/ae2562d195e5d0f73402c131d75864bd36f2ff6a/SPOILER%20-%20LEVEL%20NAMES.PNG "Spoilers")
</details>

---

## Reverting Changes

To revert to the original music, use Steam’s Verify Game Files feature:
Right-click Mewgenics in Steam → Properties → Local Files → Verify Integrity of Game Files.
Steam will restore any replaced or missing files.

---

## Contributing

Pull requests are welcome!
If you find bugs or have ideas to improve the patcher, feel free to submit a PR or open an issue.

---

## License

This software is provided "as is", without warranty of any kind. See LICENSE for details.
