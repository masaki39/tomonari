# Tomonari.spoon

Keyboard typing sound feedback for [Hammerspoon](https://www.hammerspoon.org/).  
Plays mechanical keyboard sounds on every keystroke, with a menu bar icon for easy control.

## Features

- **Menu bar icon** `⌨` — toggle on/off, switch sound packs, and adjust volume without any hotkeys
- **Multiple sound packs** — 5 built-in packs from [Mechvibes](https://github.com/hainguyents13/mechvibes)
- **Volume control** — adjust in 10% steps via menu or hotkeys, persisted across restarts
- **Key-repeat prevention** — long-press plays the sound only once

## Sound Packs

| Pack | Description |
|---|---|
| holy-pandas | Holy Pandas — tactile thocky sound |
| cream-travel | Cream linear — smooth and deep |
| mxblack-travel | Cherry MX Black — heavy linear |
| mxbrown-travel | Cherry MX Brown — tactile bump |
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
