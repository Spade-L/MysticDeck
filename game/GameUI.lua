-- [ts]: GameUI.ts
local ____lualib = require("lualib_bundle") -- 1
local __TS__Class = ____lualib.__TS__Class -- 1
local __TS__New = ____lualib.__TS__New -- 1
local ____exports = {} -- 1
local ____Dora = require("Dora") -- 2
local App = ____Dora.App -- 2
local AudioSource = ____Dora.AudioSource -- 2
local Color = ____Dora.Color -- 2
local Director = ____Dora.Director -- 2
local DrawNode = ____Dora.DrawNode -- 2
local Label = ____Dora.Label -- 2
local Mouse = ____Dora.Mouse -- 2
local Node = ____Dora.Node -- 2
local Size = ____Dora.Size -- 2
local Vec2 = ____Dora.Vec2 -- 2
local View = ____Dora.View -- 2
local tolua = ____Dora.tolua -- 2
local ____types = require("game.types") -- 3
local CoinType = ____types.CoinType -- 3
local COIN_TYPE_ORDER = ____types.COIN_TYPE_ORDER -- 3
local coinTypeName = ____types.coinTypeName -- 3
local ____GameDataManager = require("game.GameDataManager") -- 4
local GameDataManager = ____GameDataManager.GameDataManager -- 4
local ____SaveData = require("game.SaveData") -- 5
local SaveFile = ____SaveData.SaveFile -- 5
____exports.DESIGN_W = 720 -- 8
____exports.DESIGN_H = 1280 -- 9
local CARD_COLS = 3 -- 12
local CARD_ROWS = 1 -- 13
local CARD_W = 200 -- 14
local CARD_H = 300 -- 15
local CARD_GAP_X = 14 -- 16
local CARD_GAP_Y = 14 -- 17
local C_BG = Color(14, 11, 20, 255) -- 20
local C_PANEL = Color(32, 24, 44, 255) -- 21
local C_PANEL_BORDER = Color(96, 76, 130, 255) -- 22
local C_CARD = Color(32, 24, 44, 255) -- 23
local C_CARD_BORDER = Color(152, 128, 192, 255) -- 24
local C_GROUP = Color(36, 27, 50, 255) -- 25
local C_TEXT = Color(228, 222, 244, 255) -- 26
local C_TEXT_DIM = Color(172, 158, 196, 255) -- 27
local C_TEXT_FAINT = Color(206, 190, 242, 255) -- 28
local C_DANGER = Color(198, 78, 112, 255) -- 29
local C_CONFIRM = Color(124, 98, 168, 255) -- 30
local C_CONFIRM_BORDER = Color(216, 200, 248, 255) -- 31
local C_ENDTURN = Color(88, 66, 120, 255) -- 32
local C_BADGE = Color(18, 14, 26, 255) -- 33
local C_GOLD = Color(160, 136, 200, 255) -- 34
local C_GOLD_BRIGHT = Color(226, 214, 252, 255) -- 35
local C_GOLD_DARK = Color(84, 66, 112, 255) -- 36
local C_GOLD_TEXT = Color(206, 190, 244, 255) -- 37
local function coinColor(____type) -- 40
	repeat -- 40
		local ____switch3 = ____type -- 40
		local ____cond3 = ____switch3 == CoinType.Normal -- 40
		if ____cond3 then -- 40
			return Color(170, 148, 214, 255) -- 42
		end -- 42
		____cond3 = ____cond3 or ____switch3 == CoinType.Multiply -- 42
		if ____cond3 then -- 42
			return Color(200, 126, 196, 255) -- 43
		end -- 43
		____cond3 = ____cond3 or ____switch3 == CoinType.Freeze -- 43
		if ____cond3 then -- 43
			return Color(126, 152, 216, 255) -- 44
		end -- 44
		____cond3 = ____cond3 or ____switch3 == CoinType.Discount -- 44
		if ____cond3 then -- 44
			return Color(146, 116, 190, 255) -- 45
		end -- 45
		____cond3 = ____cond3 or ____switch3 == CoinType.Copy -- 45
		if ____cond3 then -- 45
			return Color(202, 132, 176, 255) -- 46
		end -- 46
		____cond3 = ____cond3 or ____switch3 == CoinType.Wild -- 46
		if ____cond3 then -- 46
			return Color(222, 202, 250, 255) -- 47
		end -- 47
		____cond3 = ____cond3 or ____switch3 == CoinType.Growth -- 47
		if ____cond3 then -- 47
			return Color(118, 172, 196, 255) -- 48
		end -- 48
		____cond3 = ____cond3 or ____switch3 == CoinType.Heal -- 48
		if ____cond3 then -- 48
			return Color(148, 192, 182, 255) -- 49
		end -- 49
		____cond3 = ____cond3 or ____switch3 == CoinType.Disturb -- 49
		if ____cond3 then -- 49
			return Color(190, 98, 130, 255) -- 50
		end -- 50
		do -- 50
			return Color(160, 150, 190, 255) -- 51
		end -- 51
	until true -- 51
end -- 40
local function coinChipText(____type, value) -- 56
	repeat -- 56
		local ____switch5 = ____type -- 56
		local ____cond5 = ____switch5 == CoinType.Freeze -- 56
		if ____cond5 then -- 56
			return "冻" -- 58
		end -- 58
		____cond5 = ____cond5 or ____switch5 == CoinType.Discount -- 58
		if ____cond5 then -- 58
			return tostring(value) .. "%" -- 59
		end -- 59
		____cond5 = ____cond5 or ____switch5 == CoinType.Copy -- 59
		if ____cond5 then -- 59
			return "复" -- 60
		end -- 60
		____cond5 = ____cond5 or ____switch5 == CoinType.Wild -- 60
		if ____cond5 then -- 60
			return "万" -- 61
		end -- 61
		____cond5 = ____cond5 or ____switch5 == CoinType.Heal -- 61
		if ____cond5 then -- 61
			return (value >= 0 and "+" or "") .. tostring(value) -- 62
		end -- 62
		____cond5 = ____cond5 or ____switch5 == CoinType.Growth -- 62
		if ____cond5 then -- 62
			return "" .. tostring(value) -- 63
		end -- 63
		____cond5 = ____cond5 or (____switch5 == CoinType.Normal or ____switch5 == CoinType.Multiply or ____switch5 == CoinType.Disturb) -- 63
		do -- 63
			return "" .. tostring(value) -- 67
		end -- 67
	until true -- 67
end -- 56
local function rectVerts(cx, cy, w, h) -- 72
	return { -- 73
		Vec2(cx - w / 2, cy - h / 2), -- 74
		Vec2(cx + w / 2, cy - h / 2), -- 75
		Vec2(cx + w / 2, cy + h / 2), -- 76
		Vec2(cx - w / 2, cy + h / 2) -- 77
	} -- 77
end -- 72
local function lerpC(a, b, t) -- 82
	return Color( -- 83
		math.floor(a[1] + (b[1] - a[1]) * t + 0.5), -- 84
		math.floor(a[2] + (b[2] - a[2]) * t + 0.5), -- 85
		math.floor(a[3] + (b[3] - a[3]) * t + 0.5), -- 86
		math.floor(a[4] + (b[4] - a[4]) * t + 0.5) -- 87
	) -- 87
end -- 82
local function drawGrad(d, cx, cy, w, h, top, bottom) -- 92
	local steps = 14 -- 93
	local x0 = cx - w / 2 -- 94
	local x1 = cx + w / 2 -- 95
	do -- 95
		local i = 0 -- 96
		while i < steps do -- 96
			local yT = cy + h / 2 - h * (i / steps) -- 97
			local yB = cy + h / 2 - h * ((i + 1) / steps) -- 98
			d:drawPolygon( -- 99
				{ -- 99
					Vec2(x0, yT), -- 99
					Vec2(x1, yT), -- 99
					Vec2(x1, yB), -- 99
					Vec2(x0, yB) -- 99
				}, -- 99
				lerpC(top, bottom, (i + 0.5) / steps), -- 99
				0 -- 99
			) -- 99
			i = i + 1 -- 96
		end -- 96
	end -- 96
end -- 92
local function drawStud(d, x, y, r, color) -- 104
	d:drawPolygon( -- 105
		{ -- 105
			Vec2(x, y + r), -- 105
			Vec2(x + r, y), -- 105
			Vec2(x, y - r), -- 105
			Vec2(x - r, y) -- 105
		}, -- 105
		color, -- 105
		0 -- 105
	) -- 105
end -- 104
local function drawBand(d, cx, cy, w, h, band, color) -- 109
	d:drawPolygon( -- 110
		rectVerts(cx, cy + h / 2 - band / 2, w, band), -- 110
		color, -- 110
		0 -- 110
	) -- 110
	d:drawPolygon( -- 111
		rectVerts(cx, cy - h / 2 + band / 2, w, band), -- 111
		color, -- 111
		0 -- 111
	) -- 111
	d:drawPolygon( -- 112
		rectVerts(cx - w / 2 + band / 2, cy, band, h - 2 * band), -- 112
		color, -- 112
		0 -- 112
	) -- 112
	d:drawPolygon( -- 113
		rectVerts(cx + w / 2 - band / 2, cy, band, h - 2 * band), -- 113
		color, -- 113
		0 -- 113
	) -- 113
end -- 109
local function drawCorners(d, cx, cy, w, h, inset, r, color) -- 117
	local hx = w / 2 - inset -- 118
	local hy = h / 2 - inset -- 119
	drawStud( -- 120
		d, -- 120
		cx - hx, -- 120
		cy + hy, -- 120
		r, -- 120
		color -- 120
	) -- 120
	drawStud( -- 121
		d, -- 121
		cx + hx, -- 121
		cy + hy, -- 121
		r, -- 121
		color -- 121
	) -- 121
	drawStud( -- 122
		d, -- 122
		cx - hx, -- 122
		cy - hy, -- 122
		r, -- 122
		color -- 122
	) -- 122
	drawStud( -- 123
		d, -- 123
		cx + hx, -- 123
		cy - hy, -- 123
		r, -- 123
		color -- 123
	) -- 123
end -- 117
local function drawSheen(d, cx, cy, w, h, alpha) -- 127
	local inset = 8 -- 128
	local iw = w - inset * 2 -- 129
	d:drawPolygon( -- 130
		rectVerts(cx, cy + h / 2 - h * 0.2, iw, h * 0.16), -- 130
		Color(240, 234, 255, alpha), -- 130
		0 -- 130
	) -- 130
	d:drawPolygon( -- 131
		rectVerts(cx, cy + h / 2 - h * 0.34, iw * 0.72, h * 0.05), -- 131
		Color(246, 240, 255, alpha), -- 131
		0 -- 131
	) -- 131
end -- 127
local function makeLabel(parent, text, x, y, size, color, anchor) -- 135
	local l = Label("sarasa-mono-sc-regular", size) -- 144
	if not l then -- 144
		return nil -- 145
	end -- 145
	l.text = text -- 146
	l.position = Vec2(x, y) -- 147
	l.anchor = anchor and anchor or Vec2(0.5, 0.5) -- 148
	l.color = color -- 149
	l:addTo(parent) -- 150
	return l -- 151
end -- 135
____exports.GameUI = __TS__Class() -- 154
local GameUI = ____exports.GameUI -- 154
GameUI.name = "GameUI" -- 154
function GameUI.prototype.____constructor(self, mgr) -- 201
	self.confirmBtn = {x = 290, y = 568, w = 110, h = 44} -- 156
	self.endTurnBtn = {x = 0, y = -20, w = 170, h = 44} -- 157
	self.hintText = "" -- 172
	self.dragEndedEarly = false -- 176
	self.cardRects = {} -- 177
	self.rewardsApplied = false -- 178
	self.metaOpen = false -- 180
	self.metaMessage = "" -- 181
	self.viewZoom = 1 -- 182
	self.dbg = 0 -- 183
	self.lastMoveLog = 0 -- 184
	self.screen = "menu" -- 187
	self.settingsBack = "menu" -- 188
	self.bgmVolume = 0.5 -- 191
	self.sfxVolume = 0.8 -- 192
	self.mgr = mgr -- 202
	self.screenBgNode = Node() -- 205
	self.screenDraw = DrawNode() -- 206
	self.screenDraw:addTo(self.screenBgNode) -- 207
	self.screenBgNode:addTo(Director.entry) -- 208
	self.gameRoot = Node() -- 211
	self.gameRoot:addTo(Director.entry) -- 212
	self.bgLayer = Node() -- 214
	self.hudLayer = Node() -- 215
	self.cardLayer = Node() -- 216
	self.coinLayer = Node() -- 217
	self.actionLayer = Node() -- 218
	self.overlayLayer = Node() -- 219
	self.fxLayer = Node() -- 220
	self.bgLayer:addTo(self.gameRoot) -- 221
	self.hudLayer:addTo(self.gameRoot) -- 222
	self.cardLayer:addTo(self.gameRoot) -- 223
	self.coinLayer:addTo(self.gameRoot) -- 224
	self.actionLayer:addTo(self.gameRoot) -- 225
	self.overlayLayer:addTo(self.gameRoot) -- 226
	self.fxLayer:addTo(self.gameRoot) -- 227
	self.screenLayer = Node() -- 229
	self.screenLayer:addTo(self.gameRoot) -- 230
	self.updater = Node() -- 233
	self.updater:addTo(self.gameRoot) -- 234
	self.updater:schedule(function() -- 235
		self:tick() -- 236
		return false -- 237
	end) -- 235
	self:buildStatic() -- 240
	self:updateScale() -- 241
	self.save = __TS__New(SaveFile) -- 244
	self.bgmVolume = self.save.bgmVolume -- 245
	self.sfxVolume = self.save.sfxVolume -- 246
	self.mgr:unlockLevel(self.save.highestLevel) -- 247
	local bgm = AudioSource("Audio/bgm.ogg", false) -- 250
	if bgm then -- 250
		bgm.looping = true -- 252
		bgm.volume = self.bgmVolume -- 253
		bgm:addTo(self.gameRoot) -- 254
		bgm:play() -- 255
		self.bgmSource = bgm -- 256
	end -- 256
	Director.entry:onAppChange(function(name) -- 260
		if name == "Size" then -- 260
			self:updateScale() -- 261
		end -- 261
	end) -- 260
end -- 201
function GameUI.prototype.log(self, msg) -- 194
	if self.dbg < 120 then -- 194
		self.dbg = self.dbg + 1 -- 196
		print("[ui] " .. msg) -- 197
	end -- 197
end -- 194
function GameUI.prototype.updateScale(self) -- 267
	local w = View.size.width -- 268
	local h = View.size.height -- 269
	local zoom = math.min(w / ____exports.DESIGN_W, h / ____exports.DESIGN_H) -- 270
	self.viewZoom = zoom -- 271
	local camera = tolua.cast(Director.currentCamera, "Camera2D") -- 272
	if camera then -- 272
		camera.zoom = zoom -- 274
	end -- 274
	local vw = w / zoom -- 278
	local vh = h / zoom -- 279
	self.screenDraw:clear() -- 280
	self.screenDraw:drawPolygon( -- 281
		{ -- 282
			Vec2(-vw / 2, -vh / 2), -- 282
			Vec2(vw / 2, -vh / 2), -- 282
			Vec2(vw / 2, vh / 2), -- 282
			Vec2(-vw / 2, vh / 2) -- 282
		}, -- 282
		C_BG, -- 283
		0 -- 284
	) -- 284
end -- 267
function GameUI.prototype.buildStatic(self) -- 289
	local d = DrawNode() -- 290
	d:drawPolygon( -- 292
		rectVerts(0, 0, ____exports.DESIGN_W, ____exports.DESIGN_H), -- 292
		C_BG, -- 292
		0 -- 292
	) -- 292
	local pattern = Color(44, 34, 62, 255) -- 293
	do -- 293
		local i = -10 -- 294
		while i <= 26 do -- 294
			local x = i * 72 -- 295
			d:drawSegment( -- 296
				Vec2(x, -640), -- 296
				Vec2(x + 1280, 640), -- 296
				1, -- 296
				pattern -- 296
			) -- 296
			d:drawSegment( -- 297
				Vec2(x, 640), -- 297
				Vec2(x + 1280, -640), -- 297
				1, -- 297
				pattern -- 297
			) -- 297
			i = i + 1 -- 294
		end -- 294
	end -- 294
	drawGrad( -- 301
		d, -- 301
		0, -- 301
		250, -- 301
		664, -- 301
		380, -- 301
		{54, 41, 74, 255}, -- 301
		{24, 18, 34, 255} -- 301
	) -- 301
	drawBand( -- 302
		d, -- 302
		0, -- 302
		250, -- 302
		664, -- 302
		380, -- 302
		4, -- 302
		C_GOLD_DARK -- 302
	) -- 302
	drawBand( -- 303
		d, -- 303
		0, -- 303
		250, -- 303
		664, -- 303
		380, -- 303
		1, -- 303
		C_GOLD -- 303
	) -- 303
	drawBand( -- 304
		d, -- 304
		0, -- 304
		250, -- 304
		648, -- 304
		364, -- 304
		1, -- 304
		Color(84, 66, 112, 255) -- 304
	) -- 304
	drawCorners( -- 305
		d, -- 305
		0, -- 305
		250, -- 305
		664, -- 305
		380, -- 305
		12, -- 305
		8, -- 305
		C_GOLD_BRIGHT -- 305
	) -- 305
	drawCorners( -- 306
		d, -- 306
		0, -- 306
		250, -- 306
		664, -- 306
		380, -- 306
		26, -- 306
		5, -- 306
		C_GOLD -- 306
	) -- 306
	drawGrad( -- 309
		d, -- 309
		0, -- 309
		-412, -- 309
		664, -- 309
		432, -- 309
		{54, 41, 74, 255}, -- 309
		{24, 18, 34, 255} -- 309
	) -- 309
	drawBand( -- 310
		d, -- 310
		0, -- 310
		-412, -- 310
		664, -- 310
		432, -- 310
		4, -- 310
		C_GOLD_DARK -- 310
	) -- 310
	drawBand( -- 311
		d, -- 311
		0, -- 311
		-412, -- 311
		664, -- 311
		432, -- 311
		1, -- 311
		C_GOLD -- 311
	) -- 311
	drawBand( -- 312
		d, -- 312
		0, -- 312
		-412, -- 312
		648, -- 312
		416, -- 312
		1, -- 312
		Color(84, 66, 112, 255) -- 312
	) -- 312
	drawCorners( -- 313
		d, -- 313
		0, -- 313
		-412, -- 313
		664, -- 313
		432, -- 313
		12, -- 313
		8, -- 313
		C_GOLD_BRIGHT -- 313
	) -- 313
	drawCorners( -- 314
		d, -- 314
		0, -- 314
		-412, -- 314
		664, -- 314
		432, -- 314
		26, -- 314
		5, -- 314
		C_GOLD -- 314
	) -- 314
	d:drawSegment( -- 317
		Vec2(-332, 465), -- 317
		Vec2(332, 465), -- 317
		2, -- 317
		C_GOLD_DARK -- 317
	) -- 317
	d:drawSegment( -- 318
		Vec2(-300, 465), -- 318
		Vec2(300, 465), -- 318
		1, -- 318
		C_GOLD -- 318
	) -- 318
	drawStud( -- 319
		d, -- 319
		0, -- 319
		465, -- 319
		9, -- 319
		C_GOLD_BRIGHT -- 319
	) -- 319
	drawStud( -- 320
		d, -- 320
		-170, -- 320
		465, -- 320
		5, -- 320
		C_GOLD -- 320
	) -- 320
	drawStud( -- 321
		d, -- 321
		170, -- 321
		465, -- 321
		5, -- 321
		C_GOLD -- 321
	) -- 321
	d:drawSegment( -- 322
		Vec2(-190, 620), -- 322
		Vec2(190, 620), -- 322
		1, -- 322
		C_GOLD_DARK -- 322
	) -- 322
	drawStud( -- 323
		d, -- 323
		0, -- 323
		620, -- 323
		7, -- 323
		C_GOLD -- 323
	) -- 323
	drawStud( -- 324
		d, -- 324
		-190, -- 324
		620, -- 324
		5, -- 324
		C_GOLD -- 324
	) -- 324
	drawStud( -- 325
		d, -- 325
		190, -- 325
		620, -- 325
		5, -- 325
		C_GOLD -- 325
	) -- 325
	d:drawSegment( -- 328
		Vec2(-300, -20), -- 328
		Vec2(-120, -20), -- 328
		1, -- 328
		C_GOLD_DARK -- 328
	) -- 328
	d:drawSegment( -- 329
		Vec2(120, -20), -- 329
		Vec2(300, -20), -- 329
		1, -- 329
		C_GOLD_DARK -- 329
	) -- 329
	drawStud( -- 330
		d, -- 330
		-300, -- 330
		-20, -- 330
		6, -- 330
		C_GOLD -- 330
	) -- 330
	drawStud( -- 331
		d, -- 331
		-120, -- 331
		-20, -- 331
		4, -- 331
		C_GOLD -- 331
	) -- 331
	drawStud( -- 332
		d, -- 332
		120, -- 332
		-20, -- 332
		4, -- 332
		C_GOLD -- 332
	) -- 332
	drawStud( -- 333
		d, -- 333
		300, -- 333
		-20, -- 333
		6, -- 333
		C_GOLD -- 333
	) -- 333
	d:addTo(self.bgLayer) -- 335
end -- 289
function GameUI.prototype.refresh(self) -- 339
	if self.screen == "game" then -- 339
		if self.selectedCardId ~= nil then -- 339
			local c = self.mgr:findCard(self.selectedCardId) -- 342
			if not c or c.eliminated then -- 342
				self.selectedCardId = nil -- 343
			end -- 343
		end -- 343
		self.screenLayer:removeAllChildren() -- 345
		self:updateOverlay() -- 346
		self:renderHud() -- 347
		self:renderCards() -- 348
		self:renderCoins() -- 349
		self:renderActionButtons() -- 350
		return -- 351
	end -- 351
	self.hudLayer:removeAllChildren() -- 354
	self.cardLayer:removeAllChildren() -- 355
	self.coinLayer:removeAllChildren() -- 356
	self.overlayLayer:removeAllChildren() -- 357
	self.actionLayer:removeAllChildren() -- 358
	self:renderScreen() -- 359
end -- 339
function GameUI.prototype.renderActionButtons(self) -- 363
	self.actionLayer:removeAllChildren() -- 364
	self:makeButton( -- 365
		self.confirmBtn, -- 365
		"确定", -- 365
		{188, 160, 234, 255}, -- 365
		{116, 90, 156, 255}, -- 365
		Color(30, 20, 44, 255), -- 365
		function() return self:doConfirm() end -- 365
	) -- 365
	self:makeButton( -- 366
		self.endTurnBtn, -- 366
		"结束回合", -- 366
		{132, 106, 172, 255}, -- 366
		{74, 55, 100, 255}, -- 366
		Color(234, 226, 250, 255), -- 366
		function() return self:doEndTurn() end -- 366
	) -- 366
end -- 363
function GameUI.prototype.renderScreen(self) -- 371
	self.screenLayer:removeAllChildren() -- 372
	local d = DrawNode() -- 373
	d:drawPolygon( -- 374
		rectVerts(0, 0, ____exports.DESIGN_W, ____exports.DESIGN_H), -- 374
		C_BG, -- 374
		0 -- 374
	) -- 374
	local pattern = Color(44, 34, 62, 255) -- 375
	do -- 375
		local i = -10 -- 376
		while i <= 26 do -- 376
			local x = i * 72 -- 377
			d:drawSegment( -- 378
				Vec2(x, -640), -- 378
				Vec2(x + 1280, 640), -- 378
				1, -- 378
				pattern -- 378
			) -- 378
			d:drawSegment( -- 379
				Vec2(x, 640), -- 379
				Vec2(x + 1280, -640), -- 379
				1, -- 379
				pattern -- 379
			) -- 379
			i = i + 1 -- 376
		end -- 376
	end -- 376
	d:addTo(self.screenLayer) -- 381
	if self.screen == "menu" then -- 381
		self:renderMenu() -- 383
	elseif self.screen == "settings" then -- 383
		self:renderSettings() -- 384
	elseif self.screen == "levels" then -- 384
		self:renderLevels() -- 385
	end -- 385
end -- 371
function GameUI.prototype.renderMenu(self) -- 388
	local d = DrawNode() -- 389
	drawGrad( -- 390
		d, -- 390
		0, -- 390
		320, -- 390
		560, -- 390
		210, -- 390
		{54, 41, 74, 255}, -- 390
		{24, 18, 34, 255} -- 390
	) -- 390
	drawBand( -- 391
		d, -- 391
		0, -- 391
		320, -- 391
		560, -- 391
		210, -- 391
		3, -- 391
		C_GOLD_DARK -- 391
	) -- 391
	drawBand( -- 392
		d, -- 392
		0, -- 392
		320, -- 392
		560, -- 392
		210, -- 392
		1, -- 392
		C_GOLD -- 392
	) -- 392
	drawCorners( -- 393
		d, -- 393
		0, -- 393
		320, -- 393
		560, -- 393
		210, -- 393
		14, -- 393
		8, -- 393
		C_GOLD_BRIGHT -- 393
	) -- 393
	d:addTo(self.screenLayer) -- 394
	makeLabel( -- 396
		self.screenLayer, -- 396
		"灵 术 牌", -- 396
		0, -- 396
		350, -- 396
		56, -- 396
		C_GOLD_TEXT -- 396
	) -- 396
	makeLabel( -- 397
		self.screenLayer, -- 397
		"暗 影 术 法", -- 397
		0, -- 397
		268, -- 397
		20, -- 397
		C_TEXT_DIM -- 397
	) -- 397
	self:makeButton( -- 399
		{x = 0, y = 40, w = 300, h = 70}, -- 399
		"开始游戏", -- 399
		{188, 160, 234, 255}, -- 399
		{116, 90, 156, 255}, -- 399
		Color(30, 20, 44, 255), -- 399
		function() -- 399
			self.screen = "levels" -- 399
			self:refresh() -- 399
		end, -- 399
		self.screenLayer, -- 399
		26 -- 399
	) -- 399
	self:makeButton( -- 400
		{x = 0, y = -60, w = 300, h = 70}, -- 400
		"设置", -- 400
		{132, 106, 172, 255}, -- 400
		{74, 55, 100, 255}, -- 400
		Color(234, 226, 250, 255), -- 400
		function() -- 400
			self.settingsBack = "menu" -- 400
			self.screen = "settings" -- 400
			self:refresh() -- 400
		end, -- 400
		self.screenLayer, -- 400
		26 -- 400
	) -- 400
	self:makeButton( -- 401
		{x = 0, y = -160, w = 300, h = 70}, -- 401
		"退出游戏", -- 401
		{96, 74, 118, 255}, -- 401
		{52, 40, 66, 255}, -- 401
		Color(226, 216, 240, 255), -- 401
		function() -- 401
			App:shutdown() -- 401
		end, -- 401
		self.screenLayer, -- 401
		26 -- 401
	) -- 401
end -- 388
function GameUI.prototype.renderSettings(self) -- 404
	local d = DrawNode() -- 405
	drawGrad( -- 406
		d, -- 406
		0, -- 406
		20, -- 406
		620, -- 406
		540, -- 406
		{50, 38, 68, 255}, -- 406
		{22, 17, 32, 255} -- 406
	) -- 406
	drawBand( -- 407
		d, -- 407
		0, -- 407
		20, -- 407
		620, -- 407
		540, -- 407
		3, -- 407
		C_GOLD_DARK -- 407
	) -- 407
	drawBand( -- 408
		d, -- 408
		0, -- 408
		20, -- 408
		620, -- 408
		540, -- 408
		1, -- 408
		C_GOLD -- 408
	) -- 408
	drawCorners( -- 409
		d, -- 409
		0, -- 409
		20, -- 409
		620, -- 409
		540, -- 409
		14, -- 409
		8, -- 409
		C_GOLD_BRIGHT -- 409
	) -- 409
	d:addTo(self.screenLayer) -- 410
	makeLabel( -- 412
		self.screenLayer, -- 412
		"设 置", -- 412
		0, -- 412
		220, -- 412
		38, -- 412
		C_GOLD_TEXT -- 412
	) -- 412
	self:renderVolumeRow( -- 413
		90, -- 413
		"背景音乐", -- 413
		self.bgmVolume, -- 413
		function(delta) return self:changeBgmVolume(delta) end -- 413
	) -- 413
	self:renderVolumeRow( -- 414
		-40, -- 414
		"音效", -- 414
		self.sfxVolume, -- 414
		function(delta) return self:changeSfxVolume(delta) end -- 414
	) -- 414
	self:makeButton( -- 416
		{x = 0, y = -200, w = 260, h = 64}, -- 416
		"返回", -- 416
		{132, 106, 172, 255}, -- 416
		{74, 55, 100, 255}, -- 416
		Color(234, 226, 250, 255), -- 416
		function() -- 416
			self.screen = self.settingsBack -- 416
			self:refresh() -- 416
		end, -- 416
		self.screenLayer, -- 416
		24 -- 416
	) -- 416
end -- 404
function GameUI.prototype.renderVolumeRow(self, y, label, value, onChange) -- 419
	local d = DrawNode() -- 420
	d:drawPolygon( -- 421
		rectVerts(0, y, 360, 16), -- 421
		Color(22, 17, 32, 255), -- 421
		1, -- 421
		C_GOLD_DARK -- 421
	) -- 421
	local bar = 360 * value -- 422
	if bar > 2 then -- 422
		d:drawPolygon( -- 423
			rectVerts(-180 + bar / 2, y, bar, 16), -- 423
			C_GOLD, -- 423
			0 -- 423
		) -- 423
	end -- 423
	d:addTo(self.screenLayer) -- 424
	makeLabel( -- 426
		self.screenLayer, -- 426
		((label .. "  ") .. tostring(math.floor(value * 100 + 0.5))) .. "%", -- 426
		0, -- 426
		y + 52, -- 426
		24, -- 426
		C_TEXT -- 426
	) -- 426
	self:makeButton( -- 427
		{x = -250, y = y, w = 64, h = 56}, -- 427
		"−", -- 427
		{150, 124, 190, 255}, -- 427
		{86, 66, 112, 255}, -- 427
		Color(236, 228, 252, 255), -- 427
		function() return onChange(-0.1) end, -- 427
		self.screenLayer, -- 427
		28 -- 427
	) -- 427
	self:makeButton( -- 428
		{x = 250, y = y, w = 64, h = 56}, -- 428
		"+", -- 428
		{150, 124, 190, 255}, -- 428
		{86, 66, 112, 255}, -- 428
		Color(236, 228, 252, 255), -- 428
		function() return onChange(0.1) end, -- 428
		self.screenLayer, -- 428
		28 -- 428
	) -- 428
end -- 419
function GameUI.prototype.renderLevels(self) -- 431
	local maxLevel = GameDataManager.MAX_LEVEL -- 432
	local unlocked = self.mgr.state.highestLevel -- 433
	if unlocked < 1 then -- 433
		unlocked = 1 -- 434
	end -- 434
	if unlocked > maxLevel then -- 434
		unlocked = maxLevel -- 435
	end -- 435
	local d = DrawNode() -- 437
	drawGrad( -- 438
		d, -- 438
		0, -- 438
		0, -- 438
		660, -- 438
		960, -- 438
		{50, 38, 68, 255}, -- 438
		{22, 17, 32, 255} -- 438
	) -- 438
	drawBand( -- 439
		d, -- 439
		0, -- 439
		0, -- 439
		660, -- 439
		960, -- 439
		3, -- 439
		C_GOLD_DARK -- 439
	) -- 439
	drawBand( -- 440
		d, -- 440
		0, -- 440
		0, -- 440
		660, -- 440
		960, -- 440
		1, -- 440
		C_GOLD -- 440
	) -- 440
	drawCorners( -- 441
		d, -- 441
		0, -- 441
		0, -- 441
		660, -- 441
		960, -- 441
		14, -- 441
		8, -- 441
		C_GOLD_BRIGHT -- 441
	) -- 441
	local cols = {-200, 0, 200} -- 443
	local rows = { -- 444
		330, -- 444
		150, -- 444
		-30, -- 444
		-210, -- 444
		-390 -- 444
	} -- 444
	local px = {} -- 445
	local py = {} -- 446
	do -- 446
		local i = 0 -- 447
		while i < maxLevel do -- 447
			local row = math.floor(i / 3) -- 448
			local col = i % 3 -- 449
			local c = row % 2 == 0 and col or 2 - col -- 450
			px[#px + 1] = cols[c + 1] -- 451
			py[#py + 1] = rows[row + 1] -- 452
			i = i + 1 -- 447
		end -- 447
	end -- 447
	do -- 447
		local i = 0 -- 454
		while i + 1 < maxLevel do -- 454
			d:drawSegment( -- 455
				Vec2(px[i + 1], py[i + 1]), -- 455
				Vec2(px[i + 1 + 1], py[i + 1 + 1]), -- 455
				3, -- 455
				C_GOLD_DARK -- 455
			) -- 455
			i = i + 1 -- 454
		end -- 454
	end -- 454
	d:addTo(self.screenLayer) -- 457
	makeLabel( -- 459
		self.screenLayer, -- 459
		"选 择 关 卡", -- 459
		0, -- 459
		545, -- 459
		38, -- 459
		C_GOLD_TEXT -- 459
	) -- 459
	makeLabel( -- 460
		self.screenLayer, -- 460
		(("共 " .. tostring(maxLevel)) .. " 关 · 已解锁 ") .. tostring(unlocked), -- 460
		0, -- 460
		498, -- 460
		22, -- 460
		C_TEXT_DIM -- 460
	) -- 460
	do -- 460
		local i = 0 -- 462
		while i < maxLevel do -- 462
			local lv = i + 1 -- 463
			local open = lv <= unlocked -- 464
			local x = px[i + 1] -- 465
			local y = py[i + 1] -- 466
			local nd = DrawNode() -- 468
			if open then -- 468
				nd:drawDot( -- 470
					Vec2(x, y), -- 470
					40, -- 470
					C_GOLD -- 470
				) -- 470
				nd:drawDot( -- 471
					Vec2(x, y), -- 471
					34, -- 471
					C_BADGE -- 471
				) -- 471
			else -- 471
				nd:drawDot( -- 473
					Vec2(x, y), -- 473
					40, -- 473
					Color(58, 48, 74, 255) -- 473
				) -- 473
				nd:drawDot( -- 474
					Vec2(x, y), -- 474
					34, -- 474
					Color(26, 20, 34, 255) -- 474
				) -- 474
			end -- 474
			nd:addTo(self.screenLayer) -- 476
			makeLabel( -- 477
				self.screenLayer, -- 477
				"" .. tostring(lv), -- 477
				x, -- 477
				y, -- 477
				open and 26 or 22, -- 477
				open and C_GOLD_TEXT or Color(104, 94, 120, 255) -- 477
			) -- 477
			if open then -- 477
				local hit = Node() -- 480
				hit.position = Vec2(x, y) -- 481
				hit.size = Size(84, 84) -- 482
				hit.anchor = Vec2(0.5, 0.5) -- 483
				hit.touchEnabled = true -- 484
				hit:onTapped(function() return self:startLevelAt(lv) end) -- 485
				hit:addTo(self.screenLayer) -- 486
			end -- 486
			i = i + 1 -- 462
		end -- 462
	end -- 462
	self:makeButton( -- 490
		{x = 0, y = -560, w = 240, h = 62}, -- 490
		"返回", -- 490
		{132, 106, 172, 255}, -- 490
		{74, 55, 100, 255}, -- 490
		Color(234, 226, 250, 255), -- 490
		function() -- 490
			self.screen = "menu" -- 490
			self:refresh() -- 490
		end, -- 490
		self.screenLayer, -- 490
		24 -- 490
	) -- 490
end -- 431
function GameUI.prototype.startLevelAt(self, level) -- 494
	self.mgr:startLevel(level) -- 495
	self.rewardsApplied = false -- 496
	self.lastReward = nil -- 497
	self.selectedCardId = nil -- 498
	self.metaOpen = false -- 499
	self.metaMessage = "" -- 500
	self.screen = "game" -- 501
	self:refresh() -- 502
end -- 494
function GameUI.prototype.changeBgmVolume(self, delta) -- 505
	local v = self.bgmVolume + delta -- 506
	if v < 0 then -- 506
		v = 0 -- 507
	end -- 507
	if v > 1 then -- 507
		v = 1 -- 508
	end -- 508
	self.bgmVolume = v -- 509
	if self.bgmSource then -- 509
		self.bgmSource.volume = v -- 510
	end -- 510
	self.save.bgmVolume = v -- 511
	self.save:save() -- 512
	self:refresh() -- 513
end -- 505
function GameUI.prototype.changeSfxVolume(self, delta) -- 516
	local v = self.sfxVolume + delta -- 517
	if v < 0 then -- 517
		v = 0 -- 518
	end -- 518
	if v > 1 then -- 518
		v = 1 -- 519
	end -- 519
	self.sfxVolume = v -- 520
	self.save.sfxVolume = v -- 521
	self.save:save() -- 522
	self:refresh() -- 523
end -- 516
function GameUI.prototype.syncProgress(self) -- 527
	local st = self.mgr.state.status -- 528
	if st == "won" or st == "complete" then -- 528
		local next = self.mgr.state.level + 1 -- 530
		if next > GameDataManager.MAX_LEVEL then -- 530
			next = GameDataManager.MAX_LEVEL -- 531
		end -- 531
		self.mgr:unlockLevel(next) -- 532
	end -- 532
	local hl = self.mgr.state.highestLevel -- 534
	if hl > self.save.highestLevel then -- 534
		self.save.highestLevel = hl -- 536
		self.save:save() -- 537
	end -- 537
end -- 527
function GameUI.prototype.renderHud(self) -- 541
	self.hudLayer:removeAllChildren() -- 542
	local s = self.mgr.state -- 543
	makeLabel( -- 544
		self.hudLayer, -- 544
		(("生命 " .. tostring(s.hp)) .. "/") .. tostring(s.maxHp), -- 544
		-280, -- 544
		585, -- 544
		24, -- 544
		s.hp <= 1 and C_DANGER or C_TEXT -- 545
	) -- 545
	makeLabel( -- 546
		self.hudLayer, -- 546
		("第 " .. tostring(s.level)) .. " 关", -- 546
		0, -- 546
		585, -- 546
		26, -- 546
		C_TEXT -- 546
	) -- 546
	makeLabel( -- 547
		self.hudLayer, -- 547
		((("需消除 " .. tostring(s.eliminatedCount)) .. "/") .. tostring(s.targetCount)) .. " 张", -- 547
		0, -- 547
		545, -- 547
		18, -- 547
		C_TEXT_DIM -- 547
	) -- 547
	makeLabel( -- 548
		self.hudLayer, -- 548
		"回合 " .. tostring(s.turn), -- 548
		120, -- 548
		585, -- 548
		22, -- 548
		C_TEXT -- 548
	) -- 548
	local hint = self.hintText ~= "" and self.hintText or "拖硬币到卡牌 · 点硬币切换正负 · 点卡牌后确定" -- 550
	makeLabel( -- 551
		self.hudLayer, -- 551
		hint, -- 551
		0, -- 551
		498, -- 551
		22, -- 551
		self.hintText ~= "" and C_DANGER or C_GOLD_TEXT -- 551
	) -- 551
end -- 541
function GameUI.prototype.renderCards(self) -- 554
	self.cardLayer:removeAllChildren() -- 555
	self.cardRects = {} -- 556
	local cards = self.mgr.state.cards -- 557
	local gridW = CARD_COLS * CARD_W + (CARD_COLS - 1) * CARD_GAP_X -- 558
	local gridH = CARD_ROWS * CARD_H + (CARD_ROWS - 1) * CARD_GAP_Y -- 559
	local startX = -gridW / 2 + CARD_W / 2 -- 560
	local startY = 250 + gridH / 2 - CARD_H / 2 -- 561
	local maxCards = CARD_COLS * CARD_ROWS -- 562
	do -- 562
		local i = 0 -- 564
		while i < #cards and i < maxCards do -- 564
			local card = cards[i + 1] -- 565
			local col = i % CARD_COLS -- 566
			local row = math.floor(i / CARD_COLS) -- 567
			local x = startX + col * (CARD_W + CARD_GAP_X) -- 568
			local y = startY - row * (CARD_H + CARD_GAP_Y) -- 569
			self:buildCard(card, x, y) -- 570
			i = i + 1 -- 564
		end -- 564
	end -- 564
end -- 554
function GameUI.prototype.buildCard(self, card, x, y) -- 575
	local ____self_cardRects_0 = self.cardRects -- 575
	____self_cardRects_0[#____self_cardRects_0 + 1] = { -- 576
		id = card.id, -- 576
		x = x, -- 576
		y = y, -- 576
		w = CARD_W, -- 576
		h = CARD_H -- 576
	} -- 576
	local hit = Node() -- 579
	hit.position = Vec2(x, y) -- 580
	hit.size = Size(CARD_W, CARD_H) -- 581
	hit.anchor = Vec2(0.5, 0.5) -- 582
	hit.touchEnabled = true -- 583
	hit:onTapped(function() -- 584
		self.selectedCardId = card.id -- 585
		self.hintText = "" -- 586
		self:refresh() -- 587
	end) -- 584
	hit:addTo(self.cardLayer) -- 589
	local node = Node() -- 591
	node.position = Vec2(x, y) -- 592
	local selected = card.id == self.selectedCardId -- 594
	local border = selected and C_GOLD_BRIGHT or C_GOLD -- 595
	local borderW = selected and 4 or 3 -- 596
	local d = DrawNode() -- 598
	if selected then -- 598
		drawGrad( -- 601
			d, -- 601
			0, -- 601
			0, -- 601
			CARD_W, -- 601
			CARD_H, -- 601
			{90, 70, 122, 255}, -- 601
			{46, 35, 64, 255} -- 601
		) -- 601
	else -- 601
		drawGrad( -- 603
			d, -- 603
			0, -- 603
			0, -- 603
			CARD_W, -- 603
			CARD_H, -- 603
			{58, 44, 78, 255}, -- 603
			{28, 21, 40, 255} -- 603
		) -- 603
	end -- 603
	drawBand( -- 605
		d, -- 605
		0, -- 605
		0, -- 605
		CARD_W, -- 605
		CARD_H, -- 605
		borderW, -- 605
		border -- 605
	) -- 605
	drawBand( -- 606
		d, -- 606
		0, -- 606
		0, -- 606
		CARD_W - 12, -- 606
		CARD_H - 12, -- 606
		1, -- 606
		selected and C_GOLD_BRIGHT or C_GOLD_DARK -- 606
	) -- 606
	drawCorners( -- 607
		d, -- 607
		0, -- 607
		0, -- 607
		CARD_W, -- 607
		CARD_H, -- 607
		14, -- 607
		7, -- 607
		C_GOLD_BRIGHT -- 607
	) -- 607
	d:drawDot( -- 609
		Vec2(74, 104), -- 609
		25, -- 609
		C_GOLD -- 609
	) -- 609
	d:drawDot( -- 610
		Vec2(74, 104), -- 610
		21, -- 610
		C_BADGE -- 610
	) -- 610
	d:addTo(node) -- 611
	makeLabel( -- 614
		node, -- 614
		"" .. tostring(card.target), -- 614
		0, -- 614
		52, -- 614
		72, -- 614
		C_TEXT -- 614
	) -- 614
	makeLabel( -- 615
		node, -- 615
		"目标", -- 615
		0, -- 615
		112, -- 615
		16, -- 615
		C_TEXT_DIM -- 615
	) -- 615
	makeLabel( -- 618
		node, -- 618
		"" .. tostring(card.countdown), -- 618
		74, -- 618
		104, -- 618
		22, -- 618
		card.countdown <= 1 and C_DANGER or C_TEXT -- 619
	) -- 619
	makeLabel( -- 620
		node, -- 620
		"回合", -- 620
		74, -- 620
		132, -- 620
		11, -- 620
		C_TEXT_DIM -- 620
	) -- 620
	local bx = -92 -- 623
	local by = 112 -- 624
	if card.target ~= card.originalTarget then -- 624
		d:drawDot( -- 626
			Vec2(bx, by), -- 626
			12, -- 626
			coinColor(CoinType.Discount) -- 626
		) -- 626
		makeLabel( -- 627
			node, -- 627
			"折", -- 627
			bx, -- 627
			by, -- 627
			12, -- 627
			C_TEXT -- 627
		) -- 627
		bx = bx + 26 -- 628
	end -- 628
	if card.frozen then -- 628
		d:drawDot( -- 631
			Vec2(bx, by), -- 631
			12, -- 631
			coinColor(CoinType.Freeze) -- 631
		) -- 631
		makeLabel( -- 632
			node, -- 632
			"冻", -- 632
			bx, -- 632
			by, -- 632
			12, -- 632
			C_TEXT -- 632
		) -- 632
		bx = bx + 26 -- 633
	end -- 633
	if card.healAmount > 0 then -- 633
		d:drawDot( -- 636
			Vec2(bx, by), -- 636
			12, -- 636
			coinColor(CoinType.Heal) -- 636
		) -- 636
		makeLabel( -- 637
			node, -- 637
			"回", -- 637
			bx, -- 637
			by, -- 637
			12, -- 637
			C_TEXT -- 637
		) -- 637
		bx = bx + 26 -- 638
	end -- 638
	if card.copyArmed then -- 638
		d:drawDot( -- 641
			Vec2(bx, by), -- 641
			12, -- 641
			coinColor(CoinType.Copy) -- 641
		) -- 641
		makeLabel( -- 642
			node, -- 642
			"复", -- 642
			bx, -- 642
			by, -- 642
			12, -- 642
			C_TEXT -- 642
		) -- 642
		bx = bx + 26 -- 643
	end -- 643
	local eq = self:equationText(card) -- 647
	makeLabel( -- 648
		node, -- 648
		eq, -- 648
		0, -- 648
		-22, -- 648
		20, -- 648
		eq == "算式：0" and C_TEXT_DIM or C_TEXT -- 648
	) -- 648
	node:addTo(self.cardLayer) -- 650
	local n = #card.coins -- 653
	local chipGap = n > 1 and math.min(46, (CARD_W - 44) / (n - 1)) or 0 -- 654
	do -- 654
		local i = 0 -- 655
		while i < n do -- 655
			local pc = card.coins[i + 1] -- 656
			local idx = i -- 657
			local chipX = (i - (n - 1) / 2) * chipGap -- 658
			local chipY = -100 -- 659
			d:drawDot( -- 660
				Vec2(chipX, chipY), -- 660
				18, -- 660
				coinColor(pc.type) -- 660
			) -- 660
			d:drawDot( -- 661
				Vec2(chipX, chipY), -- 661
				13, -- 661
				C_BADGE -- 661
			) -- 661
			makeLabel( -- 662
				node, -- 662
				self:opSymbol(pc.op) .. tostring(pc.value), -- 662
				chipX, -- 662
				chipY, -- 662
				17, -- 662
				C_TEXT -- 662
			) -- 662
			local chip = Node() -- 663
			chip.position = Vec2(x + chipX, y + chipY) -- 664
			chip.size = Size(48, 48) -- 665
			chip.anchor = Vec2(0.5, 0.5) -- 666
			chip.touchEnabled = true -- 667
			chip.swallowTouches = true -- 668
			chip:onTapped(function() -- 669
				self.mgr:togglePlacedCoin(card.id, idx) -- 670
				self:refresh() -- 671
			end) -- 669
			chip:onTapBegan(function(t) return self:beginDrag( -- 673
				"placed", -- 673
				card.id, -- 673
				idx, -- 673
				pc.type, -- 673
				pc.value, -- 673
				t -- 673
			) end) -- 673
			chip:onTapMoved(function(t) return self:moveDrag(t) end) -- 674
			chip:onTapEnded(function(t) return self:endDrag(t) end) -- 675
			chip:addTo(self.cardLayer) -- 676
			i = i + 1 -- 655
		end -- 655
	end -- 655
end -- 575
function GameUI.prototype.equationText(self, card) -- 681
	if #card.coins == 0 then -- 681
		return "算式：0" -- 682
	end -- 682
	local s = "算式：0" -- 683
	do -- 683
		local i = 0 -- 684
		while i < #card.coins do -- 684
			local c = card.coins[i + 1] -- 685
			if c.type == CoinType.Multiply then -- 685
				s = s .. (c.op == "div" and " ÷ " .. tostring(c.value) or " × " .. tostring(c.value)) -- 687
			else -- 687
				s = s .. (c.op == "sub" and " − " .. tostring(c.value) or " + " .. tostring(c.value)) -- 689
			end -- 689
			i = i + 1 -- 684
		end -- 684
	end -- 684
	return (s .. " = ") .. tostring(self.mgr:evaluateCard(card)) -- 692
end -- 681
function GameUI.prototype.renderCoins(self) -- 695
	self.coinLayer:removeAllChildren() -- 696
	makeLabel( -- 697
		self.coinLayer, -- 697
		"硬币背包", -- 697
		0, -- 697
		-168, -- 697
		20, -- 697
		C_TEXT_DIM -- 697
	) -- 697
	local inv = self.mgr.state.inventory -- 699
	local cols = 3 -- 700
	local groupW = 216 -- 701
	local groupH = 128 -- 702
	local rowCenters = {-262, -396, -530} -- 703
	local colCenters = {-220, 0, 220} -- 704
	local idx = 0 -- 706
	do -- 706
		local t = 0 -- 707
		while t < #COIN_TYPE_ORDER do -- 707
			do -- 707
				local ____type = COIN_TYPE_ORDER[t + 1] -- 708
				local stacks = {} -- 709
				local total = 0 -- 710
				do -- 710
					local i = 0 -- 711
					while i < #inv do -- 711
						if inv[i + 1].type == ____type then -- 711
							stacks[#stacks + 1] = inv[i + 1] -- 713
							total = total + inv[i + 1].count -- 714
						end -- 714
						i = i + 1 -- 711
					end -- 711
				end -- 711
				if #stacks == 0 then -- 711
					goto __continue106 -- 717
				end -- 717
				local col = idx % cols -- 719
				local row = math.floor(idx / cols) -- 720
				if row >= 3 then -- 720
					break -- 721
				end -- 721
				local gx = colCenters[col + 1] -- 722
				local gy = rowCenters[row + 1] -- 723
				self:buildCoinGroup( -- 724
					____type, -- 724
					stacks, -- 724
					total, -- 724
					gx, -- 724
					gy, -- 724
					groupW, -- 724
					groupH -- 724
				) -- 724
				idx = idx + 1 -- 725
			end -- 725
			::__continue106:: -- 725
			t = t + 1 -- 707
		end -- 707
	end -- 707
	makeLabel( -- 728
		self.coinLayer, -- 728
		((("最高关卡 " .. tostring(self.mgr.state.highestLevel)) .. " · 货币 ") .. tostring(self.mgr.state.currency)) .. " · 单次奖励上限 1000", -- 729
		0, -- 730
		-600, -- 730
		15, -- 730
		C_GOLD_TEXT -- 730
	) -- 730
end -- 695
function GameUI.prototype.buildCoinGroup(self, ____type, stacks, total, gx, gy, w, h) -- 734
	local node = Node() -- 743
	node.position = Vec2(gx, gy) -- 744
	local d = DrawNode() -- 746
	drawGrad( -- 748
		d, -- 748
		0, -- 748
		0, -- 748
		w, -- 748
		h, -- 748
		{50, 38, 68, 255}, -- 748
		{24, 18, 34, 255} -- 748
	) -- 748
	drawBand( -- 749
		d, -- 749
		0, -- 749
		0, -- 749
		w, -- 749
		h, -- 749
		2, -- 749
		C_GOLD_DARK -- 749
	) -- 749
	drawCorners( -- 750
		d, -- 750
		0, -- 750
		0, -- 750
		w, -- 750
		h, -- 750
		10, -- 750
		5, -- 750
		C_GOLD -- 750
	) -- 750
	d:addTo(node) -- 751
	node:addTo(self.coinLayer) -- 752
	makeLabel( -- 754
		node, -- 754
		(coinTypeName(____type) .. " ×") .. tostring(total), -- 754
		-100, -- 754
		46, -- 754
		20, -- 754
		C_GOLD_TEXT, -- 754
		Vec2(0, 0.5) -- 754
	) -- 754
	local n = #stacks -- 756
	local chipRadius = 26 -- 757
	local chipGap = n > 1 and math.min(44, (w - 2 * chipRadius) / (n - 1)) or 0 -- 758
	do -- 758
		local i = 0 -- 759
		while i < n do -- 759
			local stack = stacks[i + 1] -- 762
			local chipX = (i - (n - 1) / 2) * chipGap -- 763
			local chipY = -12 -- 764
			local cc = coinColor(____type) -- 766
			d:drawDot( -- 767
				Vec2(chipX, chipY), -- 767
				chipRadius, -- 767
				cc -- 767
			) -- 767
			d:drawDot( -- 768
				Vec2(chipX, chipY), -- 768
				chipRadius - 3, -- 768
				C_GOLD_DARK -- 768
			) -- 768
			d:drawDot( -- 769
				Vec2(chipX, chipY), -- 769
				chipRadius - 6, -- 769
				C_BADGE -- 769
			) -- 769
			d:drawDot( -- 770
				Vec2(chipX - chipRadius * 0.3, chipY + chipRadius * 0.34), -- 770
				chipRadius * 0.26, -- 770
				Color(238, 226, 198, 26) -- 770
			) -- 770
			makeLabel( -- 771
				node, -- 771
				coinChipText(____type, stack.value), -- 771
				chipX, -- 771
				chipY + 6, -- 771
				20, -- 771
				C_TEXT -- 771
			) -- 771
			if stack.count > 1 then -- 771
				makeLabel( -- 773
					node, -- 773
					"×" .. tostring(stack.count), -- 773
					chipX, -- 773
					chipY - 36, -- 773
					13, -- 773
					C_TEXT_FAINT -- 773
				) -- 773
			end -- 773
			local chip = Node() -- 776
			chip.position = Vec2(gx + chipX, gy + chipY) -- 777
			chip.size = Size(68, 68) -- 778
			chip.anchor = Vec2(0.5, 0.5) -- 779
			chip.touchEnabled = true -- 780
			chip.swallowTouches = true -- 781
			chip:onTapped(function() -- 782
				self:log("FLIP " .. tostring(stack.value)) -- 783
				self.mgr:flipCoinSign(____type, stack.value) -- 784
				self.hintText = "" -- 785
				self:refresh() -- 786
			end) -- 782
			chip:onTapBegan(function(t) return self:beginDrag( -- 788
				"inventory", -- 788
				0, -- 788
				0, -- 788
				____type, -- 788
				stack.value, -- 788
				t -- 788
			) end) -- 788
			chip:onTapMoved(function(t) return self:moveDrag(t) end) -- 789
			chip:onTapEnded(function(t) return self:endDrag(t) end) -- 790
			chip:addTo(self.coinLayer) -- 791
			i = i + 1 -- 759
		end -- 759
	end -- 759
end -- 734
function GameUI.prototype.updateOverlay(self) -- 797
	local s = self.mgr.state -- 798
	self.overlayLayer:removeAllChildren() -- 799
	if s.status == "playing" then -- 799
		self.metaOpen = false -- 802
		self.metaMessage = "" -- 803
		return -- 804
	end -- 804
	local dim = DrawNode() -- 808
	dim:drawPolygon( -- 809
		rectVerts(0, 0, ____exports.DESIGN_W, ____exports.DESIGN_H), -- 809
		Color(8, 6, 5, 210), -- 809
		0 -- 809
	) -- 809
	dim:addTo(self.overlayLayer) -- 810
	if self.metaOpen then -- 810
		self:renderMetaPanel() -- 813
		return -- 814
	end -- 814
	local panel = DrawNode() -- 818
	panel:drawPolygon( -- 819
		rectVerts(0, 0, 520, 430), -- 819
		C_PANEL, -- 819
		4, -- 819
		C_PANEL_BORDER -- 819
	) -- 819
	panel:addTo(self.overlayLayer) -- 820
	if s.status == "lost" then -- 820
		makeLabel( -- 823
			self.overlayLayer, -- 823
			"游戏失败", -- 823
			0, -- 823
			120, -- 823
			34, -- 823
			C_DANGER -- 823
		) -- 823
		makeLabel( -- 824
			self.overlayLayer, -- 824
			"生命归零，未能完成本关", -- 824
			0, -- 824
			60, -- 824
			18, -- 824
			C_TEXT_DIM -- 824
		) -- 824
		makeLabel( -- 825
			self.overlayLayer, -- 825
			((((("第 " .. tostring(s.level)) .. " 关 · 已消除 ") .. tostring(s.eliminatedCount)) .. "/") .. tostring(s.targetCount)) .. " 张", -- 825
			0, -- 825
			22, -- 825
			16, -- 825
			C_TEXT_DIM -- 825
		) -- 825
		self:addOverlayButton( -- 826
			"重试", -- 826
			0, -- 826
			-120, -- 826
			220, -- 826
			50, -- 826
			C_ENDTURN, -- 826
			"retry" -- 826
		) -- 826
	elseif s.status == "complete" then -- 826
		if not self.rewardsApplied then -- 826
			self.lastReward = self.mgr:applyWinRewards() -- 828
			self.rewardsApplied = true -- 828
		end -- 828
		makeLabel( -- 829
			self.overlayLayer, -- 829
			"全部通关！", -- 829
			0, -- 829
			120, -- 829
			34, -- 829
			C_GOLD_TEXT -- 829
		) -- 829
		makeLabel( -- 830
			self.overlayLayer, -- 830
			("你完成了全部 " .. tostring(GameDataManager.MAX_LEVEL)) .. " 关", -- 830
			0, -- 830
			60, -- 830
			18, -- 830
			C_TEXT -- 830
		) -- 830
		makeLabel( -- 831
			self.overlayLayer, -- 831
			"总货币 " .. tostring(s.currency), -- 831
			0, -- 831
			22, -- 831
			16, -- 831
			C_TEXT_DIM -- 831
		) -- 831
		self:addOverlayButton( -- 832
			"重新开始", -- 832
			0, -- 832
			-90, -- 832
			220, -- 832
			44, -- 832
			C_CONFIRM, -- 832
			"restart" -- 832
		) -- 832
		self:addOverlayButton( -- 833
			"选择关卡", -- 833
			0, -- 833
			-150, -- 833
			220, -- 833
			44, -- 833
			Color(104, 82, 148, 255), -- 833
			"toLevels" -- 833
		) -- 833
	else -- 833
		if not self.rewardsApplied then -- 833
			self.lastReward = self.mgr:applyWinRewards() -- 835
			self.rewardsApplied = true -- 835
		end -- 835
		makeLabel( -- 836
			self.overlayLayer, -- 836
			"关卡完成！", -- 836
			0, -- 836
			120, -- 836
			34, -- 836
			C_GOLD_TEXT -- 836
		) -- 836
		makeLabel( -- 837
			self.overlayLayer, -- 837
			(((((("已消除 " .. tostring(s.eliminatedCount)) .. "/") .. tostring(s.targetCount)) .. " 张 · 生命 ") .. tostring(s.hp)) .. "/") .. tostring(s.maxHp), -- 837
			0, -- 837
			60, -- 837
			18, -- 837
			C_TEXT -- 837
		) -- 837
		local rewardText = "货币 +0 · 新硬币 +1" -- 838
		if self.lastReward then -- 838
			rewardText = (((("货币 +" .. tostring(self.lastReward.currency)) .. " · 新硬币：") .. coinTypeName(self.lastReward.coinType)) .. " ") .. tostring(self.lastReward.coinValue) -- 840
		end -- 840
		makeLabel( -- 842
			self.overlayLayer, -- 842
			rewardText, -- 842
			0, -- 842
			22, -- 842
			16, -- 842
			C_TEXT_DIM -- 842
		) -- 842
		self:addOverlayButton( -- 843
			"下一关", -- 843
			0, -- 843
			-80, -- 843
			220, -- 843
			44, -- 843
			C_CONFIRM, -- 843
			"next" -- 843
		) -- 843
		self:addOverlayButton( -- 844
			"选择关卡", -- 844
			0, -- 844
			-135, -- 844
			220, -- 844
			44, -- 844
			Color(104, 82, 148, 255), -- 844
			"toLevels" -- 844
		) -- 844
		self:addOverlayButton( -- 845
			"养成", -- 845
			0, -- 845
			-190, -- 845
			220, -- 845
			44, -- 845
			Color(104, 82, 148, 255), -- 845
			"meta" -- 845
		) -- 845
	end -- 845
end -- 797
function GameUI.prototype.renderMetaPanel(self) -- 849
	local panel = DrawNode() -- 850
	panel:drawPolygon( -- 851
		rectVerts(0, 0, 640, 560), -- 851
		C_PANEL, -- 851
		4, -- 851
		C_PANEL_BORDER -- 851
	) -- 851
	panel:addTo(self.overlayLayer) -- 852
	local s = self.mgr.state -- 854
	makeLabel( -- 855
		self.overlayLayer, -- 855
		"局外养成", -- 855
		0, -- 855
		230, -- 855
		30, -- 855
		C_GOLD_TEXT -- 855
	) -- 855
	makeLabel( -- 856
		self.overlayLayer, -- 856
		(((("货币 " .. tostring(s.currency)) .. " · 血量上限 ") .. tostring(s.maxHp)) .. " · 删除次数 ") .. tostring(self.mgr.deleteCredits), -- 856
		0, -- 856
		180, -- 856
		16, -- 856
		C_TEXT -- 856
	) -- 856
	makeLabel( -- 857
		self.overlayLayer, -- 857
		"扫荡奖励按最高关卡计，货币上限 1000", -- 857
		0, -- 857
		148, -- 857
		13, -- 857
		C_TEXT_DIM -- 857
	) -- 857
	if self.metaMessage ~= "" then -- 857
		makeLabel( -- 859
			self.overlayLayer, -- 859
			self.metaMessage, -- 859
			0, -- 859
			112, -- 859
			14, -- 859
			Color(120, 220, 150, 255) -- 859
		) -- 859
	end -- 859
	self:addOverlayButton( -- 862
		"合成硬币", -- 862
		0, -- 862
		60, -- 862
		300, -- 862
		44, -- 862
		Color(104, 82, 148, 255), -- 862
		"synthesize" -- 862
	) -- 862
	self:addOverlayButton( -- 863
		"强化血量（100）", -- 863
		0, -- 863
		4, -- 863
		300, -- 863
		44, -- 863
		C_ENDTURN, -- 863
		"upgradeHp" -- 863
	) -- 863
	self:addOverlayButton( -- 864
		"强化删除次数（80）", -- 864
		0, -- 864
		-52, -- 864
		300, -- 864
		44, -- 864
		C_ENDTURN, -- 864
		"upgradeDelete" -- 864
	) -- 864
	self:addOverlayButton( -- 865
		"删除一枚硬币", -- 865
		0, -- 865
		-108, -- 865
		300, -- 865
		44, -- 865
		Color(158, 70, 104, 255), -- 865
		"delete" -- 865
	) -- 865
	self:addOverlayButton( -- 866
		"扫荡", -- 866
		0, -- 866
		-164, -- 866
		300, -- 866
		44, -- 866
		C_CONFIRM, -- 866
		"sweep" -- 866
	) -- 866
	self:addOverlayButton( -- 867
		"返回", -- 867
		0, -- 867
		-230, -- 867
		300, -- 867
		44, -- 867
		Color(84, 70, 118, 255), -- 867
		"back" -- 867
	) -- 867
end -- 849
function GameUI.prototype.addOverlayButton(self, text, cx, cy, w, h, color, action) -- 870
	local node = Node() -- 871
	node.position = Vec2(cx, cy) -- 872
	node.size = Size(w, h) -- 873
	node.anchor = Vec2(0.5, 0.5) -- 874
	local d = DrawNode() -- 875
	d:drawPolygon( -- 876
		rectVerts(w / 2, h / 2, w, h), -- 876
		color, -- 876
		2, -- 876
		C_CONFIRM_BORDER -- 876
	) -- 876
	d:addTo(node) -- 877
	makeLabel( -- 878
		node, -- 878
		text, -- 878
		w / 2, -- 878
		h / 2, -- 878
		20, -- 878
		C_TEXT -- 878
	) -- 878
	node.touchEnabled = true -- 879
	node:onTapped(function() return self:handleOverlayAction(action) end) -- 880
	node:addTo(self.overlayLayer) -- 881
end -- 870
function GameUI.prototype.handleOverlayAction(self, action) -- 884
	if action == "toLevels" then -- 884
		self.metaOpen = false -- 886
		self.metaMessage = "" -- 887
		self.screen = "levels" -- 888
		self:refresh() -- 889
		return -- 890
	end -- 890
	if action == "retry" then -- 890
		self.mgr:startLevel(self.mgr.state.level) -- 893
		self.rewardsApplied = false -- 894
		self.lastReward = nil -- 895
		self.selectedCardId = nil -- 896
		self.metaOpen = false -- 897
		self.metaMessage = "" -- 898
		self:refresh() -- 899
		return -- 900
	end -- 900
	if action == "next" then -- 900
		self.mgr:startLevel(self.mgr.state.level + 1) -- 903
		self.rewardsApplied = false -- 904
		self.lastReward = nil -- 905
		self.selectedCardId = nil -- 906
		self.metaOpen = false -- 907
		self.metaMessage = "" -- 908
		self:refresh() -- 909
		return -- 910
	end -- 910
	if action == "restart" then -- 910
		self.mgr:startLevel(1) -- 913
		self.rewardsApplied = false -- 914
		self.lastReward = nil -- 915
		self.selectedCardId = nil -- 916
		self.metaOpen = false -- 917
		self.metaMessage = "" -- 918
		self:refresh() -- 919
		return -- 920
	end -- 920
	if action == "meta" then -- 920
		self.metaOpen = true -- 923
		self.metaMessage = "" -- 924
		self:refresh() -- 925
		return -- 926
	end -- 926
	if action == "back" then -- 926
		self.metaOpen = false -- 929
		self.metaMessage = "" -- 930
		self:refresh() -- 931
		return -- 932
	end -- 932
	if action == "synthesize" then -- 932
		local r = self.mgr:synthesizeOnce() -- 935
		self.metaMessage = r.ok and (((((("合成成功：" .. coinTypeName(r.type)) .. " ") .. tostring(r.valueA)) .. " + ") .. tostring(r.valueB)) .. " → ") .. tostring(r.resultValue) or "无可合成硬币（需同类型至少 2 枚）" -- 936
		self:refresh() -- 939
		return -- 940
	end -- 940
	if action == "upgradeHp" then -- 940
		local r = self.mgr:upgradeMaxHp() -- 943
		self.metaMessage = r.ok and "血量上限提升至 " .. tostring(r.newMaxHp) or r.reason -- 944
		self:refresh() -- 945
		return -- 946
	end -- 946
	if action == "upgradeDelete" then -- 946
		local r = self.mgr:upgradeDeleteCredits() -- 949
		self.metaMessage = r.ok and ("删除次数 +2（当前 " .. tostring(r.newCredits)) .. "）" or r.reason -- 950
		self:refresh() -- 951
		return -- 952
	end -- 952
	if action == "delete" then -- 952
		local r = self.mgr:deleteOnce() -- 955
		self.metaMessage = r.ok and (("已删除 " .. coinTypeName(r.type)) .. " ") .. tostring(r.value) or r.reason -- 956
		self:refresh() -- 957
		return -- 958
	end -- 958
	if action == "sweep" then -- 958
		local r = self.mgr:sweepLevel() -- 961
		self.metaMessage = r.ok and (((("扫荡获得货币 +" .. tostring(r.currency)) .. " · 硬币 ") .. coinTypeName(r.coinType)) .. " ") .. tostring(r.coinValue) or r.reason -- 962
		self:refresh() -- 963
		return -- 964
	end -- 964
end -- 884
function GameUI.prototype.makeButton(self, rect, text, top, bottom, textColor, onTap, parent, fontSize) -- 971
	local node = Node() -- 981
	node.position = Vec2(rect.x, rect.y) -- 982
	node.size = Size(rect.w, rect.h) -- 983
	node.anchor = Vec2(0.5, 0.5) -- 984
	local d = DrawNode() -- 985
	drawGrad( -- 986
		d, -- 986
		rect.w / 2, -- 986
		rect.h / 2, -- 986
		rect.w, -- 986
		rect.h, -- 986
		top, -- 986
		bottom -- 986
	) -- 986
	drawSheen( -- 987
		d, -- 987
		rect.w / 2, -- 987
		rect.h / 2, -- 987
		rect.w, -- 987
		rect.h, -- 987
		48 -- 987
	) -- 987
	drawBand( -- 988
		d, -- 988
		rect.w / 2, -- 988
		rect.h / 2, -- 988
		rect.w, -- 988
		rect.h, -- 988
		2, -- 988
		C_GOLD_DARK -- 988
	) -- 988
	drawBand( -- 989
		d, -- 989
		rect.w / 2, -- 989
		rect.h / 2, -- 989
		rect.w - 8, -- 989
		rect.h - 8, -- 989
		1, -- 989
		C_GOLD_BRIGHT -- 989
	) -- 989
	d:addTo(node) -- 990
	makeLabel( -- 991
		node, -- 991
		text, -- 991
		rect.w / 2, -- 991
		rect.h / 2, -- 991
		fontSize and fontSize or 20, -- 991
		textColor -- 991
	) -- 991
	node.touchEnabled = true -- 992
	node:onTapped(function() return onTap() end) -- 993
	node:addTo(parent and parent or self.actionLayer) -- 994
end -- 971
function GameUI.prototype.dragPoint(self, t, node) -- 999
	local wl = t.worldLocation -- 1000
	if wl ~= nil then -- 1000
		return Vec2(wl.x, wl.y) -- 1001
	end -- 1001
	if node then -- 1001
		return node:convertToWorldSpace(t.location) -- 1002
	end -- 1002
	return Vec2(t.location.x, t.location.y) -- 1003
end -- 999
function GameUI.prototype.beginDrag(self, kind, cardId, index, ____type, value, t) -- 1006
	if self.drag then -- 1006
		return -- 1015
	end -- 1015
	self.lastMoveLog = 0 -- 1016
	self.dragEndedEarly = false -- 1017
	self:log((((("BEGIN " .. kind) .. " val=") .. tostring(value)) .. " mouseDown=") .. tostring(Mouse.leftButtonPressed)) -- 1018
	self.drag = { -- 1019
		kind = kind, -- 1019
		cardId = cardId, -- 1019
		index = index, -- 1019
		type = ____type, -- 1019
		value = value -- 1019
	} -- 1019
	local wp = self:dragPoint(t) -- 1020
	self.dragStart = wp -- 1021
	self:makeGhost(____type, value, wp) -- 1022
	self.hintText = "把硬币放到某张卡牌上" -- 1024
	self:renderHud() -- 1025
end -- 1006
function GameUI.prototype.moveDrag(self, t) -- 1028
	if not self.drag then -- 1028
		return -- 1029
	end -- 1029
	local wp = self:dragPoint(t) -- 1030
	if self.dragGhost then -- 1030
		self.dragGhost.position = wp -- 1031
	end -- 1031
	local s = self.dragStart -- 1032
	if s then -- 1032
		local d = math.abs(wp.x - s.x) + math.abs(wp.y - s.y) -- 1034
		if d - self.lastMoveLog >= 40 then -- 1034
			self.lastMoveLog = d -- 1036
			self:log("MOVE d=" .. tostring(math.floor(d + 0.5))) -- 1037
		end -- 1037
	end -- 1037
end -- 1028
function GameUI.prototype.endDrag(self, t) -- 1042
	if not self.drag then -- 1042
		return -- 1043
	end -- 1043
	if Mouse.leftButtonPressed then -- 1043
		self.dragEndedEarly = true -- 1046
		self:log("END early (still pressed)") -- 1047
		return -- 1048
	end -- 1048
	self:finalizeDrag(self:dragPoint(t)) -- 1050
end -- 1042
function GameUI.prototype.tick(self) -- 1054
	if not self.drag or not self.dragEndedEarly then -- 1054
		return -- 1055
	end -- 1055
	if Mouse.leftButtonPressed then -- 1055
		local p = self:mouseDesignPoint() -- 1057
		if self.dragGhost then -- 1057
			self.dragGhost.position = p -- 1058
		end -- 1058
	else -- 1058
		self:finalizeDrag(self:mouseDesignPoint()) -- 1060
	end -- 1060
end -- 1054
function GameUI.prototype.mouseDesignPoint(self) -- 1065
	local mouse = Mouse.position -- 1066
	local visual = App.visualSize -- 1067
	local view = View.size -- 1068
	local z = self.viewZoom -- 1069
	local vx = mouse.x * view.width / visual.width - view.width / 2 -- 1070
	local vy = view.height / 2 - mouse.y * view.height / visual.height -- 1071
	return Vec2(vx / z, vy / z) -- 1072
end -- 1065
function GameUI.prototype.finalizeDrag(self, p) -- 1075
	local d = self.drag -- 1076
	self.drag = nil -- 1077
	self.dragEndedEarly = false -- 1078
	self:hideGhost() -- 1079
	local start = self.dragStart -- 1080
	self.dragStart = nil -- 1081
	if not d then -- 1081
		return -- 1082
	end -- 1082
	local moved = start and math.abs(p.x - start.x) + math.abs(p.y - start.y) or 0 -- 1083
	self:log("END moved=" .. tostring(math.floor(moved + 0.5))) -- 1084
	if moved < 20 then -- 1084
		return -- 1086
	end -- 1086
	if d.kind == "inventory" then -- 1086
		local target = self:cardAtPoint(p) -- 1088
		if target ~= nil then -- 1088
			if self.mgr:placeCoinOnCard(target, d.type, d.value) then -- 1088
				self:playCoinSound() -- 1090
			end -- 1090
			self.hintText = "" -- 1091
		else -- 1091
			self.hintText = "把硬币拖到某张卡牌上" -- 1093
		end -- 1093
		self:refresh() -- 1095
	else -- 1095
		local target = self:cardAtPoint(p) -- 1097
		if target == nil then -- 1097
			self.mgr:removePlacedCoin(d.cardId, d.index) -- 1099
		elseif target ~= d.cardId then -- 1099
			if self.mgr:movePlacedCoin(d.cardId, d.index, target) then -- 1099
				self:playCoinSound() -- 1101
			end -- 1101
		end -- 1101
		self:refresh() -- 1103
	end -- 1103
end -- 1075
function GameUI.prototype.playCoinSound(self) -- 1108
	self:playSfx("Audio/coin.wav") -- 1109
end -- 1108
function GameUI.prototype.playCardSound(self) -- 1113
	self:playSfx("Audio/card_paper.wav") -- 1114
end -- 1113
function GameUI.prototype.playSfx(self, path) -- 1118
	local s = AudioSource(path) -- 1119
	if s then -- 1119
		s.volume = self.sfxVolume -- 1121
		s:addTo(self.fxLayer) -- 1122
		s:play() -- 1123
	end -- 1123
end -- 1118
function GameUI.prototype.cardAtPoint(self, p) -- 1127
	do -- 1127
		local i = 0 -- 1128
		while i < #self.cardRects do -- 1128
			local r = self.cardRects[i + 1] -- 1129
			if p.x >= r.x - r.w / 2 and p.x <= r.x + r.w / 2 and p.y >= r.y - r.h / 2 and p.y <= r.y + r.h / 2 then -- 1129
				return r.id -- 1132
			end -- 1132
			i = i + 1 -- 1128
		end -- 1128
	end -- 1128
	return nil -- 1135
end -- 1127
function GameUI.prototype.makeGhost(self, ____type, value, pos) -- 1138
	self:hideGhost() -- 1139
	local node = Node() -- 1140
	node.position = pos -- 1141
	local d = DrawNode() -- 1142
	d:drawDot( -- 1143
		Vec2.zero, -- 1143
		26, -- 1143
		coinColor(____type) -- 1143
	) -- 1143
	d:drawDot(Vec2.zero, 20, C_BADGE) -- 1144
	d:addTo(node) -- 1145
	local l = Label("sarasa-mono-sc-regular", 20) -- 1146
	if l then -- 1146
		l.text = coinChipText(____type, value) -- 1147
		l.position = Vec2.zero -- 1147
		l.color = C_TEXT -- 1147
		l:addTo(node) -- 1147
	end -- 1147
	node:addTo(self.fxLayer) -- 1148
	self.dragGhost = node -- 1149
end -- 1138
function GameUI.prototype.hideGhost(self) -- 1152
	if self.dragGhost then -- 1152
		self.dragGhost:removeFromParent() -- 1153
		self.dragGhost = nil -- 1153
	end -- 1153
end -- 1152
function GameUI.prototype.doConfirm(self) -- 1156
	if self.mgr.state.status ~= "playing" then -- 1156
		return -- 1157
	end -- 1157
	if self.selectedCardId == nil then -- 1157
		return -- 1158
	end -- 1158
	local res = self.mgr:confirmCard(self.selectedCardId) -- 1159
	if res.ok then -- 1159
		self.selectedCardId = nil -- 1161
		self:playCardSound() -- 1162
	end -- 1162
	self:syncProgress() -- 1164
	self:refresh() -- 1165
end -- 1156
function GameUI.prototype.doEndTurn(self) -- 1168
	if self.mgr.state.status ~= "playing" then -- 1168
		return -- 1169
	end -- 1169
	self.mgr:endTurn() -- 1170
	self.selectedCardId = nil -- 1171
	self:syncProgress() -- 1172
	self:refresh() -- 1173
end -- 1168
function GameUI.prototype.opSymbol(self, op) -- 1176
	if op == "sub" then -- 1176
		return "−" -- 1177
	end -- 1177
	if op == "mul" then -- 1177
		return "×" -- 1178
	end -- 1178
	if op == "div" then -- 1178
		return "÷" -- 1179
	end -- 1179
	return "+" -- 1180
end -- 1176
return ____exports -- 1176