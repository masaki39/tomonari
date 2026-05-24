local _spoonDir = (function()
	local info = debug.getinfo(1, "S")
	local src = info.source:match("^@(.+)$") or info.source
	return src:match("^(.+)/[^/]+$") or "."
end)()

local obj = {}
obj.__index = obj

obj.name    = "Tomonari"
obj.version = "0.0.7"
obj.author  = "masaki39"
obj.license = "MIT"

obj._tap             = nil
obj._menubar         = nil
obj._packs           = {}
obj._currentPackName = nil
obj._currentSounds   = nil
obj._volume          = 1.0
obj._pressedKeys     = {}
obj._hotkeys         = {}
obj._statsEnabled    = false
obj._stats           = {}
obj._statsDirty      = 0

local SPECIAL_KEYCODES = { [49] = "SPACE", [36] = "ENTER", [51] = "BACKSPACE" }
local STATS_FLUSH = 50
local STATS_DAYS  = 30

function obj:_pruneStats()
	local cutoff = os.date("%Y-%m-%d", os.time() - STATS_DAYS * 86400)
	for date in pairs(self._stats) do
		if date < cutoff then self._stats[date] = nil end
	end
end

function obj:_loadStats()
	local data = hs.settings.get("Tomonari.stats")
	if type(data) == "table" then self._stats = data end
	self:_pruneStats()
end

function obj:_saveStats()
	self:_pruneStats()
	hs.settings.set("Tomonari.stats", self._stats)
	self._statsDirty = 0
end

function obj:_formatCount(n)
	return tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

function obj:_totalStats()
	local t = 0
	for _, v in pairs(self._stats) do t = t + v end
	return t
end

function obj:_discoverPacks()
	self._packs = {}
	local soundsDir = _spoonDir .. "/sounds/"
	pcall(function()
		for name in hs.fs.dir(soundsDir) do
			if name ~= "." and name ~= ".." then
				local attrs = hs.fs.attributes(soundsDir .. name)
				if attrs and attrs.mode == "directory" then
					self._packs[name] = soundsDir .. name
				end
			end
		end
	end)
end

function obj:_loadPackSounds(packDir)
	local sounds = { generics = {}, special = {} }
	for i = 0, 9 do
		local s = hs.sound.getByFile(packDir .. "/GENERIC_R" .. i .. ".mp3")
		if s then table.insert(sounds.generics, s) end
	end
	for kc, name in pairs(SPECIAL_KEYCODES) do
		local s = hs.sound.getByFile(packDir .. "/" .. name .. ".mp3")
		if s then sounds.special[kc] = s end
	end
	return sounds
end

function obj:_applyVolume()
	if not self._currentSounds then return end
	for _, s in ipairs(self._currentSounds.generics) do s:volume(self._volume) end
	for _, s in pairs(self._currentSounds.special)  do s:volume(self._volume) end
end

function obj:_activatePack(packName)
	local packDir = self._packs[packName]
	if not packDir then return end
	self._currentPackName = packName
	self._currentSounds   = self:_loadPackSounds(packDir)
	self:_applyVolume()
	hs.settings.set("Tomonari.pack", packName)
	hs.alert("Tomonari: " .. packName)
end

function obj:_play(sound)
	if sound then sound:stop():play() end
end

function obj:setVolume(vol)
	self._volume = math.max(0.0, math.min(1.0, vol))
	hs.settings.set("Tomonari.volume", self._volume)
	self:_applyVolume()
	hs.alert(string.format("Tomonari: Volume %d%%", math.floor(self._volume * 100 + 0.5)))
end

function obj:_buildMenu()
	local enabled = self._tap and self._tap:isEnabled()

	local packItems = {}
	local names = {}
	for name in pairs(self._packs) do table.insert(names, name) end
	table.sort(names)
	for _, name in ipairs(names) do
		local n = name
		table.insert(packItems, {
			title   = n,
			fn      = function() self:_activatePack(n) end,
			checked = n == self._currentPackName,
		})
	end

	return {
		{
			title   = "Enabled",
			fn      = function()
				if self._tap and self._tap:isEnabled() then
					self:stop()
				else
					self:start()
				end
			end,
			checked = enabled,
		},
		{ title = "-" },
		{ title = "Sound Pack", menu = packItems },
		{ title = "-" },
		{
			title    = string.format("Volume: %d%%", math.floor(self._volume * 100 + 0.5)),
			disabled = true,
		},
		{
			title = "Volume +10%",
			fn    = function() self:setVolume(self._volume + 0.1) end,
		},
		{
			title = "Volume -10%",
			fn    = function() self:setVolume(self._volume - 0.1) end,
		},
		{ title = "-" },
		{
			title   = "Count Keystrokes",
			fn      = function()
				self._statsEnabled = not self._statsEnabled
				hs.settings.set("Tomonari.statsEnabled", self._statsEnabled)
				if self._statsEnabled then
					self:_loadStats()
				elseif self._statsDirty > 0 then
					self:_saveStats()
				end
			end,
			checked = self._statsEnabled,
		},
		table.unpack(self._statsEnabled and {
			{
				title    = string.format("Today: %s keys", self:_formatCount(self._stats[os.date("%Y-%m-%d")] or 0)),
				disabled = true,
			},
			{
				title    = string.format("30-day total: %s keys", self:_formatCount(self:_totalStats())),
				disabled = true,
			},
		} or {}),
	}
end

function obj:selectPack()
	local choices = {}
	for name in pairs(self._packs) do
		local mark = name == self._currentPackName and " [current]" or ""
		table.insert(choices, { text = name .. mark, subText = self._packs[name], packName = name })
	end
	table.sort(choices, function(a, b) return a.text < b.text end)
	local chooser
	chooser = hs.chooser.new(function(choice)
		chooser:delete()
		chooser = nil
		if choice then self:_activatePack(choice.packName) end
	end)
	chooser:choices(choices)
	chooser:show()
end

function obj:init()
	self:_discoverPacks()
	self._volume       = hs.settings.get("Tomonari.volume") or 1.0
	self._statsEnabled = hs.settings.get("Tomonari.statsEnabled") or false
	local saved = hs.settings.get("Tomonari.pack")
	local pack  = (saved and self._packs[saved]) and saved or next(self._packs)
	if pack then self:_activatePack(pack) end
	if self._statsEnabled then self:_loadStats() end
end

function obj:start()
	if not self._menubar then
		self._menubar = hs.menubar.new()
		self._menubar:setTitle("⌨")
		self._menubar:setMenu(function() return self:_buildMenu() end)
	end

	self._pressedKeys = {}
	self._tap = hs.eventtap.new({
		hs.eventtap.event.types.keyDown,
		hs.eventtap.event.types.keyUp,
	}, function(event)
		local kc = event:getKeyCode()
		if event:getType() == hs.eventtap.event.types.keyUp then
			self._pressedKeys[kc] = nil
			return false
		end
		if self._pressedKeys[kc] then return false end
		self._pressedKeys[kc] = true
		if not self._currentSounds then return false end
		local sound = self._currentSounds.special[kc]
		              or self._currentSounds.generics[math.random(#self._currentSounds.generics)]
		self:_play(sound)
		if self._statsEnabled then
			local today = os.date("%Y-%m-%d")
			self._stats[today] = (self._stats[today] or 0) + 1
			self._statsDirty = self._statsDirty + 1
			if self._statsDirty >= STATS_FLUSH then self:_saveStats() end
		end
		return false
	end)
	self._tap:start()
	return self
end

function obj:stop()
	if self._statsEnabled and self._statsDirty > 0 then self:_saveStats() end
	if self._tap then
		self._tap:stop()
		self._tap = nil
	end
	self._pressedKeys = {}
	for _, hk in ipairs(self._hotkeys) do hk:delete() end
	self._hotkeys = {}
	if self._menubar then
		self._menubar:delete()
		self._menubar = nil
	end
	return self
end

-- map: { toggle, selectPack, volumeUp, volumeDown } = { mods, key }
function obj:bindHotkeys(map)
	for _, hk in ipairs(self._hotkeys) do hk:delete() end
	self._hotkeys = {}
	if map.toggle then
		local mods, key = map.toggle[1], map.toggle[2]
		table.insert(self._hotkeys, hs.hotkey.bind(mods, key, function()
			if self._tap and self._tap:isEnabled() then
				self:stop()
				hs.alert("Tomonari: OFF")
			else
				self:start()
				hs.alert("Tomonari: ON")
			end
		end))
	end
	if map.selectPack then
		local mods, key = map.selectPack[1], map.selectPack[2]
		table.insert(self._hotkeys, hs.hotkey.bind(mods, key, function() self:selectPack() end))
	end
	if map.volumeUp then
		local mods, key = map.volumeUp[1], map.volumeUp[2]
		table.insert(self._hotkeys, hs.hotkey.bind(mods, key, function() self:setVolume(self._volume + 0.1) end))
	end
	if map.volumeDown then
		local mods, key = map.volumeDown[1], map.volumeDown[2]
		table.insert(self._hotkeys, hs.hotkey.bind(mods, key, function() self:setVolume(self._volume - 0.1) end))
	end
	return self
end

return obj
