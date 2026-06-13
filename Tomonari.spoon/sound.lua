local obj, _spoonDir = ...
local SPECIAL_KEYCODES = { [49] = "SPACE", [36] = "ENTER", [51] = "BACKSPACE" }

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
