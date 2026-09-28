-- [ts]: GameUI.ts
local ____lualib = require("lualib_bundle") -- 1
local __TS__Class = ____lualib.__TS__Class -- 1
local __TS__New = ____lualib.__TS__New -- 1
local __TS__StringSubstring = ____lualib.__TS__StringSubstring -- 1
local __TS__Number = ____lualib.__TS__Number -- 1
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
function GameUI.prototype.renderActionButtons(self) -- 364
	self.actionLayer:removeAllChildren() -- 365
	self:makeButton( -- 366
		self.endTurnBtn, -- 366
		"结束回合", -- 366
		{132, 106, 172, 255}, -- 366
		{74, 55, 100, 255}, -- 366
		Color(234, 226, 250, 255), -- 366
		function() return self:doEndTurn() end -- 366
	) -- 366
end -- 364
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
	elseif self.screen == "meta" then -- 385
		self:renderMetaPanel(self.screenLayer) -- 386
	end -- 386
end -- 371
function GameUI.prototype.renderMenu(self) -- 389
	local d = DrawNode() -- 390
	drawGrad( -- 391
		d, -- 391
		0, -- 391
		320, -- 391
		560, -- 391
		210, -- 391
		{54, 41, 74, 255}, -- 391
		{24, 18, 34, 255} -- 391
	) -- 391
	drawBand( -- 392
		d, -- 392
		0, -- 392
		320, -- 392
		560, -- 392
		210, -- 392
		3, -- 392
		C_GOLD_DARK -- 392
	) -- 392
	drawBand( -- 393
		d, -- 393
		0, -- 393
		320, -- 393
		560, -- 393
		210, -- 393
		1, -- 393
		C_GOLD -- 393
	) -- 393
	drawCorners( -- 394
		d, -- 394
		0, -- 394
		320, -- 394
		560, -- 394
		210, -- 394
		14, -- 394
		8, -- 394
		C_GOLD_BRIGHT -- 394
	) -- 394
	d:addTo(self.screenLayer) -- 395
	makeLabel( -- 397
		self.screenLayer, -- 397
		"灵 术 牌", -- 397
		0, -- 397
		350, -- 397
		56, -- 397
		C_GOLD_TEXT -- 397
	) -- 397
	makeLabel( -- 398
		self.screenLayer, -- 398
		"暗 影 术 法", -- 398
		0, -- 398
		268, -- 398
		20, -- 398
		C_TEXT_DIM -- 398
	) -- 398
	self:makeButton( -- 400
		{x = 0, y = 40, w = 300, h = 70}, -- 400
		"开始游戏", -- 400
		{188, 160, 234, 255}, -- 400
		{116, 90, 156, 255}, -- 400
		Color(30, 20, 44, 255), -- 400
		function() -- 400
			self.screen = "levels" -- 400
			self:refresh() -- 400
		end, -- 400
		self.screenLayer, -- 400
		26 -- 400
	) -- 400
	self:makeButton( -- 401
		{x = 0, y = -60, w = 300, h = 70}, -- 401
		"设置", -- 401
		{132, 106, 172, 255}, -- 401
		{74, 55, 100, 255}, -- 401
		Color(234, 226, 250, 255), -- 401
		function() -- 401
			self.settingsBack = "menu" -- 401
			self.screen = "settings" -- 401
			self:refresh() -- 401
		end, -- 401
		self.screenLayer, -- 401
		26 -- 401
	) -- 401
	self:makeButton( -- 402
		{x = 0, y = -160, w = 300, h = 70}, -- 402
		"退出游戏", -- 402
		{96, 74, 118, 255}, -- 402
		{52, 40, 66, 255}, -- 402
		Color(226, 216, 240, 255), -- 402
		function() -- 402
			App:shutdown() -- 402
		end, -- 402
		self.screenLayer, -- 402
		26 -- 402
	) -- 402
end -- 389
function GameUI.prototype.renderSettings(self) -- 405
	local d = DrawNode() -- 406
	drawGrad( -- 407
		d, -- 407
		0, -- 407
		20, -- 407
		620, -- 407
		540, -- 407
		{50, 38, 68, 255}, -- 407
		{22, 17, 32, 255} -- 407
	) -- 407
	drawBand( -- 408
		d, -- 408
		0, -- 408
		20, -- 408
		620, -- 408
		540, -- 408
		3, -- 408
		C_GOLD_DARK -- 408
	) -- 408
	drawBand( -- 409
		d, -- 409
		0, -- 409
		20, -- 409
		620, -- 409
		540, -- 409
		1, -- 409
		C_GOLD -- 409
	) -- 409
	drawCorners( -- 410
		d, -- 410
		0, -- 410
		20, -- 410
		620, -- 410
		540, -- 410
		14, -- 410
		8, -- 410
		C_GOLD_BRIGHT -- 410
	) -- 410
	d:addTo(self.screenLayer) -- 411
	makeLabel( -- 413
		self.screenLayer, -- 413
		"设 置", -- 413
		0, -- 413
		220, -- 413
		38, -- 413
		C_GOLD_TEXT -- 413
	) -- 413
	self:renderVolumeRow( -- 414
		90, -- 414
		"背景音乐", -- 414
		self.bgmVolume, -- 414
		function(delta) return self:changeBgmVolume(delta) end -- 414
	) -- 414
	self:renderVolumeRow( -- 415
		-40, -- 415
		"音效", -- 415
		self.sfxVolume, -- 415
		function(delta) return self:changeSfxVolume(delta) end -- 415
	) -- 415
	self:makeButton( -- 417
		{x = 0, y = -200, w = 260, h = 64}, -- 417
		"返回", -- 417
		{132, 106, 172, 255}, -- 417
		{74, 55, 100, 255}, -- 417
		Color(234, 226, 250, 255), -- 417
		function() -- 417
			self.screen = self.settingsBack -- 417
			self:refresh() -- 417
		end, -- 417
		self.screenLayer, -- 417
		24 -- 417
	) -- 417
end -- 405
function GameUI.prototype.renderVolumeRow(self, y, label, value, onChange) -- 420
	local d = DrawNode() -- 421
	d:drawPolygon( -- 422
		rectVerts(0, y, 360, 16), -- 422
		Color(22, 17, 32, 255), -- 422
		1, -- 422
		C_GOLD_DARK -- 422
	) -- 422
	local bar = 360 * value -- 423
	if bar > 2 then -- 423
		d:drawPolygon( -- 424
			rectVerts(-180 + bar / 2, y, bar, 16), -- 424
			C_GOLD, -- 424
			0 -- 424
		) -- 424
	end -- 424
	d:addTo(self.screenLayer) -- 425
	makeLabel( -- 427
		self.screenLayer, -- 427
		((label .. "  ") .. tostring(math.floor(value * 100 + 0.5))) .. "%", -- 427
		0, -- 427
		y + 52, -- 427
		24, -- 427
		C_TEXT -- 427
	) -- 427
	self:makeButton( -- 428
		{x = -250, y = y, w = 64, h = 56}, -- 428
		"−", -- 428
		{150, 124, 190, 255}, -- 428
		{86, 66, 112, 255}, -- 428
		Color(236, 228, 252, 255), -- 428
		function() return onChange(-0.1) end, -- 428
		self.screenLayer, -- 428
		28 -- 428
	) -- 428
	self:makeButton( -- 429
		{x = 250, y = y, w = 64, h = 56}, -- 429
		"+", -- 429
		{150, 124, 190, 255}, -- 429
		{86, 66, 112, 255}, -- 429
		Color(236, 228, 252, 255), -- 429
		function() return onChange(0.1) end, -- 429
		self.screenLayer, -- 429
		28 -- 429
	) -- 429
end -- 420
function GameUI.prototype.renderLevels(self) -- 432
	local maxLevel = GameDataManager.MAX_LEVEL -- 433
	local unlocked = self.mgr.state.highestLevel -- 434
	if unlocked < 1 then -- 434
		unlocked = 1 -- 435
	end -- 435
	if unlocked > maxLevel then -- 435
		unlocked = maxLevel -- 436
	end -- 436
	local d = DrawNode() -- 438
	drawGrad( -- 439
		d, -- 439
		0, -- 439
		0, -- 439
		660, -- 439
		960, -- 439
		{50, 38, 68, 255}, -- 439
		{22, 17, 32, 255} -- 439
	) -- 439
	drawBand( -- 440
		d, -- 440
		0, -- 440
		0, -- 440
		660, -- 440
		960, -- 440
		3, -- 440
		C_GOLD_DARK -- 440
	) -- 440
	drawBand( -- 441
		d, -- 441
		0, -- 441
		0, -- 441
		660, -- 441
		960, -- 441
		1, -- 441
		C_GOLD -- 441
	) -- 441
	drawCorners( -- 442
		d, -- 442
		0, -- 442
		0, -- 442
		660, -- 442
		960, -- 442
		14, -- 442
		8, -- 442
		C_GOLD_BRIGHT -- 442
	) -- 442
	local cols = {-200, 0, 200} -- 444
	local rows = { -- 445
		330, -- 445
		150, -- 445
		-30, -- 445
		-210, -- 445
		-390 -- 445
	} -- 445
	local px = {} -- 446
	local py = {} -- 447
	do -- 447
		local i = 0 -- 448
		while i < maxLevel do -- 448
			local row = math.floor(i / 3) -- 449
			local col = i % 3 -- 450
			local c = row % 2 == 0 and col or 2 - col -- 451
			px[#px + 1] = cols[c + 1] -- 452
			py[#py + 1] = rows[row + 1] -- 453
			i = i + 1 -- 448
		end -- 448
	end -- 448
	do -- 448
		local i = 0 -- 455
		while i + 1 < maxLevel do -- 455
			d:drawSegment( -- 456
				Vec2(px[i + 1], py[i + 1]), -- 456
				Vec2(px[i + 1 + 1], py[i + 1 + 1]), -- 456
				3, -- 456
				C_GOLD_DARK -- 456
			) -- 456
			i = i + 1 -- 455
		end -- 455
	end -- 455
	d:addTo(self.screenLayer) -- 458
	makeLabel( -- 460
		self.screenLayer, -- 460
		"选 择 关 卡", -- 460
		0, -- 460
		545, -- 460
		38, -- 460
		C_GOLD_TEXT -- 460
	) -- 460
	makeLabel( -- 461
		self.screenLayer, -- 461
		(("共 " .. tostring(maxLevel)) .. " 关 · 已解锁 ") .. tostring(unlocked), -- 461
		0, -- 461
		498, -- 461
		22, -- 461
		C_TEXT_DIM -- 461
	) -- 461
	do -- 461
		local i = 0 -- 463
		while i < maxLevel do -- 463
			local lv = i + 1 -- 464
			local open = lv <= unlocked -- 465
			local x = px[i + 1] -- 466
			local y = py[i + 1] -- 467
			local nd = DrawNode() -- 469
			if open then -- 469
				nd:drawDot( -- 471
					Vec2(x, y), -- 471
					40, -- 471
					C_GOLD -- 471
				) -- 471
				nd:drawDot( -- 472
					Vec2(x, y), -- 472
					34, -- 472
					C_BADGE -- 472
				) -- 472
			else -- 472
				nd:drawDot( -- 474
					Vec2(x, y), -- 474
					40, -- 474
					Color(58, 48, 74, 255) -- 474
				) -- 474
				nd:drawDot( -- 475
					Vec2(x, y), -- 475
					34, -- 475
					Color(26, 20, 34, 255) -- 475
				) -- 475
			end -- 475
			nd:addTo(self.screenLayer) -- 477
			makeLabel( -- 478
				self.screenLayer, -- 478
				"" .. tostring(lv), -- 478
				x, -- 478
				y, -- 478
				open and 26 or 22, -- 478
				open and C_GOLD_TEXT or Color(104, 94, 120, 255) -- 478
			) -- 478
			if open then -- 478
				local hit = Node() -- 481
				hit.position = Vec2(x, y) -- 482
				hit.size = Size(84, 84) -- 483
				hit.anchor = Vec2(0.5, 0.5) -- 484
				hit.touchEnabled = true -- 485
				hit:onTapped(function() return self:startLevelAt(lv) end) -- 486
				hit:addTo(self.screenLayer) -- 487
			end -- 487
			i = i + 1 -- 463
		end -- 463
	end -- 463
	self:makeButton( -- 491
		{x = -140, y = -560, w = 220, h = 62}, -- 491
		"养成", -- 491
		{132, 106, 172, 255}, -- 491
		{74, 55, 100, 255}, -- 491
		Color(234, 226, 250, 255), -- 491
		function() -- 491
			self.metaMessage = "" -- 491
			self.screen = "meta" -- 491
			self:refresh() -- 491
		end, -- 491
		self.screenLayer, -- 491
		24 -- 491
	) -- 491
	self:makeButton( -- 492
		{x = 140, y = -560, w = 220, h = 62}, -- 492
		"返回", -- 492
		{132, 106, 172, 255}, -- 492
		{74, 55, 100, 255}, -- 492
		Color(234, 226, 250, 255), -- 492
		function() -- 492
			self.screen = "menu" -- 492
			self:refresh() -- 492
		end, -- 492
		self.screenLayer, -- 492
		24 -- 492
	) -- 492
end -- 432
function GameUI.prototype.startLevelAt(self, level) -- 496
	self.mgr:startLevel(level) -- 497
	self.rewardsApplied = false -- 498
	self.lastReward = nil -- 499
	self.selectedCardId = nil -- 500
	self.metaOpen = false -- 501
	self.metaMessage = "" -- 502
	self.screen = "game" -- 503
	self:refresh() -- 504
end -- 496
function GameUI.prototype.changeBgmVolume(self, delta) -- 507
	local v = self.bgmVolume + delta -- 508
	if v < 0 then -- 508
		v = 0 -- 509
	end -- 509
	if v > 1 then -- 509
		v = 1 -- 510
	end -- 510
	self.bgmVolume = v -- 511
	if self.bgmSource then -- 511
		self.bgmSource.volume = v -- 512
	end -- 512
	self.save.bgmVolume = v -- 513
	self.save:save() -- 514
	self:refresh() -- 515
end -- 507
function GameUI.prototype.changeSfxVolume(self, delta) -- 518
	local v = self.sfxVolume + delta -- 519
	if v < 0 then -- 519
		v = 0 -- 520
	end -- 520
	if v > 1 then -- 520
		v = 1 -- 521
	end -- 521
	self.sfxVolume = v -- 522
	self.save.sfxVolume = v -- 523
	self.save:save() -- 524
	self:refresh() -- 525
end -- 518
function GameUI.prototype.syncProgress(self) -- 529
	local st = self.mgr.state.status -- 530
	if st == "won" or st == "complete" then -- 530
		local next = self.mgr.state.level + 1 -- 532
		if next > GameDataManager.MAX_LEVEL then -- 532
			next = GameDataManager.MAX_LEVEL -- 533
		end -- 533
		self.mgr:unlockLevel(next) -- 534
	end -- 534
	local hl = self.mgr.state.highestLevel -- 536
	if hl > self.save.highestLevel then -- 536
		self.save.highestLevel = hl -- 538
		self.save:save() -- 539
	end -- 539
end -- 529
function GameUI.prototype.renderHud(self) -- 543
	self.hudLayer:removeAllChildren() -- 544
	local s = self.mgr.state -- 545
	makeLabel( -- 546
		self.hudLayer, -- 546
		(("生命 " .. tostring(s.hp)) .. "/") .. tostring(s.maxHp), -- 546
		-280, -- 546
		585, -- 546
		24, -- 546
		s.hp <= 1 and C_DANGER or C_TEXT -- 547
	) -- 547
	makeLabel( -- 548
		self.hudLayer, -- 548
		("第 " .. tostring(s.level)) .. " 关", -- 548
		0, -- 548
		585, -- 548
		26, -- 548
		C_TEXT -- 548
	) -- 548
	makeLabel( -- 549
		self.hudLayer, -- 549
		((("需消除 " .. tostring(s.eliminatedCount)) .. "/") .. tostring(s.targetCount)) .. " 张", -- 549
		0, -- 549
		545, -- 549
		18, -- 549
		C_TEXT_DIM -- 549
	) -- 549
	makeLabel( -- 550
		self.hudLayer, -- 550
		"回合 " .. tostring(s.turn), -- 550
		120, -- 550
		585, -- 550
		22, -- 550
		C_TEXT -- 550
	) -- 550
	local hint = self.hintText ~= "" and self.hintText or "拖硬币到卡牌 · 点硬币切换正负 · 结束回合自动消除" -- 552
	makeLabel( -- 553
		self.hudLayer, -- 553
		hint, -- 553
		0, -- 553
		498, -- 553
		22, -- 553
		self.hintText ~= "" and C_DANGER or C_GOLD_TEXT -- 553
	) -- 553
end -- 543
function GameUI.prototype.renderCards(self) -- 556
	self.cardLayer:removeAllChildren() -- 557
	self.cardRects = {} -- 558
	local cards = self.mgr.state.cards -- 559
	local gridW = CARD_COLS * CARD_W + (CARD_COLS - 1) * CARD_GAP_X -- 560
	local gridH = CARD_ROWS * CARD_H + (CARD_ROWS - 1) * CARD_GAP_Y -- 561
	local startX = -gridW / 2 + CARD_W / 2 -- 562
	local startY = 250 + gridH / 2 - CARD_H / 2 -- 563
	local maxCards = CARD_COLS * CARD_ROWS -- 564
	do -- 564
		local i = 0 -- 566
		while i < #cards and i < maxCards do -- 566
			local card = cards[i + 1] -- 567
			local col = i % CARD_COLS -- 568
			local row = math.floor(i / CARD_COLS) -- 569
			local x = startX + col * (CARD_W + CARD_GAP_X) -- 570
			local y = startY - row * (CARD_H + CARD_GAP_Y) -- 571
			self:buildCard(card, x, y) -- 572
			i = i + 1 -- 566
		end -- 566
	end -- 566
end -- 556
function GameUI.prototype.buildCard(self, card, x, y) -- 577
	local ____self_cardRects_0 = self.cardRects -- 577
	____self_cardRects_0[#____self_cardRects_0 + 1] = { -- 578
		id = card.id, -- 578
		x = x, -- 578
		y = y, -- 578
		w = CARD_W, -- 578
		h = CARD_H -- 578
	} -- 578
	local hit = Node() -- 581
	hit.position = Vec2(x, y) -- 582
	hit.size = Size(CARD_W, CARD_H) -- 583
	hit.anchor = Vec2(0.5, 0.5) -- 584
	hit.touchEnabled = true -- 585
	hit:onTapped(function() -- 586
		self.selectedCardId = card.id -- 587
		self.hintText = "" -- 588
		self:refresh() -- 589
	end) -- 586
	hit:addTo(self.cardLayer) -- 591
	local node = Node() -- 593
	node.position = Vec2(x, y) -- 594
	local selected = card.id == self.selectedCardId -- 596
	local border = selected and C_GOLD_BRIGHT or C_GOLD -- 597
	local borderW = selected and 4 or 3 -- 598
	local d = DrawNode() -- 600
	if selected then -- 600
		drawGrad( -- 603
			d, -- 603
			0, -- 603
			0, -- 603
			CARD_W, -- 603
			CARD_H, -- 603
			{90, 70, 122, 255}, -- 603
			{46, 35, 64, 255} -- 603
		) -- 603
	else -- 603
		drawGrad( -- 605
			d, -- 605
			0, -- 605
			0, -- 605
			CARD_W, -- 605
			CARD_H, -- 605
			{58, 44, 78, 255}, -- 605
			{28, 21, 40, 255} -- 605
		) -- 605
	end -- 605
	drawBand( -- 607
		d, -- 607
		0, -- 607
		0, -- 607
		CARD_W, -- 607
		CARD_H, -- 607
		borderW, -- 607
		border -- 607
	) -- 607
	drawBand( -- 608
		d, -- 608
		0, -- 608
		0, -- 608
		CARD_W - 12, -- 608
		CARD_H - 12, -- 608
		1, -- 608
		selected and C_GOLD_BRIGHT or C_GOLD_DARK -- 608
	) -- 608
	drawCorners( -- 609
		d, -- 609
		0, -- 609
		0, -- 609
		CARD_W, -- 609
		CARD_H, -- 609
		14, -- 609
		7, -- 609
		C_GOLD_BRIGHT -- 609
	) -- 609
	d:drawDot( -- 611
		Vec2(74, 104), -- 611
		25, -- 611
		C_GOLD -- 611
	) -- 611
	d:drawDot( -- 612
		Vec2(74, 104), -- 612
		21, -- 612
		C_BADGE -- 612
	) -- 612
	d:addTo(node) -- 613
	makeLabel( -- 616
		node, -- 616
		"" .. tostring(card.target), -- 616
		0, -- 616
		52, -- 616
		72, -- 616
		C_TEXT -- 616
	) -- 616
	makeLabel( -- 617
		node, -- 617
		"目标", -- 617
		0, -- 617
		112, -- 617
		16, -- 617
		C_TEXT_DIM -- 617
	) -- 617
	makeLabel( -- 620
		node, -- 620
		"" .. tostring(card.countdown), -- 620
		74, -- 620
		104, -- 620
		22, -- 620
		card.countdown <= 1 and C_DANGER or C_TEXT -- 621
	) -- 621
	makeLabel( -- 622
		node, -- 622
		"回合", -- 622
		74, -- 622
		132, -- 622
		11, -- 622
		C_TEXT_DIM -- 622
	) -- 622
	local bx = -92 -- 625
	local by = 112 -- 626
	if card.target ~= card.originalTarget then -- 626
		d:drawDot( -- 628
			Vec2(bx, by), -- 628
			12, -- 628
			coinColor(CoinType.Discount) -- 628
		) -- 628
		makeLabel( -- 629
			node, -- 629
			"折", -- 629
			bx, -- 629
			by, -- 629
			12, -- 629
			C_TEXT -- 629
		) -- 629
		bx = bx + 26 -- 630
	end -- 630
	if card.frozen then -- 630
		d:drawDot( -- 633
			Vec2(bx, by), -- 633
			12, -- 633
			coinColor(CoinType.Freeze) -- 633
		) -- 633
		makeLabel( -- 634
			node, -- 634
			"冻", -- 634
			bx, -- 634
			by, -- 634
			12, -- 634
			C_TEXT -- 634
		) -- 634
		bx = bx + 26 -- 635
	end -- 635
	if card.healAmount > 0 then -- 635
		d:drawDot( -- 638
			Vec2(bx, by), -- 638
			12, -- 638
			coinColor(CoinType.Heal) -- 638
		) -- 638
		makeLabel( -- 639
			node, -- 639
			"回", -- 639
			bx, -- 639
			by, -- 639
			12, -- 639
			C_TEXT -- 639
		) -- 639
		bx = bx + 26 -- 640
	end -- 640
	if card.copyArmed then -- 640
		d:drawDot( -- 643
			Vec2(bx, by), -- 643
			12, -- 643
			coinColor(CoinType.Copy) -- 643
		) -- 643
		makeLabel( -- 644
			node, -- 644
			"复", -- 644
			bx, -- 644
			by, -- 644
			12, -- 644
			C_TEXT -- 644
		) -- 644
		bx = bx + 26 -- 645
	end -- 645
	local eq = self:equationText(card) -- 649
	makeLabel( -- 650
		node, -- 650
		eq, -- 650
		0, -- 650
		-22, -- 650
		20, -- 650
		eq == "算式：0" and C_TEXT_DIM or C_TEXT -- 650
	) -- 650
	node:addTo(self.cardLayer) -- 652
	local n = #card.coins -- 655
	local chipGap = n > 1 and math.min(46, (CARD_W - 44) / (n - 1)) or 0 -- 656
	do -- 656
		local i = 0 -- 657
		while i < n do -- 657
			local pc = card.coins[i + 1] -- 658
			local idx = i -- 659
			local chipX = (i - (n - 1) / 2) * chipGap -- 660
			local chipY = -100 -- 661
			d:drawDot( -- 662
				Vec2(chipX, chipY), -- 662
				18, -- 662
				coinColor(pc.type) -- 662
			) -- 662
			d:drawDot( -- 663
				Vec2(chipX, chipY), -- 663
				13, -- 663
				C_BADGE -- 663
			) -- 663
			makeLabel( -- 664
				node, -- 664
				self:opSymbol(pc.op) .. tostring(pc.value), -- 664
				chipX, -- 664
				chipY, -- 664
				17, -- 664
				C_TEXT -- 664
			) -- 664
			local chip = Node() -- 665
			chip.position = Vec2(x + chipX, y + chipY) -- 666
			chip.size = Size(48, 48) -- 667
			chip.anchor = Vec2(0.5, 0.5) -- 668
			chip.touchEnabled = true -- 669
			chip.swallowTouches = true -- 670
			chip:onTapped(function() -- 671
				self.mgr:togglePlacedCoin(card.id, idx) -- 672
				self:refresh() -- 673
			end) -- 671
			chip:onTapBegan(function(t) return self:beginDrag( -- 675
				"placed", -- 675
				card.id, -- 675
				idx, -- 675
				pc.type, -- 675
				pc.value, -- 675
				t -- 675
			) end) -- 675
			chip:onTapMoved(function(t) return self:moveDrag(t) end) -- 676
			chip:onTapEnded(function(t) return self:endDrag(t) end) -- 677
			chip:addTo(self.cardLayer) -- 678
			i = i + 1 -- 657
		end -- 657
	end -- 657
end -- 577
function GameUI.prototype.equationText(self, card) -- 683
	if #card.coins == 0 then -- 683
		return "算式：0" -- 684
	end -- 684
	local s = "算式：0" -- 685
	do -- 685
		local i = 0 -- 686
		while i < #card.coins do -- 686
			local c = card.coins[i + 1] -- 687
			if c.type == CoinType.Multiply then -- 687
				s = s .. (c.op == "div" and " ÷ " .. tostring(c.value) or " × " .. tostring(c.value)) -- 689
			else -- 689
				s = s .. (c.op == "sub" and " − " .. tostring(c.value) or " + " .. tostring(c.value)) -- 691
			end -- 691
			i = i + 1 -- 686
		end -- 686
	end -- 686
	return (s .. " = ") .. tostring(self.mgr:evaluateCard(card)) -- 694
end -- 683
function GameUI.prototype.renderCoins(self) -- 697
	self.coinLayer:removeAllChildren() -- 698
	makeLabel( -- 699
		self.coinLayer, -- 699
		"硬币背包", -- 699
		0, -- 699
		-168, -- 699
		20, -- 699
		C_TEXT_DIM -- 699
	) -- 699
	local inv = self.mgr.state.inventory -- 701
	local cols = 3 -- 702
	local groupW = 216 -- 703
	local groupH = 128 -- 704
	local rowCenters = {-262, -396, -530} -- 705
	local colCenters = {-220, 0, 220} -- 706
	local idx = 0 -- 708
	do -- 708
		local t = 0 -- 709
		while t < #COIN_TYPE_ORDER do -- 709
			do -- 709
				local ____type = COIN_TYPE_ORDER[t + 1] -- 710
				local stacks = {} -- 711
				local total = 0 -- 712
				do -- 712
					local i = 0 -- 713
					while i < #inv do -- 713
						if inv[i + 1].type == ____type then -- 713
							stacks[#stacks + 1] = inv[i + 1] -- 715
							total = total + inv[i + 1].count -- 716
						end -- 716
						i = i + 1 -- 713
					end -- 713
				end -- 713
				if #stacks == 0 then -- 713
					goto __continue107 -- 719
				end -- 719
				local col = idx % cols -- 721
				local row = math.floor(idx / cols) -- 722
				if row >= 3 then -- 722
					break -- 723
				end -- 723
				local gx = colCenters[col + 1] -- 724
				local gy = rowCenters[row + 1] -- 725
				self:buildCoinGroup( -- 726
					____type, -- 726
					stacks, -- 726
					total, -- 726
					gx, -- 726
					gy, -- 726
					groupW, -- 726
					groupH -- 726
				) -- 726
				idx = idx + 1 -- 727
			end -- 727
			::__continue107:: -- 727
			t = t + 1 -- 709
		end -- 709
	end -- 709
	makeLabel( -- 730
		self.coinLayer, -- 730
		((("最高关卡 " .. tostring(self.mgr.state.highestLevel)) .. " · 货币 ") .. tostring(self.mgr.state.currency)) .. " · 单次奖励上限 1000", -- 731
		0, -- 732
		-600, -- 732
		15, -- 732
		C_GOLD_TEXT -- 732
	) -- 732
end -- 697
function GameUI.prototype.buildCoinGroup(self, ____type, stacks, total, gx, gy, w, h) -- 736
	local node = Node() -- 745
	node.position = Vec2(gx, gy) -- 746
	local d = DrawNode() -- 748
	drawGrad( -- 750
		d, -- 750
		0, -- 750
		0, -- 750
		w, -- 750
		h, -- 750
		{50, 38, 68, 255}, -- 750
		{24, 18, 34, 255} -- 750
	) -- 750
	drawBand( -- 751
		d, -- 751
		0, -- 751
		0, -- 751
		w, -- 751
		h, -- 751
		2, -- 751
		C_GOLD_DARK -- 751
	) -- 751
	drawCorners( -- 752
		d, -- 752
		0, -- 752
		0, -- 752
		w, -- 752
		h, -- 752
		10, -- 752
		5, -- 752
		C_GOLD -- 752
	) -- 752
	d:addTo(node) -- 753
	node:addTo(self.coinLayer) -- 754
	makeLabel( -- 756
		node, -- 756
		(coinTypeName(____type) .. " ×") .. tostring(total), -- 756
		-100, -- 756
		46, -- 756
		20, -- 756
		C_GOLD_TEXT, -- 756
		Vec2(0, 0.5) -- 756
	) -- 756
	local n = #stacks -- 758
	local chipRadius = 26 -- 759
	local chipGap = n > 1 and math.min(44, (w - 2 * chipRadius) / (n - 1)) or 0 -- 760
	do -- 760
		local i = 0 -- 761
		while i < n do -- 761
			local stack = stacks[i + 1] -- 764
			local chipX = (i - (n - 1) / 2) * chipGap -- 765
			local chipY = -12 -- 766
			local cc = coinColor(____type) -- 768
			d:drawDot( -- 769
				Vec2(chipX, chipY), -- 769
				chipRadius, -- 769
				cc -- 769
			) -- 769
			d:drawDot( -- 770
				Vec2(chipX, chipY), -- 770
				chipRadius - 3, -- 770
				C_GOLD_DARK -- 770
			) -- 770
			d:drawDot( -- 771
				Vec2(chipX, chipY), -- 771
				chipRadius - 6, -- 771
				C_BADGE -- 771
			) -- 771
			d:drawDot( -- 772
				Vec2(chipX - chipRadius * 0.3, chipY + chipRadius * 0.34), -- 772
				chipRadius * 0.26, -- 772
				Color(238, 226, 198, 26) -- 772
			) -- 772
			makeLabel( -- 773
				node, -- 773
				coinChipText(____type, stack.value), -- 773
				chipX, -- 773
				chipY + 6, -- 773
				20, -- 773
				C_TEXT -- 773
			) -- 773
			if stack.count > 1 then -- 773
				makeLabel( -- 775
					node, -- 775
					"×" .. tostring(stack.count), -- 775
					chipX, -- 775
					chipY - 36, -- 775
					13, -- 775
					C_TEXT_FAINT -- 775
				) -- 775
			end -- 775
			local chip = Node() -- 778
			chip.position = Vec2(gx + chipX, gy + chipY) -- 779
			chip.size = Size(68, 68) -- 780
			chip.anchor = Vec2(0.5, 0.5) -- 781
			chip.touchEnabled = true -- 782
			chip.swallowTouches = true -- 783
			chip:onTapped(function() -- 784
				self:log("FLIP " .. tostring(stack.value)) -- 785
				self.mgr:flipCoinSign(____type, stack.value) -- 786
				self.hintText = "" -- 787
				self:refresh() -- 788
			end) -- 784
			chip:onTapBegan(function(t) return self:beginDrag( -- 790
				"inventory", -- 790
				0, -- 790
				0, -- 790
				____type, -- 790
				stack.value, -- 790
				t -- 790
			) end) -- 790
			chip:onTapMoved(function(t) return self:moveDrag(t) end) -- 791
			chip:onTapEnded(function(t) return self:endDrag(t) end) -- 792
			chip:addTo(self.coinLayer) -- 793
			i = i + 1 -- 761
		end -- 761
	end -- 761
end -- 736
function GameUI.prototype.updateOverlay(self) -- 799
	local s = self.mgr.state -- 800
	self.overlayLayer:removeAllChildren() -- 801
	if s.status == "playing" then -- 801
		self.metaOpen = false -- 804
		self.metaMessage = "" -- 805
		return -- 806
	end -- 806
	local dim = DrawNode() -- 810
	dim:drawPolygon( -- 811
		rectVerts(0, 0, ____exports.DESIGN_W, ____exports.DESIGN_H), -- 811
		Color(8, 6, 5, 210), -- 811
		0 -- 811
	) -- 811
	dim:addTo(self.overlayLayer) -- 812
	if self.metaOpen then -- 812
		self:renderMetaPanel(self.overlayLayer) -- 815
		return -- 816
	end -- 816
	local panel = DrawNode() -- 820
	panel:drawPolygon( -- 821
		rectVerts(0, 0, 520, 430), -- 821
		C_PANEL, -- 821
		4, -- 821
		C_PANEL_BORDER -- 821
	) -- 821
	panel:addTo(self.overlayLayer) -- 822
	if s.status == "lost" then -- 822
		makeLabel( -- 825
			self.overlayLayer, -- 825
			"游戏失败", -- 825
			0, -- 825
			120, -- 825
			34, -- 825
			C_DANGER -- 825
		) -- 825
		makeLabel( -- 826
			self.overlayLayer, -- 826
			"生命归零，未能完成本关", -- 826
			0, -- 826
			60, -- 826
			18, -- 826
			C_TEXT_DIM -- 826
		) -- 826
		makeLabel( -- 827
			self.overlayLayer, -- 827
			((((("第 " .. tostring(s.level)) .. " 关 · 已消除 ") .. tostring(s.eliminatedCount)) .. "/") .. tostring(s.targetCount)) .. " 张", -- 827
			0, -- 827
			22, -- 827
			16, -- 827
			C_TEXT_DIM -- 827
		) -- 827
		self:addOverlayButton( -- 828
			"重试", -- 828
			0, -- 828
			-120, -- 828
			220, -- 828
			50, -- 828
			C_ENDTURN, -- 828
			"retry" -- 828
		) -- 828
	elseif s.status == "complete" then -- 828
		if not self.rewardsApplied then -- 828
			self.lastReward = self.mgr:applyWinRewards() -- 830
			self.rewardsApplied = true -- 830
		end -- 830
		makeLabel( -- 831
			self.overlayLayer, -- 831
			"全部通关！", -- 831
			0, -- 831
			120, -- 831
			34, -- 831
			C_GOLD_TEXT -- 831
		) -- 831
		makeLabel( -- 832
			self.overlayLayer, -- 832
			("你完成了全部 " .. tostring(GameDataManager.MAX_LEVEL)) .. " 关", -- 832
			0, -- 832
			60, -- 832
			18, -- 832
			C_TEXT -- 832
		) -- 832
		makeLabel( -- 833
			self.overlayLayer, -- 833
			"总货币 " .. tostring(s.currency), -- 833
			0, -- 833
			22, -- 833
			16, -- 833
			C_TEXT_DIM -- 833
		) -- 833
		self:addOverlayButton( -- 834
			"重新开始", -- 834
			0, -- 834
			-90, -- 834
			220, -- 834
			44, -- 834
			C_CONFIRM, -- 834
			"restart" -- 834
		) -- 834
		self:addOverlayButton( -- 835
			"选择关卡", -- 835
			0, -- 835
			-150, -- 835
			220, -- 835
			44, -- 835
			Color(104, 82, 148, 255), -- 835
			"toLevels" -- 835
		) -- 835
	else -- 835
		if not self.rewardsApplied then -- 835
			self.lastReward = self.mgr:applyWinRewards() -- 837
			self.rewardsApplied = true -- 837
		end -- 837
		makeLabel( -- 838
			self.overlayLayer, -- 838
			"关卡完成！", -- 838
			0, -- 838
			120, -- 838
			34, -- 838
			C_GOLD_TEXT -- 838
		) -- 838
		makeLabel( -- 839
			self.overlayLayer, -- 839
			(((((("已消除 " .. tostring(s.eliminatedCount)) .. "/") .. tostring(s.targetCount)) .. " 张 · 生命 ") .. tostring(s.hp)) .. "/") .. tostring(s.maxHp), -- 839
			0, -- 839
			60, -- 839
			18, -- 839
			C_TEXT -- 839
		) -- 839
		local rewardText = "货币 +0 · 新硬币 +1" -- 840
		if self.lastReward then -- 840
			rewardText = (((("货币 +" .. tostring(self.lastReward.currency)) .. " · 新硬币：") .. coinTypeName(self.lastReward.coinType)) .. " ") .. tostring(self.lastReward.coinValue) -- 842
		end -- 842
		makeLabel( -- 844
			self.overlayLayer, -- 844
			rewardText, -- 844
			0, -- 844
			22, -- 844
			16, -- 844
			C_TEXT_DIM -- 844
		) -- 844
		self:addOverlayButton( -- 845
			"下一关", -- 845
			0, -- 845
			-80, -- 845
			220, -- 845
			44, -- 845
			C_CONFIRM, -- 845
			"next" -- 845
		) -- 845
		self:addOverlayButton( -- 846
			"选择关卡", -- 846
			0, -- 846
			-135, -- 846
			220, -- 846
			44, -- 846
			Color(104, 82, 148, 255), -- 846
			"toLevels" -- 846
		) -- 846
		self:addOverlayButton( -- 847
			"养成", -- 847
			0, -- 847
			-190, -- 847
			220, -- 847
			44, -- 847
			Color(104, 82, 148, 255), -- 847
			"meta" -- 847
		) -- 847
	end -- 847
end -- 799
function GameUI.prototype.renderMetaPanel(self, parent) -- 851
	local W = 660 -- 852
	local H = 1010 -- 853
	local panel = DrawNode() -- 854
	panel:drawPolygon( -- 855
		rectVerts(0, 0, W, H), -- 855
		C_PANEL, -- 855
		4, -- 855
		C_PANEL_BORDER -- 855
	) -- 855
	drawBand( -- 856
		panel, -- 856
		0, -- 856
		0, -- 856
		W, -- 856
		H, -- 856
		3, -- 856
		C_GOLD_DARK -- 856
	) -- 856
	drawBand( -- 857
		panel, -- 857
		0, -- 857
		0, -- 857
		W - 16, -- 857
		H - 16, -- 857
		1, -- 857
		C_GOLD -- 857
	) -- 857
	drawCorners( -- 858
		panel, -- 858
		0, -- 858
		0, -- 858
		W, -- 858
		H, -- 858
		20, -- 858
		11, -- 858
		C_GOLD_BRIGHT -- 858
	) -- 858
	panel:drawSegment( -- 859
		Vec2(-286, 292), -- 859
		Vec2(286, 292), -- 859
		1, -- 859
		C_GOLD_DARK -- 859
	) -- 859
	panel:drawSegment( -- 860
		Vec2(-286, 96), -- 860
		Vec2(286, 96), -- 860
		1, -- 860
		C_GOLD_DARK -- 860
	) -- 860
	panel:addTo(parent) -- 861
	local s = self.mgr.state -- 863
	makeLabel( -- 864
		parent, -- 864
		"局外养成", -- 864
		0, -- 864
		436, -- 864
		36, -- 864
		C_GOLD_TEXT -- 864
	) -- 864
	makeLabel( -- 865
		parent, -- 865
		(((("货币 " .. tostring(s.currency)) .. " · 血量上限 ") .. tostring(s.maxHp)) .. " · 删除次数 ") .. tostring(self.mgr.deleteCredits), -- 865
		0, -- 865
		384, -- 865
		17, -- 865
		C_TEXT -- 865
	) -- 865
	makeLabel( -- 866
		parent, -- 866
		"扫荡奖励按最高关卡计，货币上限 1000", -- 866
		0, -- 866
		354, -- 866
		13, -- 866
		C_TEXT_DIM -- 866
	) -- 866
	if self.metaMessage ~= "" then -- 866
		makeLabel( -- 868
			parent, -- 868
			self.metaMessage, -- 868
			0, -- 868
			320, -- 868
			16, -- 868
			C_GOLD_TEXT -- 868
		) -- 868
	end -- 868
	makeLabel( -- 871
		parent, -- 871
		"增加基础硬币（每枚 100 货币）", -- 871
		0, -- 871
		258, -- 871
		21, -- 871
		C_TEXT -- 871
	) -- 871
	local buyValues = { -- 872
		1, -- 872
		2, -- 872
		3, -- 872
		5, -- 872
		10, -- 872
		50 -- 872
	} -- 872
	do -- 872
		local i = 0 -- 873
		while i < #buyValues do -- 873
			local col = i % 3 -- 874
			local row = math.floor(i / 3) -- 875
			local bx = -212 + col * 212 -- 876
			local by = 202 - row * 74 -- 877
			self:addOverlayButton( -- 878
				"＋" .. tostring(buyValues[i + 1]), -- 878
				bx, -- 878
				by, -- 878
				186, -- 878
				52, -- 878
				C_ENDTURN, -- 878
				"buy" .. tostring(i), -- 878
				parent, -- 878
				22 -- 878
			) -- 878
			i = i + 1 -- 873
		end -- 873
	end -- 873
	self:addOverlayButton( -- 881
		"合成硬币", -- 881
		0, -- 881
		50, -- 881
		340, -- 881
		52, -- 881
		Color(104, 82, 148, 255), -- 881
		"synthesize", -- 881
		parent, -- 881
		21 -- 881
	) -- 881
	self:addOverlayButton( -- 882
		"强化血量（100）", -- 882
		0, -- 882
		-24, -- 882
		340, -- 882
		52, -- 882
		C_ENDTURN, -- 882
		"upgradeHp", -- 882
		parent, -- 882
		21 -- 882
	) -- 882
	self:addOverlayButton( -- 883
		"强化删除次数（80）", -- 883
		0, -- 883
		-98, -- 883
		340, -- 883
		52, -- 883
		C_ENDTURN, -- 883
		"upgradeDelete", -- 883
		parent, -- 883
		21 -- 883
	) -- 883
	self:addOverlayButton( -- 884
		"删除一枚硬币", -- 884
		0, -- 884
		-172, -- 884
		340, -- 884
		52, -- 884
		Color(158, 70, 104, 255), -- 884
		"delete", -- 884
		parent, -- 884
		21 -- 884
	) -- 884
	self:addOverlayButton( -- 885
		"扫荡", -- 885
		0, -- 885
		-246, -- 885
		340, -- 885
		52, -- 885
		C_CONFIRM, -- 885
		"sweep", -- 885
		parent, -- 885
		21 -- 885
	) -- 885
	self:addOverlayButton( -- 887
		"返回", -- 887
		0, -- 887
		-388, -- 887
		320, -- 887
		58, -- 887
		Color(84, 70, 118, 255), -- 887
		"back", -- 887
		parent, -- 887
		23 -- 887
	) -- 887
end -- 851
function GameUI.prototype.addOverlayButton(self, text, cx, cy, w, h, color, action, parent, fontSize) -- 890
	local node = Node() -- 891
	node.position = Vec2(cx, cy) -- 892
	node.size = Size(w, h) -- 893
	node.anchor = Vec2(0.5, 0.5) -- 894
	local d = DrawNode() -- 895
	d:drawPolygon( -- 896
		rectVerts(w / 2, h / 2, w, h), -- 896
		color, -- 896
		2, -- 896
		C_CONFIRM_BORDER -- 896
	) -- 896
	d:addTo(node) -- 897
	makeLabel( -- 898
		node, -- 898
		text, -- 898
		w / 2, -- 898
		h / 2, -- 898
		fontSize and fontSize or 20, -- 898
		C_TEXT -- 898
	) -- 898
	node.touchEnabled = true -- 899
	node:onTapped(function() return self:handleOverlayAction(action) end) -- 900
	node:addTo(parent and parent or self.overlayLayer) -- 901
end -- 890
function GameUI.prototype.handleOverlayAction(self, action) -- 904
	if action == "toLevels" then -- 904
		self.metaOpen = false -- 906
		self.metaMessage = "" -- 907
		self.screen = "levels" -- 908
		self:refresh() -- 909
		return -- 910
	end -- 910
	if action == "retry" then -- 910
		self.mgr:startLevel(self.mgr.state.level) -- 913
		self.rewardsApplied = false -- 914
		self.lastReward = nil -- 915
		self.selectedCardId = nil -- 916
		self.metaOpen = false -- 917
		self.metaMessage = "" -- 918
		self:refresh() -- 919
		return -- 920
	end -- 920
	if action == "next" then -- 920
		self.mgr:startLevel(self.mgr.state.level + 1) -- 923
		self.rewardsApplied = false -- 924
		self.lastReward = nil -- 925
		self.selectedCardId = nil -- 926
		self.metaOpen = false -- 927
		self.metaMessage = "" -- 928
		self:refresh() -- 929
		return -- 930
	end -- 930
	if action == "restart" then -- 930
		self.mgr:startLevel(1) -- 933
		self.rewardsApplied = false -- 934
		self.lastReward = nil -- 935
		self.selectedCardId = nil -- 936
		self.metaOpen = false -- 937
		self.metaMessage = "" -- 938
		self:refresh() -- 939
		return -- 940
	end -- 940
	if action == "meta" then -- 940
		self.metaOpen = true -- 943
		self.metaMessage = "" -- 944
		self:refresh() -- 945
		return -- 946
	end -- 946
	if action == "back" then -- 946
		self.metaOpen = false -- 949
		self.metaMessage = "" -- 950
		if self.screen == "meta" then -- 950
			self.screen = "levels" -- 951
		end -- 951
		self:refresh() -- 952
		return -- 953
	end -- 953
	if (string.find(action, "buy", nil, true) or 0) - 1 == 0 then -- 953
		local idx = __TS__Number(__TS__StringSubstring(action, 3)) -- 956
		local br = self.mgr:buyBaseCoin(idx) -- 957
		self.metaMessage = br.ok and "已增加基础硬币 " .. tostring(br.value) or br.reason -- 958
		self:refresh() -- 959
		return -- 960
	end -- 960
	if action == "synthesize" then -- 960
		local r = self.mgr:synthesizeOnce() -- 963
		self.metaMessage = r.ok and (((((("合成成功：" .. coinTypeName(r.type)) .. " ") .. tostring(r.valueA)) .. " + ") .. tostring(r.valueB)) .. " → ") .. tostring(r.resultValue) or "无可合成硬币（需同类型至少 2 枚）" -- 964
		self:refresh() -- 967
		return -- 968
	end -- 968
	if action == "upgradeHp" then -- 968
		local r = self.mgr:upgradeMaxHp() -- 971
		self.metaMessage = r.ok and "血量上限提升至 " .. tostring(r.newMaxHp) or r.reason -- 972
		self:refresh() -- 973
		return -- 974
	end -- 974
	if action == "upgradeDelete" then -- 974
		local r = self.mgr:upgradeDeleteCredits() -- 977
		self.metaMessage = r.ok and ("删除次数 +2（当前 " .. tostring(r.newCredits)) .. "）" or r.reason -- 978
		self:refresh() -- 979
		return -- 980
	end -- 980
	if action == "delete" then -- 980
		local r = self.mgr:deleteOnce() -- 983
		self.metaMessage = r.ok and (("已删除 " .. coinTypeName(r.type)) .. " ") .. tostring(r.value) or r.reason -- 984
		self:refresh() -- 985
		return -- 986
	end -- 986
	if action == "sweep" then -- 986
		local r = self.mgr:sweepLevel() -- 989
		self.metaMessage = r.ok and (((("扫荡获得货币 +" .. tostring(r.currency)) .. " · 硬币 ") .. coinTypeName(r.coinType)) .. " ") .. tostring(r.coinValue) or r.reason -- 990
		self:refresh() -- 991
		return -- 992
	end -- 992
end -- 904
function GameUI.prototype.makeButton(self, rect, text, top, bottom, textColor, onTap, parent, fontSize) -- 999
	local node = Node() -- 1009
	node.position = Vec2(rect.x, rect.y) -- 1010
	node.size = Size(rect.w, rect.h) -- 1011
	node.anchor = Vec2(0.5, 0.5) -- 1012
	local d = DrawNode() -- 1013
	drawGrad( -- 1014
		d, -- 1014
		rect.w / 2, -- 1014
		rect.h / 2, -- 1014
		rect.w, -- 1014
		rect.h, -- 1014
		top, -- 1014
		bottom -- 1014
	) -- 1014
	drawSheen( -- 1015
		d, -- 1015
		rect.w / 2, -- 1015
		rect.h / 2, -- 1015
		rect.w, -- 1015
		rect.h, -- 1015
		48 -- 1015
	) -- 1015
	drawBand( -- 1016
		d, -- 1016
		rect.w / 2, -- 1016
		rect.h / 2, -- 1016
		rect.w, -- 1016
		rect.h, -- 1016
		2, -- 1016
		C_GOLD_DARK -- 1016
	) -- 1016
	drawBand( -- 1017
		d, -- 1017
		rect.w / 2, -- 1017
		rect.h / 2, -- 1017
		rect.w - 8, -- 1017
		rect.h - 8, -- 1017
		1, -- 1017
		C_GOLD_BRIGHT -- 1017
	) -- 1017
	d:addTo(node) -- 1018
	makeLabel( -- 1019
		node, -- 1019
		text, -- 1019
		rect.w / 2, -- 1019
		rect.h / 2, -- 1019
		fontSize and fontSize or 20, -- 1019
		textColor -- 1019
	) -- 1019
	node.touchEnabled = true -- 1020
	node:onTapped(function() return onTap() end) -- 1021
	node:addTo(parent and parent or self.actionLayer) -- 1022
end -- 999
function GameUI.prototype.dragPoint(self, t, node) -- 1027
	local wl = t.worldLocation -- 1028
	if wl ~= nil then -- 1028
		return Vec2(wl.x, wl.y) -- 1029
	end -- 1029
	if node then -- 1029
		return node:convertToWorldSpace(t.location) -- 1030
	end -- 1030
	return Vec2(t.location.x, t.location.y) -- 1031
end -- 1027
function GameUI.prototype.beginDrag(self, kind, cardId, index, ____type, value, t) -- 1034
	if self.drag then -- 1034
		return -- 1043
	end -- 1043
	self.lastMoveLog = 0 -- 1044
	self.dragEndedEarly = false -- 1045
	self:log((((("BEGIN " .. kind) .. " val=") .. tostring(value)) .. " mouseDown=") .. tostring(Mouse.leftButtonPressed)) -- 1046
	self.drag = { -- 1047
		kind = kind, -- 1047
		cardId = cardId, -- 1047
		index = index, -- 1047
		type = ____type, -- 1047
		value = value -- 1047
	} -- 1047
	local wp = self:dragPoint(t) -- 1048
	self.dragStart = wp -- 1049
	self:makeGhost(____type, value, wp) -- 1050
	self.hintText = "把硬币放到某张卡牌上" -- 1052
	self:renderHud() -- 1053
end -- 1034
function GameUI.prototype.moveDrag(self, t) -- 1056
	if not self.drag then -- 1056
		return -- 1057
	end -- 1057
	local wp = self:dragPoint(t) -- 1058
	if self.dragGhost then -- 1058
		self.dragGhost.position = wp -- 1059
	end -- 1059
	local s = self.dragStart -- 1060
	if s then -- 1060
		local d = math.abs(wp.x - s.x) + math.abs(wp.y - s.y) -- 1062
		if d - self.lastMoveLog >= 40 then -- 1062
			self.lastMoveLog = d -- 1064
			self:log("MOVE d=" .. tostring(math.floor(d + 0.5))) -- 1065
		end -- 1065
	end -- 1065
end -- 1056
function GameUI.prototype.endDrag(self, t) -- 1070
	if not self.drag then -- 1070
		return -- 1071
	end -- 1071
	if Mouse.leftButtonPressed then -- 1071
		self.dragEndedEarly = true -- 1074
		self:log("END early (still pressed)") -- 1075
		return -- 1076
	end -- 1076
	self:finalizeDrag(self:dragPoint(t)) -- 1078
end -- 1070
function GameUI.prototype.tick(self) -- 1082
	if not self.drag or not self.dragEndedEarly then -- 1082
		return -- 1083
	end -- 1083
	if Mouse.leftButtonPressed then -- 1083
		local p = self:mouseDesignPoint() -- 1085
		if self.dragGhost then -- 1085
			self.dragGhost.position = p -- 1086
		end -- 1086
	else -- 1086
		self:finalizeDrag(self:mouseDesignPoint()) -- 1088
	end -- 1088
end -- 1082
function GameUI.prototype.mouseDesignPoint(self) -- 1093
	local mouse = Mouse.position -- 1094
	local visual = App.visualSize -- 1095
	local view = View.size -- 1096
	local z = self.viewZoom -- 1097
	local vx = mouse.x * view.width / visual.width - view.width / 2 -- 1098
	local vy = view.height / 2 - mouse.y * view.height / visual.height -- 1099
	return Vec2(vx / z, vy / z) -- 1100
end -- 1093
function GameUI.prototype.finalizeDrag(self, p) -- 1103
	local d = self.drag -- 1104
	self.drag = nil -- 1105
	self.dragEndedEarly = false -- 1106
	self:hideGhost() -- 1107
	local start = self.dragStart -- 1108
	self.dragStart = nil -- 1109
	if not d then -- 1109
		return -- 1110
	end -- 1110
	local moved = start and math.abs(p.x - start.x) + math.abs(p.y - start.y) or 0 -- 1111
	self:log("END moved=" .. tostring(math.floor(moved + 0.5))) -- 1112
	if moved < 20 then -- 1112
		return -- 1114
	end -- 1114
	if d.kind == "inventory" then -- 1114
		local target = self:cardAtPoint(p) -- 1116
		if target ~= nil then -- 1116
			if self.mgr:placeCoinOnCard(target, d.type, d.value) then -- 1116
				self:playCoinSound() -- 1118
			end -- 1118
			self.hintText = "" -- 1119
		else -- 1119
			self.hintText = "把硬币拖到某张卡牌上" -- 1121
		end -- 1121
		self:refresh() -- 1123
	else -- 1123
		local target = self:cardAtPoint(p) -- 1125
		if target == nil then -- 1125
			self.mgr:removePlacedCoin(d.cardId, d.index) -- 1127
		elseif target ~= d.cardId then -- 1127
			if self.mgr:movePlacedCoin(d.cardId, d.index, target) then -- 1127
				self:playCoinSound() -- 1129
			end -- 1129
		end -- 1129
		self:refresh() -- 1131
	end -- 1131
end -- 1103
function GameUI.prototype.playCoinSound(self) -- 1136
	self:playSfx("Audio/coin.wav") -- 1137
end -- 1136
function GameUI.prototype.playCardSound(self) -- 1141
	self:playSfx("Audio/card_paper.wav") -- 1142
end -- 1141
function GameUI.prototype.playSfx(self, path) -- 1146
	local s = AudioSource(path) -- 1147
	if s then -- 1147
		s.volume = self.sfxVolume -- 1149
		s:addTo(self.fxLayer) -- 1150
		s:play() -- 1151
	end -- 1151
end -- 1146
function GameUI.prototype.cardAtPoint(self, p) -- 1155
	do -- 1155
		local i = 0 -- 1156
		while i < #self.cardRects do -- 1156
			local r = self.cardRects[i + 1] -- 1157
			if p.x >= r.x - r.w / 2 and p.x <= r.x + r.w / 2 and p.y >= r.y - r.h / 2 and p.y <= r.y + r.h / 2 then -- 1157
				return r.id -- 1160
			end -- 1160
			i = i + 1 -- 1156
		end -- 1156
	end -- 1156
	return nil -- 1163
end -- 1155
function GameUI.prototype.makeGhost(self, ____type, value, pos) -- 1166
	self:hideGhost() -- 1167
	local node = Node() -- 1168
	node.position = pos -- 1169
	local d = DrawNode() -- 1170
	d:drawDot( -- 1171
		Vec2.zero, -- 1171
		26, -- 1171
		coinColor(____type) -- 1171
	) -- 1171
	d:drawDot(Vec2.zero, 20, C_BADGE) -- 1172
	d:addTo(node) -- 1173
	local l = Label("sarasa-mono-sc-regular", 20) -- 1174
	if l then -- 1174
		l.text = coinChipText(____type, value) -- 1175
		l.position = Vec2.zero -- 1175
		l.color = C_TEXT -- 1175
		l:addTo(node) -- 1175
	end -- 1175
	node:addTo(self.fxLayer) -- 1176
	self.dragGhost = node -- 1177
end -- 1166
function GameUI.prototype.hideGhost(self) -- 1180
	if self.dragGhost then -- 1180
		self.dragGhost:removeFromParent() -- 1181
		self.dragGhost = nil -- 1181
	end -- 1181
end -- 1180
function GameUI.prototype.doConfirm(self) -- 1184
	if self.mgr.state.status ~= "playing" then -- 1184
		return -- 1185
	end -- 1185
	if self.selectedCardId == nil then -- 1185
		return -- 1186
	end -- 1186
	local res = self.mgr:confirmCard(self.selectedCardId) -- 1187
	if res.ok then -- 1187
		self.selectedCardId = nil -- 1189
		self:playCardSound() -- 1190
	end -- 1190
	self:syncProgress() -- 1192
	self:refresh() -- 1193
end -- 1184
function GameUI.prototype.doEndTurn(self) -- 1196
	if self.mgr.state.status ~= "playing" then -- 1196
		return -- 1197
	end -- 1197
	self.mgr:endTurn() -- 1198
	self.selectedCardId = nil -- 1199
	self:syncProgress() -- 1200
	self:refresh() -- 1201
end -- 1196
function GameUI.prototype.opSymbol(self, op) -- 1204
	if op == "sub" then -- 1204
		return "−" -- 1205
	end -- 1205
	if op == "mul" then -- 1205
		return "×" -- 1206
	end -- 1206
	if op == "div" then -- 1206
		return "÷" -- 1207
	end -- 1207
	return "+" -- 1208
end -- 1204
return ____exports -- 1204