local obj = ...

function obj:_clearHotkeys()
	for _, hk in ipairs(self._hotkeys) do hk:delete() end
	self._hotkeys = {}
end

-- map: { toggle, selectPack, volumeUp, volumeDown, showMenu } = { mods, key }
function obj:bindHotkeys(map)
	self:_clearHotkeys()
	local function bind(mods, key, fn)
		local hk = hs.hotkey.bind(mods, key, fn)
		if hk then table.insert(self._hotkeys, hk)
		else        hs.alert("Tomonari: failed to bind key " .. tostring(key)) end
	end
	local actions = {
		toggle     = function() if self._soundEnabled then self:stop(); hs.alert("Tomonari: OFF") else self:start(); hs.alert("Tomonari: ON") end end,
		selectPack = function() self:selectPack() end,
		volumeUp   = function() self:setVolume(self._volume + 0.1) end,
		volumeDown = function() self:setVolume(self._volume - 0.1) end,
		showMenu   = function() self:showMenu() end,
	}
	for key, fn in pairs(actions) do
		if map[key] then bind(map[key][1], map[key][2], fn) end
	end
	return self
end
