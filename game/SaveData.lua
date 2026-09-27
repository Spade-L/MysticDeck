-- [ts]: SaveData.ts
local ____lualib = require("lualib_bundle") -- 1
local __TS__Class = ____lualib.__TS__Class -- 1
local __TS__StringSplit = ____lualib.__TS__StringSplit -- 1
local __TS__StringSubstring = ____lualib.__TS__StringSubstring -- 1
local __TS__Number = ____lualib.__TS__Number -- 1
local ____exports = {} -- 1
local ____Dora = require("Dora") -- 2
local Content = ____Dora.Content -- 2
local Path = ____Dora.Path -- 2
____exports.SaveFile = __TS__Class() -- 4
local SaveFile = ____exports.SaveFile -- 4
SaveFile.name = "SaveFile" -- 4
function SaveFile.prototype.____constructor(self) -- 11
	self.highestLevel = 1 -- 5
	self.bgmVolume = 0.5 -- 6
	self.sfxVolume = 0.8 -- 7
	self.path = Path(Content.writablePath, "lingshu_save.txt") -- 12
	self:load() -- 13
end -- 11
function SaveFile.prototype.load(self) -- 16
	local text = Content:load(self.path) -- 17
	if text == nil or text == "" then -- 17
		return -- 18
	end -- 18
	local lines = __TS__StringSplit(text, "\n") -- 19
	do -- 19
		local i = 0 -- 20
		while i < #lines do -- 20
			do -- 20
				local line = lines[i + 1] -- 21
				local eq = (string.find(line, "=", nil, true) or 0) - 1 -- 22
				if eq <= 0 then -- 22
					goto __continue6 -- 23
				end -- 23
				local key = __TS__StringSubstring(line, 0, eq) -- 24
				local num = __TS__Number(__TS__StringSubstring(line, eq + 1)) -- 25
				if key == "highestLevel" then -- 25
					self.highestLevel = math.floor(num) -- 26
				elseif key == "bgmVolume" then -- 26
					self.bgmVolume = num -- 27
				elseif key == "sfxVolume" then -- 27
					self.sfxVolume = num -- 28
				end -- 28
			end -- 28
			::__continue6:: -- 28
			i = i + 1 -- 20
		end -- 20
	end -- 20
end -- 16
function SaveFile.prototype.save(self) -- 32
	local text = ((((((("highestLevel=" .. tostring(self.highestLevel)) .. "\n") .. "bgmVolume=") .. tostring(self.bgmVolume)) .. "\n") .. "sfxVolume=") .. tostring(self.sfxVolume)) .. "\n" -- 33
	Content:save(self.path, text) -- 36
end -- 32
return ____exports -- 32