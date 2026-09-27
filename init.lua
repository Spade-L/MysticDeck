-- [ts]: init.ts
local ____lualib = require("lualib_bundle") -- 1
local __TS__New = ____lualib.__TS__New -- 1
local ____exports = {} -- 1
local ____Dora = require("Dora") -- 3
local Audio = ____Dora.Audio -- 3
local ____GameDataManager = require("game.GameDataManager") -- 4
local GameDataManager = ____GameDataManager.GameDataManager -- 4
local ____GameUI = require("game.GameUI") -- 5
local GameUI = ____GameUI.GameUI -- 5
local mgr = __TS__New(GameDataManager) -- 7
local ui = __TS__New(GameUI, mgr) -- 8
ui:refresh() -- 9
Audio:playStream("Audio/bgm.ogg", true) -- 12
return ____exports -- 12