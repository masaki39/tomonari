local _spoonDir = (function()
	local info = debug.getinfo(1, "S")
	local src = info.source:match("^@(.+)$") or info.source
	return src:match("^(.+)/[^/]+$") or "."
end)()

local obj = {}
obj.__index = obj

obj.name    = "Tomonari"
obj.version = "0.0.1"
obj.author  = "masaki39"
obj.license = "MIT"

obj._tap = nil

function obj:start()
	local soundDir = _spoonDir .. "/sounds/holy-pandas/"

	local generics = {}
	for i = 0, 4 do
		generics[i + 1] = hs.sound.getByFile(soundDir .. "GENERIC_R" .. i .. ".mp3")
	end
	local specialSounds = {
		[49] = hs.sound.getByFile(soundDir .. "SPACE.mp3"),
		[36] = hs.sound.getByFile(soundDir .. "ENTER.mp3"),
		[51] = hs.sound.getByFile(soundDir .. "BACKSPACE.mp3"),
	}

	self._tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
		local sound = specialSounds[event:getKeyCode()] or generics[math.random(#generics)]
		if sound then sound:stop():play() end
		return false
	end)
	self._tap:start()

	return self
end

function obj:stop()
	if self._tap then
		self._tap:stop()
		self._tap = nil
	end
	return self
end

-- map: { toggle = { mods, key } }
function obj:bindHotkeys(map)
	if map.toggle then
		local mods, key = map.toggle[1], map.toggle[2]
		hs.hotkey.bind(mods, key, function()
			if self._tap and self._tap:isEnabled() then
				self:stop()
				hs.alert("Tomonari: OFF")
			else
				self:start()
				hs.alert("Tomonari: ON")
			end
		end)
	end
	return self
end

return obj
