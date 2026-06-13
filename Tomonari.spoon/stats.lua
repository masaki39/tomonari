local obj = ...
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

function obj:_markDirty()
	self._statsDirty = self._statsDirty + 1
	if self._statsDirty >= STATS_FLUSH then self:_saveStats() end
end

function obj:_formatCount(n)
	return tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

function obj:_totalStats()
	local t = 0
	for _, v in pairs(self._stats) do t = t + v end
	return t
end

function obj:_toggleStats()
	self._statsEnabled = not self._statsEnabled
	hs.settings.set("Tomonari.statsEnabled", self._statsEnabled)
	if self._statsEnabled then
		self:_loadStats()
		self:_ensureTap()
	else
		if self._statsDirty > 0 then self:_saveStats() end
		self:_maybeStopTap()
	end
end
