local obj = ...

function obj:_buildMenu()
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
		{ title = "Enabled", fn = function()
			if self._soundEnabled then self:stop() else self:start() end
		end, checked = self._soundEnabled },
		{ title = "-" },
		{ title = "Sound Pack", menu = packItems },
		{ title = "-" },
		{ title = string.format("Volume: %d%%", math.floor(self._volume * 100 + 0.5)), disabled = true },
		{ title = "Volume +10%", fn = function() self:setVolume(self._volume + 0.1) end },
		{ title = "Volume -10%", fn = function() self:setVolume(self._volume - 0.1) end },
		{ title = "-" },
		{ title = "Count Keystrokes", fn = function() self:_toggleStats() end, checked = self._statsEnabled },
		table.unpack(self._statsEnabled and {
			{ title = string.format("Today: %s keys",        self:_formatCount(self._stats[os.date("%Y-%m-%d")] or 0)), disabled = true },
			{ title = string.format("30-day total: %s keys", self:_formatCount(self:_totalStats())),                    disabled = true },
		} or {}),
		{ title = "-" },
		{ title = "Hide Menubar Icon", fn = function() self:_toggleMenubarVisibility() end },
	}
end

function obj:_toggleMenubarVisibility()
	self.menubarHidden = not self.menubarHidden
	hs.settings.set("Tomonari.menubarHidden", self.menubarHidden)
	if self.menubarHidden then
		if self._menubar then self._menubar:delete(); self._menubar = nil end
	else
		if not self._menubar then
			self._menubar = hs.menubar.new()
			self._menubar:setTitle(self.menubarIcon)
			self._menubar:setMenu(function() return self:_buildMenu() end)
		end
	end
end
