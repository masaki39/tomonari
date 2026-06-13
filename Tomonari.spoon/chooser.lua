local obj = ...

local function makeChooser(callback)
	local tap
	local chooser
	chooser = hs.chooser.new(function(choice)
		if tap then
			tap:stop()
			tap = nil
		end
		if chooser then
			chooser:delete()
			chooser = nil
		end
		callback(choice)
	end)
	tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
		if not event:getFlags().ctrl then
			return false
		end
		local kc = event:getKeyCode()
		if kc == 38 then
			chooser:selectedRow(chooser:selectedRow() + 1)
			return true
		end
		if kc == 40 then
			chooser:selectedRow(chooser:selectedRow() - 1)
			return true
		end
		return false
	end)
	tap:start()
	return chooser
end

function obj:showMenu()
	local items = {}
	local actions = {}

	local function addItem(text, subText, action)
		local idx = #actions + 1
		actions[idx] = action
		table.insert(items, { text = text, subText = subText or "", _idx = idx })
	end

	local vol = math.floor(self._volume * 100 + 0.5)
	addItem(self._soundEnabled and "Disable Sound" or "Enable Sound", nil, function()
		if self._soundEnabled then
			self:stop()
			hs.alert("Tomonari: OFF")
		else
			self:start()
			hs.alert("Tomonari: ON")
		end
	end)
	addItem("Change Sound", self._currentPackName or "", function()
		self:selectPack()
	end)
	addItem(string.format("Volume Up  (%d%% → %d%%)", vol, math.min(100, vol + 10)), nil, function()
		self:setVolume(self._volume + 0.1)
	end)
	addItem(string.format("Volume Down  (%d%% → %d%%)", vol, math.max(0, vol - 10)), nil, function()
		self:setVolume(self._volume - 0.1)
	end)

	local statsSub = self._statsEnabled
			and string.format(
				"Today: %s  /  30d: %s",
				self:_formatCount(self._stats[os.date("%Y-%m-%d")] or 0),
				self:_formatCount(self:_totalStats())
			)
		or ""
	addItem(self._statsEnabled and "Keystroke Count: On" or "Keystroke Count: Off", statsSub, function()
		self:_toggleStats()
	end)
	addItem(self.menubarHidden and "Menubar: Hidden" or "Menubar: Visible", nil, function()
		self:_toggleMenubarVisibility()
	end)

	local chooser = makeChooser(function(choice)
		if choice and choice._idx and actions[choice._idx] then
			actions[choice._idx]()
		end
	end)
	chooser:rows(4)
	chooser:width(25)
	chooser:placeholderText("Tomonari")
	chooser:choices(items)
	chooser:show()
end

function obj:selectPack()
	local choices = {}
	for name in pairs(self._packs) do
		local mark = name == self._currentPackName and " [current]" or ""
		table.insert(choices, { text = name .. mark, subText = self._packs[name], packName = name })
	end
	table.sort(choices, function(a, b)
		return a.text < b.text
	end)
	local chooser = makeChooser(function(choice)
		if choice then
			self:_activatePack(choice.packName)
		end
	end)
	chooser:width(25)
	chooser:placeholderText("Sound Pack")
	chooser:choices(choices)
	chooser:show()
end
