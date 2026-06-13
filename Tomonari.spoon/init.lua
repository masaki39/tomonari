local _spoonDir = (function()
	local info = debug.getinfo(1, "S")
	local src = info.source:match("^@(.+)$") or info.source
	return src:match("^(.+)/[^/]+$") or "."
end)()

local obj = {}
obj.__index = obj

obj.name    = "Tomonari"
obj.version = "0.0.10"
obj.author  = "masaki39"
obj.license = "MIT"

-- Public config
obj.menubarIcon   = "🎹"
obj.menubarHidden = false

-- Private state
obj._tap             = nil
obj._menubar         = nil
obj._packs           = {}
obj._currentPackName = nil
obj._currentSounds   = nil
obj._volume          = 1.0
obj._pressedKeys     = {}
obj._hotkeys         = {}
obj._soundEnabled    = false
obj._statsEnabled    = false
obj._stats           = {}
obj._statsDirty      = 0

local function loadModule(name)
	local chunk, err = loadfile(_spoonDir .. "/" .. name .. ".lua")
	if not chunk then error("Tomonari: " .. tostring(err)) end
	chunk(obj, _spoonDir)
end

loadModule("sound")
loadModule("stats")
loadModule("tap")
loadModule("menubar")
loadModule("chooser")
loadModule("hotkeys")

-- ── Lifecycle ────────────────────────────────────────────────────────────────

local function readSetting(key, default)
	local v = hs.settings.get(key)
	return v ~= nil and v or default
end

function obj:init()
	self:_discoverPacks()
	self._volume       = readSetting("Tomonari.volume",       self._volume)
	self._statsEnabled = readSetting("Tomonari.statsEnabled", self._statsEnabled)
	self.menubarHidden = readSetting("Tomonari.menubarHidden", self.menubarHidden)
	local saved = hs.settings.get("Tomonari.pack")
	local pack  = (saved and self._packs[saved]) and saved or next(self._packs)
	if pack then self:_activatePack(pack) end
	if self._statsEnabled then self:_loadStats(); self:_ensureTap() end
end

function obj:start()
	if not self.menubarHidden and not self._menubar then
		self._menubar = hs.menubar.new()
		self._menubar:setTitle(self.menubarIcon)
		self._menubar:setMenu(function() return self:_buildMenu() end)
	end
	self._soundEnabled = true
	self:_ensureTap()
	return self
end

function obj:stop()
	if self._statsEnabled and self._statsDirty > 0 then self:_saveStats() end
	self._soundEnabled = false
	self:_maybeStopTap()
	self:_clearHotkeys()
	return self
end

return obj
