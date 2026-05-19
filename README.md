# Tomonari(共鳴り).spoon

Keyboard typing sound feedback for [Hammerspoon](https://www.hammerspoon.org/).  
Plays mechanical keyboard sounds on every keystroke, with a menu bar icon for easy control.

## Features

- **Menu bar icon** `⌨` — toggle on/off, switch sound packs, and adjust volume without any hotkeys
- **Multiple sound packs** — 18 built-in packs from [Mechvibes](https://github.com/hainguyents13/mechvibes)
- **Volume control** — adjust in 10% steps via menu or hotkeys, persisted across restarts
- **Key-repeat prevention** — long-press plays the sound only once

## Sound Packs

| Pack | Description |
|---|---|
| cherrymx-black-abs | Cherry MX Black + ABS keycaps — heavy linear |
| cherrymx-black-pbt | Cherry MX Black + PBT keycaps — heavy linear |
| cherrymx-blue-abs | Cherry MX Blue + ABS keycaps — clicky |
| cherrymx-blue-pbt | Cherry MX Blue + PBT keycaps — clicky |
| cherrymx-brown-abs | Cherry MX Brown + ABS keycaps — tactile bump |
| cherrymx-brown-pbt | Cherry MX Brown + PBT keycaps — tactile bump |
| cherrymx-red-abs | Cherry MX Red + ABS keycaps — light linear |
| cherrymx-red-pbt | Cherry MX Red + PBT keycaps — light linear |
| cream-travel | Cream linear — smooth and deep |
| eg-crystal-purple | EG Crystal Purple — smooth linear |
| eg-oreo | EG Oreo — tactile |
| holy-pandas | Holy Pandas — tactile thocky sound |
| mxblack-travel | Cherry MX Black — heavy linear |
| mxblue-travel | Cherry MX Blue — clicky |
| mxbrown-travel | Cherry MX Brown — tactile bump |
| nk-cream | NK Cream — smooth buttery linear |
| topre-purple-hybrid-pbt | Topre Purple Hybrid PBT — electrocapacitive thock |
| turquoise | Turquoise — crisp typing sound |

## Installation

Install [Hammerspoon](https://www.hammerspoon.org/) first if you haven't:

```bash
brew install --cask hammerspoon
```

Download [Tomonari.spoon.zip](https://github.com/masaki39/tomonari/raw/main/Spoons/Tomonari.spoon.zip), open it to install, and add to `~/.hammerspoon/init.lua`:

```lua
hs.loadSpoon("Tomonari")
spoon.Tomonari:start()
```

<details>
<summary>With hotkeys (optional)</summary>

```lua
hs.loadSpoon("Tomonari")
spoon.Tomonari:start()
spoon.Tomonari:bindHotkeys({
    toggle     = { { "ctrl", "alt", "cmd", "shift" }, "k" },
    selectPack = { { "ctrl", "alt", "cmd", "shift" }, "p" },
    volumeUp   = { { "ctrl", "alt", "cmd", "shift" }, "=" },
    volumeDown = { { "ctrl", "alt", "cmd", "shift" }, "-" },
})
```

</details>

<details>
<summary>Via SpoonInstall</summary>

Download [SpoonInstall.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/main/Spoons/SpoonInstall.spoon.zip) and open it to install if you haven't.

Add to `~/.hammerspoon/init.lua`:

```lua
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.repos.tomonari = {
    url = "https://github.com/masaki39/tomonari",
    desc = "Tomonari Spoon repository",
    branch = "main",
}
spoon.SpoonInstall:andUse("Tomonari", {
    repo = "tomonari",
    start = true,
})
```

</details>

## Credits

Sound packs: [Mechvibes](https://github.com/hainguyents13/mechvibes) (MIT License)

## Version Management

```bash
chmod +x version.sh   # first time only
./version.sh patch    # patch bump (default)
./version.sh minor
./version.sh major
```

Then push:

```bash
git push && git push --tags
```
