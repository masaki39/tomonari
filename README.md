# Tomonari.spoon

Keyboard typing sound feedback for [Hammerspoon](https://www.hammerspoon.org/).
Plays mechanical keyboard sounds (Holy Pandas) on every keystroke.

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
<summary>Toggle hotkey (optional)</summary>

```lua
hs.loadSpoon("Tomonari")
spoon.Tomonari:start()
spoon.Tomonari:bindHotkeys({
    toggle = { { "ctrl", "alt", "cmd", "shift" }, "k" },
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

Sound pack: [Mechvibes](https://github.com/hainguyents13/mechvibes) (MIT License)

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
