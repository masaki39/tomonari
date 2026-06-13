local obj = ...

function obj:_ensureTap()
	if self._tap then return end
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
		if self._soundEnabled and self._currentSounds then
			local sound = self._currentSounds.special[kc]
				or self._currentSounds.generics[math.random(#self._currentSounds.generics)]
			self:_play(sound)
		end
		if self._statsEnabled then
			local today = os.date("%Y-%m-%d")
			self._stats[today] = (self._stats[today] or 0) + 1
			self:_markDirty()
		end
		return false
	end)
	self._tap:start()
end

function obj:_maybeStopTap()
	if not self._soundEnabled and not self._statsEnabled then
		if self._tap then self._tap:stop(); self._tap = nil end
		self._pressedKeys = {}
	end
end
