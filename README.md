# Tomonari(共鳴り).spoon

[![Latest Release](https://img.shields.io/github/v/release/masaki39/tomonari)](https://github.com/masaki39/tomonari/releases/latest)

Keyboard typing sound feedback for [Hammerspoon](https://www.hammerspoon.org/).  
Plays mechanical keyboard sounds on every keystroke, with a menu bar icon for easy control.

## Features

- **Menu bar icon** — toggle on/off, switch sound packs, and adjust volume without any hotkeys; icon is configurable
- **Multiple sound packs** — 18 built-in packs from [Mechvibes](https://github.com/hainguyents13/mechvibes)
- **Volume control** — adjust in 10% steps via menu or hotkeys, persisted across restarts
- **Key-repeat prevention** — long-press plays the sound only once
- **Keystroke counter** — runs independently of sound; tracks daily key counts for 30 days
- **Hotkey menu** — full-featured chooser menu accessible via hotkey, even without the menu bar icon

## Customization

Change the menu bar icon before calling `start()`:

```lua
spoon.Tomonari.menubarIcon = "⌨️"
spoon.Tomonari:start()
```

Hide the menu bar icon entirely and use a hotkey instead:

```lua
spoon.Tomonari.menubarHidden = true
spoon.Tomonari:start()
spoon.Tomonari:bindHotkeys({
    showMenu = { { "ctrl", "option" }, "t" },
})
```

The `menubarHidden` setting is persisted — once toggled via the chooser menu, the state survives restarts.

## Keystroke Counter

Enable via the menu bar → **Count Keystrokes**. Works even when sound is disabled.

When enabled, the menu shows:

- **Today: N keys** — keystrokes typed today
- **30-day total: N keys** — cumulative count over the last 30 days

Data is stored in Hammerspoon's preferences (`~/Library/Preferences/org.hammerspoon.Hammerspoon.plist`) and automatically pruned to the last 30 days.

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

Download [Tomonari.spoon.zip](https://github.com/masaki39/tomonari/releases/latest/download/Tomonari.spoon.zip), open it to install, and add to `~/.hammerspoon/init.lua`:

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
    showMenu   = { { "ctrl", "option" }, "t" },
})
```

| Key | Action |
|---|---|
| `toggle` | Enable / disable sound |
| `selectPack` | Open pack chooser |
| `volumeUp` | Volume +10% |
| `volumeDown` | Volume -10% |
| `showMenu` | Open full chooser menu |

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
    config = {
        menubarIcon   = "⌨️",
        menubarHidden = true,   -- hide menu bar icon, use hotkey instead
    },
    hotkeys = {
        showMenu = { { "ctrl", "option" }, "t" },
    },
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
