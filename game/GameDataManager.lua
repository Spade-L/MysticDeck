-- [ts]: GameDataManager.ts
local ____lualib = require("lualib_bundle") -- 1
local __TS__Class = ____lualib.__TS__Class -- 1
local __TS__ArraySplice = ____lualib.__TS__ArraySplice -- 1
local ____exports = {} -- 1
local ____types = require("game.types") -- 2
local CoinType = ____types.CoinType -- 5
local COIN_TYPE_ORDER = ____types.COIN_TYPE_ORDER -- 6
local coinTypeName = ____types.coinTypeName -- 11
____exports.GameDataManager = __TS__Class() -- 14
local GameDataManager = ____exports.GameDataManager -- 14
GameDataManager.name = "GameDataManager" -- 14
function GameDataManager.prototype.____constructor(self) -- 56
	self.highestLevel = 1 -- 43
	self.currency = 0 -- 44
	self.metaMaxHp = ____exports.GameDataManager.START_HP -- 45
	self.reserve = {} -- 47
	self.boughtBase = { -- 49
		0, -- 49
		0, -- 49
		0, -- 49
		0, -- 49
		0, -- 49
		0 -- 49
	} -- 49
	self.skillsSeeded = false -- 51
	self.deleteCredits = 3 -- 52
	self.state = self:createEmptyState() -- 57
	self:startLevel(1) -- 58
end -- 56
function GameDataManager.prototype.createEmptyState(self) -- 62
	return { -- 63
		hp = ____exports.GameDataManager.START_HP, -- 64
		maxHp = ____exports.GameDataManager.START_HP, -- 65
		level = 1, -- 66
		highestLevel = 1, -- 67
		turn = 0, -- 68
		targetCount = 3, -- 69
		eliminatedCount = 0, -- 70
		currency = 0, -- 71
		cards = {}, -- 72
		inventory = {}, -- 73
		nextCardId = 1, -- 74
		status = "playing" -- 75
	} -- 75
end -- 62
function GameDataManager.prototype.unlockLevel(self, level) -- 80
	local lvl = level -- 81
	if lvl < 1 then -- 81
		lvl = 1 -- 82
	end -- 82
	if lvl > ____exports.GameDataManager.MAX_LEVEL then -- 82
		lvl = ____exports.GameDataManager.MAX_LEVEL -- 83
	end -- 83
	if lvl > self.highestLevel then -- 83
		self.highestLevel = lvl -- 85
		self.state.highestLevel = lvl -- 86
	end -- 86
end -- 80
function GameDataManager.prototype.startLevel(self, level) -- 91
	local lvl = level -- 92
	if lvl < 1 then -- 92
		lvl = 1 -- 93
	end -- 93
	if lvl > ____exports.GameDataManager.MAX_LEVEL then -- 93
		lvl = ____exports.GameDataManager.MAX_LEVEL -- 94
	end -- 94
	if lvl > self.highestLevel then -- 94
		self.highestLevel = lvl -- 95
	end -- 95
	local extra = self:extraCoins() -- 98
	self.state = self:createEmptyState() -- 99
	self.state.level = lvl -- 100
	self.state.highestLevel = self.highestLevel -- 101
	self.state.currency = self.currency -- 102
	self:resetCoinCycle(extra) -- 104
	self.state.maxHp = self.metaMaxHp -- 105
	self.state.hp = self.metaMaxHp -- 106
	self.state.targetCount = ____exports.GameDataManager:levelTarget(lvl) -- 107
	self:dealInitialCards() -- 108
end -- 91
function GameDataManager.prototype.buildBaseCoins(self) -- 114
	local list = {} -- 115
	list[#list + 1] = {type = CoinType.Normal, value = 1, count = 4} -- 116
	list[#list + 1] = {type = CoinType.Normal, value = 2, count = 3} -- 117
	list[#list + 1] = {type = CoinType.Normal, value = 3, count = 2} -- 118
	list[#list + 1] = {type = CoinType.Normal, value = 5, count = 2} -- 119
	list[#list + 1] = {type = CoinType.Normal, value = 10, count = 1} -- 120
	return list -- 121
end -- 114
function GameDataManager.prototype.buildSkillCoins(self) -- 125
	local list = {} -- 126
	list[#list + 1] = {type = CoinType.Multiply, value = 2, count = 2} -- 127
	list[#list + 1] = {type = CoinType.Multiply, value = 3, count = 1} -- 128
	list[#list + 1] = {type = CoinType.Freeze, value = 1, count = 1} -- 129
	list[#list + 1] = {type = CoinType.Discount, value = 20, count = 1} -- 130
	list[#list + 1] = {type = CoinType.Copy, value = 1, count = 1} -- 131
	list[#list + 1] = {type = CoinType.Wild, value = 1, count = 1} -- 132
	list[#list + 1] = {type = CoinType.Growth, value = 1, count = 1} -- 133
	list[#list + 1] = {type = CoinType.Heal, value = 1, count = 2} -- 134
	list[#list + 1] = {type = CoinType.Disturb, value = 7, count = 1} -- 135
	return list -- 136
end -- 125
function GameDataManager.prototype.expandCoins(self, list) -- 140
	local out = {} -- 141
	do -- 141
		local i = 0 -- 142
		while i < #list do -- 142
			local s = list[i + 1] -- 143
			do -- 143
				local k = 0 -- 144
				while k < s.count do -- 144
					out[#out + 1] = {type = s.type, value = s.value, count = 1} -- 144
					k = k + 1 -- 144
				end -- 144
			end -- 144
			i = i + 1 -- 142
		end -- 142
	end -- 142
	return out -- 146
end -- 140
function GameDataManager.prototype.shuffleCoins(self, list) -- 150
	do -- 150
		local i = #list - 1 -- 151
		while i > 0 do -- 151
			local j = self:randomInt(0, i) -- 152
			local tmp = list[i + 1] -- 153
			list[i + 1] = list[j + 1] -- 154
			list[j + 1] = tmp -- 155
			i = i - 1 -- 151
		end -- 151
	end -- 151
	return list -- 157
end -- 150
function GameDataManager.prototype.collectStack(self, out, list) -- 161
	do -- 161
		local i = 0 -- 162
		while i < #list do -- 162
			local s = list[i + 1] -- 163
			do -- 163
				local k = 0 -- 164
				while k < s.count do -- 164
					out[#out + 1] = {type = s.type, value = s.value, count = 1} -- 164
					k = k + 1 -- 164
				end -- 164
			end -- 164
			i = i + 1 -- 162
		end -- 162
	end -- 162
end -- 161
function GameDataManager.prototype.isBaseCoin(self, ____type, value) -- 169
	if ____type ~= CoinType.Normal then -- 169
		return false -- 170
	end -- 170
	do -- 170
		local i = 0 -- 171
		while i < #____exports.GameDataManager.BASE_VALUES do -- 171
			if value == ____exports.GameDataManager.BASE_VALUES[i + 1] then -- 171
				return true -- 172
			end -- 172
			i = i + 1 -- 171
		end -- 171
	end -- 171
	return false -- 174
end -- 169
function GameDataManager.prototype.buyBaseCoin(self, idx) -- 178
	if idx < 0 or idx >= #____exports.GameDataManager.BASE_VALUES then -- 178
		return {ok = false, value = 0, reason = "无效的点数"} -- 180
	end -- 180
	if self.currency < ____exports.GameDataManager.BASE_COIN_COST then -- 180
		return {ok = false, value = 0, reason = "货币不足"} -- 183
	end -- 183
	self.currency = self.currency - ____exports.GameDataManager.BASE_COIN_COST -- 185
	self.state.currency = self.currency -- 186
	local ____self_boughtBase_0, ____temp_1 = self.boughtBase, idx + 1 -- 186
	____self_boughtBase_0[____temp_1] = ____self_boughtBase_0[____temp_1] + 1 -- 187
	return {ok = true, value = ____exports.GameDataManager.BASE_VALUES[idx + 1], reason = ""} -- 188
end -- 178
function GameDataManager.prototype.boughtBaseTotal(self) -- 192
	local n = 0 -- 193
	do -- 193
		local i = 0 -- 194
		while i < #self.boughtBase do -- 194
			n = n + self.boughtBase[i + 1] -- 194
			i = i + 1 -- 194
		end -- 194
	end -- 194
	return n -- 195
end -- 192
function GameDataManager.prototype.extraCoins(self) -- 199
	local all = {} -- 200
	self:collectStack(all, self.state.inventory) -- 201
	self:collectStack(all, self.reserve) -- 202
	local out = {} -- 203
	do -- 203
		local i = 0 -- 204
		while i < #all do -- 204
			local c = all[i + 1] -- 205
			if not self:isBaseCoin(c.type, c.value) then -- 205
				out[#out + 1] = {type = c.type, value = c.value, count = 1} -- 206
			end -- 206
			i = i + 1 -- 204
		end -- 204
	end -- 204
	return out -- 208
end -- 199
function GameDataManager.prototype.resetCoinCycle(self, extra) -- 213
	local pool = {} -- 214
	local base = self:expandCoins(self:buildBaseCoins()) -- 215
	do -- 215
		local i = 0 -- 216
		while i < #base do -- 216
			pool[#pool + 1] = base[i + 1] -- 216
			i = i + 1 -- 216
		end -- 216
	end -- 216
	do -- 216
		local i = 0 -- 218
		while i < #____exports.GameDataManager.BASE_VALUES do -- 218
			do -- 218
				local k = 0 -- 219
				while k < self.boughtBase[i + 1] do -- 219
					pool[#pool + 1] = {type = CoinType.Normal, value = ____exports.GameDataManager.BASE_VALUES[i + 1], count = 1} -- 220
					k = k + 1 -- 219
				end -- 219
			end -- 219
			i = i + 1 -- 218
		end -- 218
	end -- 218
	if not self.skillsSeeded then -- 218
		self.skillsSeeded = true -- 226
		local skills = self:expandCoins(self:buildSkillCoins()) -- 227
		do -- 227
			local i = 0 -- 228
			while i < #skills do -- 228
				pool[#pool + 1] = skills[i + 1] -- 228
				i = i + 1 -- 228
			end -- 228
		end -- 228
	end -- 228
	local extraList = self:expandCoins(extra) -- 230
	do -- 230
		local i = 0 -- 231
		while i < #extraList do -- 231
			pool[#pool + 1] = extraList[i + 1] -- 231
			i = i + 1 -- 231
		end -- 231
	end -- 231
	self:shuffleCoins(pool) -- 233
	local hand = {} -- 235
	local handCount = 0 -- 236
	while handCount < ____exports.GameDataManager.HAND_SIZE and #pool > 0 do -- 236
		local c = __TS__ArraySplice(pool, 0, 1)[1] -- 238
		self:addToStack(hand, c.type, c.value, c.count) -- 239
		handCount = handCount + 1 -- 240
	end -- 240
	self.state.inventory = hand -- 242
	self.reserve = pool -- 243
end -- 213
function GameDataManager.prototype.drawFromReserve(self) -- 247
	if #self.reserve == 0 then -- 247
		return -- 248
	end -- 248
	local c = __TS__ArraySplice(self.reserve, 0, 1)[1] -- 249
	self:addToStack(self.state.inventory, c.type, c.value, c.count) -- 250
end -- 247
function GameDataManager.levelTarget(self, level) -- 254
	local lvl = level -- 255
	if lvl < 1 then -- 255
		lvl = 1 -- 256
	end -- 256
	if lvl > ____exports.GameDataManager.MAX_LEVEL then -- 256
		lvl = ____exports.GameDataManager.MAX_LEVEL -- 257
	end -- 257
	return 3 + math.floor((lvl - 1) * 17 / 14) -- 258
end -- 254
function GameDataManager.prototype.buildStartingInventory(self) -- 262
	local inv = {} -- 263
	self:addToStack(inv, CoinType.Normal, 1, 4) -- 264
	self:addToStack(inv, CoinType.Normal, 2, 3) -- 265
	self:addToStack(inv, CoinType.Normal, 3, 2) -- 266
	self:addToStack(inv, CoinType.Normal, 5, 2) -- 267
	self:addToStack(inv, CoinType.Normal, 10, 1) -- 268
	self:addToStack(inv, CoinType.Multiply, 2, 2) -- 269
	self:addToStack(inv, CoinType.Multiply, 3, 1) -- 270
	self:addToStack(inv, CoinType.Freeze, 1, 1) -- 271
	self:addToStack(inv, CoinType.Discount, 20, 1) -- 272
	self:addToStack(inv, CoinType.Copy, 1, 1) -- 273
	self:addToStack(inv, CoinType.Wild, 1, 1) -- 274
	self:addToStack(inv, CoinType.Growth, 1, 1) -- 275
	self:addToStack(inv, CoinType.Heal, 1, 2) -- 276
	self:addToStack(inv, CoinType.Disturb, 7, 1) -- 277
	return inv -- 278
end -- 262
function GameDataManager.prototype.addToStack(self, inv, ____type, value, count) -- 282
	do -- 282
		local i = 0 -- 283
		while i < #inv do -- 283
			local s = inv[i + 1] -- 284
			if s.type == ____type and s.value == value then -- 284
				s.count = s.count + count -- 286
				return -- 287
			end -- 287
			i = i + 1 -- 283
		end -- 283
	end -- 283
	inv[#inv + 1] = {type = ____type, value = value, count = count} -- 290
end -- 282
function GameDataManager.prototype.addCoin(self, ____type, value, count) -- 294
	self:addToStack(self.state.inventory, ____type, value, count) -- 295
end -- 294
function GameDataManager.prototype.flipCoinSign(self, ____type, value) -- 299
	local inv = self.state.inventory -- 300
	do -- 300
		local i = 0 -- 301
		while i < #inv do -- 301
			local s = inv[i + 1] -- 302
			if s.type == ____type and s.value == value then -- 302
				local count = s.count -- 304
				__TS__ArraySplice(inv, i, 1) -- 305
				self:addToStack(inv, ____type, -value, count) -- 306
				return -- 307
			end -- 307
			i = i + 1 -- 301
		end -- 301
	end -- 301
end -- 299
function GameDataManager.prototype.consumeCoin(self, ____type, value, count) -- 315
	local inv = self.state.inventory -- 316
	do -- 316
		local i = 0 -- 317
		while i < #inv do -- 317
			local s = inv[i + 1] -- 318
			if s.type == ____type and s.value == value then -- 318
				if s.count < count then -- 318
					return false -- 320
				end -- 320
				s.count = s.count - count -- 321
				if s.count <= 0 then -- 321
					__TS__ArraySplice(inv, i, 1) -- 322
				end -- 322
				do -- 322
					local k = 0 -- 323
					while k < count do -- 323
						local ____self_reserve_2 = self.reserve -- 323
						____self_reserve_2[#____self_reserve_2 + 1] = {type = ____type, value = value, count = 1} -- 324
						k = k + 1 -- 323
					end -- 323
				end -- 323
				return true -- 326
			end -- 326
			i = i + 1 -- 317
		end -- 317
	end -- 317
	return false -- 329
end -- 315
function GameDataManager.prototype.refillHand(self) -- 333
	local inv = self.state.inventory -- 334
	local handCount = 0 -- 335
	do -- 335
		local i = 0 -- 336
		while i < #inv do -- 336
			handCount = handCount + inv[i + 1].count -- 336
			i = i + 1 -- 336
		end -- 336
	end -- 336
	while handCount < ____exports.GameDataManager.HAND_SIZE and #self.reserve > 0 do -- 336
		self:drawFromReserve() -- 338
		handCount = handCount + 1 -- 339
	end -- 339
end -- 333
function GameDataManager.prototype.stackCount(self, ____type, value) -- 344
	local inv = self.state.inventory -- 345
	do -- 345
		local i = 0 -- 346
		while i < #inv do -- 346
			local s = inv[i + 1] -- 347
			if s.type == ____type and s.value == value then -- 347
				return s.count -- 348
			end -- 348
			i = i + 1 -- 346
		end -- 346
	end -- 346
	return 0 -- 350
end -- 344
function GameDataManager.prototype.coinTotal(self) -- 354
	local n = 0 -- 355
	local inv = self.state.inventory -- 356
	do -- 356
		local i = 0 -- 357
		while i < #inv do -- 357
			n = n + inv[i + 1].count -- 357
			i = i + 1 -- 357
		end -- 357
	end -- 357
	return n -- 358
end -- 354
function GameDataManager.prototype.distinctTypeCount(self) -- 362
	local seen = {} -- 363
	local inv = self.state.inventory -- 364
	do -- 364
		local i = 0 -- 365
		while i < #inv do -- 365
			local t = inv[i + 1].type -- 366
			local found = false -- 367
			do -- 367
				local j = 0 -- 368
				while j < #seen do -- 368
					if seen[j + 1] == t then -- 368
						found = true -- 369
						break -- 369
					end -- 369
					j = j + 1 -- 368
				end -- 368
			end -- 368
			if not found then -- 368
				seen[#seen + 1] = t -- 371
			end -- 371
			i = i + 1 -- 365
		end -- 365
	end -- 365
	return #seen -- 373
end -- 362
function GameDataManager.prototype.typeNameList(self) -- 377
	local names = {} -- 378
	local inv = self.state.inventory -- 379
	do -- 379
		local i = 0 -- 380
		while i < #inv do -- 380
			local name = coinTypeName(inv[i + 1].type) -- 381
			local found = false -- 382
			do -- 382
				local j = 0 -- 383
				while j < #names do -- 383
					if names[j + 1] == name then -- 383
						found = true -- 384
						break -- 384
					end -- 384
					j = j + 1 -- 383
				end -- 383
			end -- 383
			if not found then -- 383
				names[#names + 1] = name -- 386
			end -- 386
			i = i + 1 -- 380
		end -- 380
	end -- 380
	local out = "" -- 388
	do -- 388
		local i = 0 -- 389
		while i < #names do -- 389
			if i > 0 then -- 389
				out = out .. "/" -- 390
			end -- 390
			out = out .. names[i + 1] -- 391
			i = i + 1 -- 389
		end -- 389
	end -- 389
	return out -- 393
end -- 377
function GameDataManager.prototype.randomInt(self, min, max) -- 397
	return math.floor(math.random() * (max - min + 1)) + min -- 398
end -- 397
function GameDataManager.prototype.pickTarget(self, level, cards) -- 402
	local pool -- 403
	local big -- 404
	if level >= 12 then -- 404
		pool = ____exports.GameDataManager.POOL_HIGH -- 406
		big = 30 -- 407
	elseif level >= 7 then -- 407
		pool = ____exports.GameDataManager.POOL_MID -- 409
		big = 30 -- 410
	else -- 410
		pool = ____exports.GameDataManager.POOL_LOW -- 412
		big = 20 -- 413
	end -- 413
	local bigOnField = 0 -- 415
	do -- 415
		local i = 0 -- 416
		while i < #cards do -- 416
			if cards[i + 1].target >= big then -- 416
				bigOnField = bigOnField + 1 -- 417
			end -- 417
			i = i + 1 -- 416
		end -- 416
	end -- 416
	local useSmall = bigOnField >= 1 -- 419
	do -- 419
		local attempt = 0 -- 420
		while attempt < 12 do -- 420
			local t = pool[self:randomInt(0, #pool - 1) + 1] -- 421
			if not useSmall or t < big then -- 421
				return t -- 422
			end -- 422
			attempt = attempt + 1 -- 420
		end -- 420
	end -- 420
	return 3 -- 424
end -- 402
function GameDataManager.prototype.dealCard(self) -- 428
	local target = self:pickTarget(self.state.level, self.state.cards) -- 429
	local card = { -- 430
		id = self.state.nextCardId, -- 431
		target = target, -- 432
		originalTarget = target, -- 433
		countdown = ____exports.GameDataManager.CARD_COUNTDOWN, -- 434
		frozen = false, -- 435
		healAmount = 0, -- 436
		copyArmed = false, -- 437
		coins = {}, -- 438
		eliminated = false, -- 439
		special = false, -- 440
		specialType = "" -- 441
	} -- 441
	local ____self_state_3, ____nextCardId_4 = self.state, "nextCardId" -- 441
	____self_state_3[____nextCardId_4] = ____self_state_3[____nextCardId_4] + 1 -- 443
	local ____self_state_cards_5 = self.state.cards -- 443
	____self_state_cards_5[#____self_state_cards_5 + 1] = card -- 444
end -- 428
function GameDataManager.prototype.dealInitialCards(self) -- 448
	while #self.state.cards < ____exports.GameDataManager.FIELD_CARD_COUNT do -- 448
		self:dealCard() -- 450
	end -- 450
end -- 448
function GameDataManager.prototype.findCard(self, cardId) -- 455
	local cards = self.state.cards -- 456
	do -- 456
		local i = 0 -- 457
		while i < #cards do -- 457
			if cards[i + 1].id == cardId then -- 457
				return cards[i + 1] -- 458
			end -- 458
			i = i + 1 -- 457
		end -- 457
	end -- 457
	return nil -- 460
end -- 455
function GameDataManager.prototype.removeCard(self, cardId) -- 464
	local cards = self.state.cards -- 465
	do -- 465
		local i = 0 -- 466
		while i < #cards do -- 466
			if cards[i + 1].id == cardId then -- 466
				__TS__ArraySplice(cards, i, 1) -- 467
				return -- 467
			end -- 467
			i = i + 1 -- 466
		end -- 466
	end -- 466
end -- 464
function GameDataManager.prototype.placeCoinOnCard(self, cardId, ____type, value) -- 472
	local card = self:findCard(cardId) -- 473
	if not card or card.eliminated then -- 473
		return false -- 474
	end -- 474
	if self:stackCount(____type, value) <= 0 then -- 474
		return false -- 475
	end -- 475
	if ____type == CoinType.Freeze then -- 475
		card.frozen = true -- 479
		self:consumeCoin(____type, value, 1) -- 480
		return true -- 481
	end -- 481
	if ____type == CoinType.Discount then -- 481
		self:applyDiscount(card, value) -- 484
		self:consumeCoin(____type, value, 1) -- 485
		return true -- 486
	end -- 486
	if ____type == CoinType.Heal then -- 486
		card.healAmount = card.healAmount + value -- 489
		self:consumeCoin(____type, value, 1) -- 490
		return true -- 491
	end -- 491
	if ____type == CoinType.Copy then -- 491
		card.copyArmed = true -- 494
		self:consumeCoin(____type, value, 1) -- 495
		return true -- 496
	end -- 496
	if ____type == CoinType.Wild then -- 496
		self:consumeCoin(____type, value, 1) -- 499
		self:eliminateCard(card) -- 500
		return true -- 501
	end -- 501
	local negative = value < 0 -- 506
	local op = "add" -- 507
	if ____type == CoinType.Multiply then -- 507
		op = negative and "div" or "mul" -- 508
	elseif negative then -- 508
		op = "sub" -- 509
	end -- 509
	local placed = { -- 510
		type = ____type, -- 510
		value = math.abs(value), -- 510
		op = op -- 510
	} -- 510
	local ____card_coins_6 = card.coins -- 510
	____card_coins_6[#____card_coins_6 + 1] = placed -- 511
	self:consumeCoin(____type, value, 1) -- 512
	return true -- 513
end -- 472
function GameDataManager.prototype.applyDiscount(self, card, percent) -- 517
	local p = percent -- 518
	if p < 0 then -- 518
		p = 0 -- 519
	end -- 519
	if p > ____exports.GameDataManager.DISCOUNT_MAX then -- 519
		p = ____exports.GameDataManager.DISCOUNT_MAX -- 520
	end -- 520
	card.target = math.max( -- 521
		1, -- 521
		math.floor(card.target * (100 - p) / 100 + 0.5) -- 521
	) -- 521
end -- 517
function GameDataManager.prototype.togglePlacedCoin(self, cardId, index) -- 525
	local card = self:findCard(cardId) -- 526
	if not card or index < 0 or index >= #card.coins then -- 526
		return -- 527
	end -- 527
	local c = card.coins[index + 1] -- 528
	if c.type == CoinType.Multiply then -- 528
		c.op = c.op == "mul" and "div" or "mul" -- 530
	else -- 530
		c.op = c.op == "sub" and "add" or "sub" -- 532
	end -- 532
end -- 525
function GameDataManager.prototype.removePlacedCoin(self, cardId, index) -- 537
	local card = self:findCard(cardId) -- 538
	if not card or index < 0 or index >= #card.coins then -- 538
		return false -- 539
	end -- 539
	local c = card.coins[index + 1] -- 540
	__TS__ArraySplice(card.coins, index, 1) -- 541
	local sign = (c.op == "sub" or c.op == "div") and -1 or 1 -- 543
	self:addCoin(c.type, c.value * sign, 1) -- 544
	return true -- 545
end -- 537
function GameDataManager.prototype.movePlacedCoin(self, fromCardId, index, toCardId) -- 549
	local from = self:findCard(fromCardId) -- 550
	local to = self:findCard(toCardId) -- 551
	if not from or not to or from == to or index < 0 or index >= #from.coins then -- 551
		return false -- 552
	end -- 552
	local c = from.coins[index + 1] -- 553
	__TS__ArraySplice(from.coins, index, 1) -- 554
	local ____to_coins_7 = to.coins -- 554
	____to_coins_7[#____to_coins_7 + 1] = c -- 555
	return true -- 556
end -- 549
function GameDataManager.prototype.evaluateCard(self, card) -- 560
	local total = 0 -- 561
	do -- 561
		local i = 0 -- 562
		while i < #card.coins do -- 562
			local c = card.coins[i + 1] -- 563
			if c.type == CoinType.Multiply then -- 563
				if c.op == "div" then -- 563
					total = c.value == 0 and total or math.floor(total / c.value) -- 566
				else -- 566
					total = total * c.value -- 568
				end -- 568
			else -- 568
				if c.op == "sub" then -- 568
					total = total - c.value -- 571
				else -- 571
					total = total + c.value -- 572
				end -- 572
			end -- 572
			i = i + 1 -- 562
		end -- 562
	end -- 562
	return total -- 575
end -- 560
function GameDataManager.prototype.confirmCard(self, cardId) -- 579
	local result = { -- 580
		ok = false, -- 581
		reason = "none", -- 582
		total = 0, -- 583
		target = 0, -- 584
		healGained = 0, -- 585
		copiedValue = 0 -- 586
	} -- 586
	local card = self:findCard(cardId) -- 588
	if not card then -- 588
		return result -- 589
	end -- 589
	result.target = card.target -- 590
	if card.eliminated then -- 590
		result.reason = "eliminated" -- 591
		return result -- 591
	end -- 591
	local total = self:evaluateCard(card) -- 592
	result.total = total -- 593
	if #card.coins == 0 then -- 593
		result.reason = "no_coin" -- 594
		return result -- 594
	end -- 594
	if total ~= card.target then -- 594
		result.reason = "mismatch" -- 595
		return result -- 595
	end -- 595
	local r = self:eliminateCard(card) -- 596
	result.ok = true -- 597
	result.reason = "ok" -- 598
	result.healGained = r.healGained -- 599
	result.copiedValue = r.copiedValue -- 600
	return result -- 601
end -- 579
function GameDataManager.prototype.eliminateCard(self, card) -- 605
	card.eliminated = true -- 606
	local ____self_state_8, ____eliminatedCount_9 = self.state, "eliminatedCount" -- 606
	____self_state_8[____eliminatedCount_9] = ____self_state_8[____eliminatedCount_9] + 1 -- 607
	local healGained = 0 -- 608
	if card.healAmount > 0 then -- 608
		healGained = card.healAmount -- 610
		self.state.hp = math.min(self.state.maxHp, self.state.hp + healGained) -- 611
	end -- 611
	local copiedValue = 0 -- 613
	if card.copyArmed then -- 613
		copiedValue = card.target -- 615
		self:addCoin(CoinType.Normal, copiedValue, 1) -- 616
	end -- 616
	self:removeCard(card.id) -- 618
	self:dealCard() -- 619
	self:checkWin() -- 620
	return {healGained = healGained, copiedValue = copiedValue} -- 621
end -- 605
function GameDataManager.prototype.endTurn(self) -- 625
	local ____self_state_10, ____turn_11 = self.state, "turn" -- 625
	____self_state_10[____turn_11] = ____self_state_10[____turn_11] + 1 -- 626
	local fieldCards = self.state.cards -- 628
	do -- 628
		local i = #fieldCards - 1 -- 629
		while i >= 0 do -- 629
			do -- 629
				local c = fieldCards[i + 1] -- 630
				if c.eliminated then -- 630
					goto __continue168 -- 631
				end -- 631
				if #c.coins > 0 and self:evaluateCard(c) == c.target then -- 631
					self:eliminateCard(c) -- 632
				end -- 632
			end -- 632
			::__continue168:: -- 632
			i = i - 1 -- 629
		end -- 629
	end -- 629
	local hpLost = 0 -- 634
	local expiredCount = 0 -- 635
	local cards = self.state.cards -- 636
	do -- 636
		local i = #cards - 1 -- 639
		while i >= 0 do -- 639
			do -- 639
				local card = cards[i + 1] -- 640
				if card.frozen then -- 640
					card.frozen = false -- 641
					goto __continue172 -- 641
				end -- 641
				card.countdown = card.countdown - 1 -- 642
				if card.countdown <= 0 then -- 642
					hpLost = hpLost + 1 -- 644
					expiredCount = expiredCount + 1 -- 645
					local ____self_state_12, ____hp_13 = self.state, "hp" -- 645
					____self_state_12[____hp_13] = ____self_state_12[____hp_13] - 1 -- 646
					__TS__ArraySplice(cards, i, 1) -- 647
				end -- 647
			end -- 647
			::__continue172:: -- 647
			i = i - 1 -- 639
		end -- 639
	end -- 639
	do -- 639
		local ci = 0 -- 652
		while ci < #cards do -- 652
			local card = cards[ci + 1] -- 653
			do -- 653
				local pi = 0 -- 654
				while pi < #card.coins do -- 654
					local pc = card.coins[pi + 1] -- 655
					if pc.type == CoinType.Growth then -- 655
						pc.value = math.min(____exports.GameDataManager.COIN_MAX_VALUE, pc.value * 2) -- 657
					end -- 657
					pi = pi + 1 -- 654
				end -- 654
			end -- 654
			ci = ci + 1 -- 652
		end -- 652
	end -- 652
	local inv = self.state.inventory -- 663
	do -- 663
		local i = #inv - 1 -- 664
		while i >= 0 do -- 664
			if inv[i + 1].type == CoinType.Disturb then -- 664
				__TS__ArraySplice(inv, i, 1) -- 665
			end -- 665
			i = i - 1 -- 664
		end -- 664
	end -- 664
	while #cards < ____exports.GameDataManager.FIELD_CARD_COUNT do -- 664
		self:dealCard() -- 669
	end -- 669
	self:refillHand() -- 672
	local won = false -- 675
	local lost = false -- 676
	if self.state.hp <= 0 then -- 676
		self.state.hp = 0 -- 678
		self.state.status = "lost" -- 679
		lost = true -- 680
	else -- 680
		self:checkWin() -- 682
		won = self.state.status == "won" -- 683
	end -- 683
	return {hpLost = hpLost, expiredCount = expiredCount, won = won, lost = lost} -- 685
end -- 625
function GameDataManager.prototype.checkWin(self) -- 689
	if self.state.eliminatedCount >= self.state.targetCount and self.state.status == "playing" then -- 689
		self.state.status = self.state.level >= ____exports.GameDataManager.MAX_LEVEL and "complete" or "won" -- 691
	end -- 691
end -- 689
function GameDataManager.prototype.applyWinRewards(self) -- 696
	local gain = ____exports.GameDataManager.WIN_CURRENCY_PER_LEVEL * self.state.level -- 697
	local ____self_state_14, ____currency_15 = self.state, "currency" -- 697
	____self_state_14[____currency_15] = ____self_state_14[____currency_15] + gain -- 698
	self.currency = self.state.currency -- 699
	local r = self:randomRewardCoin() -- 700
	self:addCoin(r.type, r.value, 1) -- 701
	return {currency = gain, coinType = r.type, coinValue = r.value} -- 702
end -- 696
function GameDataManager.prototype.randomRewardCoin(self) -- 706
	local r = self:randomInt(1, 100) -- 707
	if r <= 60 then -- 707
		return { -- 708
			type = CoinType.Normal, -- 708
			value = self:randomInt(1, 10), -- 708
			count = 1 -- 708
		} -- 708
	end -- 708
	if r <= 80 then -- 708
		return { -- 709
			type = CoinType.Multiply, -- 709
			value = self:randomInt(2, 4), -- 709
			count = 1 -- 709
		} -- 709
	end -- 709
	local specials = {CoinType.Freeze, CoinType.Heal, CoinType.Growth, CoinType.Disturb} -- 710
	return { -- 711
		type = specials[self:randomInt(0, #specials - 1) + 1], -- 711
		value = 1, -- 711
		count = 1 -- 711
	} -- 711
end -- 706
function GameDataManager.prototype.coinCap(self, ____type) -- 717
	return ____type == CoinType.Discount and ____exports.GameDataManager.DISCOUNT_MAX or ____exports.GameDataManager.COIN_MAX_VALUE -- 718
end -- 717
function GameDataManager.prototype.synthesizeCoins(self, ____type, valueA, valueB) -- 722
	if self:stackCount(____type, valueA) < 1 then -- 722
		return {ok = false, resultValue = 0} -- 723
	end -- 723
	if valueA == valueB and self:stackCount(____type, valueA) < 2 then -- 723
		return {ok = false, resultValue = 0} -- 724
	end -- 724
	if valueA ~= valueB and self:stackCount(____type, valueB) < 1 then -- 724
		return {ok = false, resultValue = 0} -- 725
	end -- 725
	self:consumeCoin(____type, valueA, 1) -- 726
	self:consumeCoin(____type, valueB, 1) -- 727
	local sum = math.min( -- 728
		self:coinCap(____type), -- 728
		valueA + valueB -- 728
	) -- 728
	self:addCoin(____type, sum, 1) -- 729
	return {ok = true, resultValue = sum} -- 730
end -- 722
function GameDataManager.prototype.synthesizeOnce(self) -- 734
	do -- 734
		local t = 0 -- 735
		while t < #COIN_TYPE_ORDER do -- 735
			do -- 735
				local ____type = COIN_TYPE_ORDER[t + 1] -- 736
				local values = {} -- 737
				local inv = self.state.inventory -- 738
				do -- 738
					local i = 0 -- 739
					while i < #inv do -- 739
						if inv[i + 1].type == ____type then -- 739
							do -- 739
								local k = 0 -- 741
								while k < inv[i + 1].count do -- 741
									values[#values + 1] = inv[i + 1].value -- 741
									k = k + 1 -- 741
								end -- 741
							end -- 741
						end -- 741
						i = i + 1 -- 739
					end -- 739
				end -- 739
				if #values < 2 then -- 739
					goto __continue199 -- 744
				end -- 744
				local i1 = 0 -- 745
				local i2 = 1 -- 746
				if values[i2 + 1] < values[i1 + 1] then -- 746
					local tmp = i1 -- 747
					i1 = i2 -- 747
					i2 = tmp -- 747
				end -- 747
				do -- 747
					local i = 2 -- 748
					while i < #values do -- 748
						if values[i + 1] < values[i1 + 1] then -- 748
							i2 = i1 -- 749
							i1 = i -- 749
						elseif values[i + 1] < values[i2 + 1] then -- 749
							i2 = i -- 750
						end -- 750
						i = i + 1 -- 748
					end -- 748
				end -- 748
				local a = values[i1 + 1] -- 752
				local b = values[i2 + 1] -- 753
				local r = self:synthesizeCoins(____type, a, b) -- 754
				return { -- 755
					ok = r.ok, -- 755
					type = ____type, -- 755
					valueA = a, -- 755
					valueB = b, -- 755
					resultValue = r.resultValue -- 755
				} -- 755
			end -- 755
			::__continue199:: -- 755
			t = t + 1 -- 735
		end -- 735
	end -- 735
	return { -- 757
		ok = false, -- 757
		type = CoinType.Normal, -- 757
		valueA = 0, -- 757
		valueB = 0, -- 757
		resultValue = 0 -- 757
	} -- 757
end -- 734
function GameDataManager.prototype.deleteCoin(self, ____type, value, count) -- 761
	if self.deleteCredits < count then -- 761
		return {ok = false, reason = "删除次数不足"} -- 762
	end -- 762
	if not self:consumeCoin(____type, value, count) then -- 762
		return {ok = false, reason = "硬币不足"} -- 763
	end -- 763
	self.deleteCredits = self.deleteCredits - count -- 764
	return {ok = true, reason = ""} -- 765
end -- 761
function GameDataManager.prototype.deleteOnce(self) -- 769
	local inv = self.state.inventory -- 770
	if #inv == 0 then -- 770
		return {ok = false, type = CoinType.Normal, value = 0, reason = "背包为空"} -- 771
	end -- 771
	local st = inv[1] -- 772
	local r = self:deleteCoin(st.type, st.value, 1) -- 773
	return {ok = r.ok, type = st.type, value = st.value, reason = r.reason} -- 774
end -- 769
function GameDataManager.prototype.upgradeMaxHp(self) -- 778
	local cost = 100 -- 779
	if self.metaMaxHp >= ____exports.GameDataManager.MAX_HP then -- 779
		return {ok = false, cost = cost, newMaxHp = self.metaMaxHp, reason = "已达上限"} -- 780
	end -- 780
	if self.currency < cost then -- 780
		return {ok = false, cost = cost, newMaxHp = self.metaMaxHp, reason = "货币不足"} -- 781
	end -- 781
	self.currency = self.currency - cost -- 782
	self.state.currency = self.currency -- 783
	self.metaMaxHp = self.metaMaxHp + 1 -- 784
	self.state.maxHp = self.metaMaxHp -- 785
	return {ok = true, cost = cost, newMaxHp = self.metaMaxHp, reason = ""} -- 786
end -- 778
function GameDataManager.prototype.upgradeDeleteCredits(self) -- 790
	local cost = 80 -- 791
	if self.currency < cost then -- 791
		return {ok = false, cost = cost, newCredits = self.deleteCredits, reason = "货币不足"} -- 792
	end -- 792
	self.currency = self.currency - cost -- 793
	self.state.currency = self.currency -- 794
	self.deleteCredits = self.deleteCredits + 2 -- 795
	return {ok = true, cost = cost, newCredits = self.deleteCredits, reason = ""} -- 796
end -- 790
function GameDataManager.prototype.sweepLevel(self) -- 800
	if self.highestLevel < 2 then -- 800
		return { -- 801
			ok = false, -- 801
			currency = 0, -- 801
			coinType = CoinType.Normal, -- 801
			coinValue = 0, -- 801
			reason = "通关首关后开启" -- 801
		} -- 801
	end -- 801
	local gain = math.min(1000, self.highestLevel * 30) -- 802
	self.currency = self.currency + gain -- 803
	self.state.currency = self.currency -- 804
	local r = self:randomRewardCoin() -- 805
	self:addCoin(r.type, r.value, 1) -- 806
	return { -- 807
		ok = true, -- 807
		currency = gain, -- 807
		coinType = r.type, -- 807
		coinValue = r.value, -- 807
		reason = "" -- 807
	} -- 807
end -- 800
GameDataManager.START_HP = 2 -- 800
GameDataManager.MAX_LEVEL = 15 -- 800
GameDataManager.CARD_COUNTDOWN = 3 -- 800
GameDataManager.FIELD_CARD_COUNT = 3 -- 800
GameDataManager.COIN_MAX_VALUE = 999 -- 800
GameDataManager.DISCOUNT_MAX = 100 -- 800
GameDataManager.MAX_HP = 5 -- 800
GameDataManager.HAND_SIZE = 12 -- 800
GameDataManager.WIN_CURRENCY_PER_LEVEL = 100 -- 800
GameDataManager.BASE_VALUES = { -- 800
	1, -- 26
	2, -- 26
	3, -- 26
	5, -- 26
	10, -- 26
	50 -- 26
} -- 26
GameDataManager.BASE_COIN_COST = 100 -- 26
GameDataManager.POOL_LOW = { -- 26
	2, -- 32
	3, -- 32
	4, -- 32
	5, -- 32
	6, -- 32
	7, -- 32
	8, -- 32
	9, -- 32
	10, -- 32
	11, -- 32
	12, -- 32
	14, -- 32
	15, -- 32
	16, -- 32
	18, -- 32
	20 -- 32
} -- 32
GameDataManager.POOL_MID = { -- 32
	2, -- 35
	3, -- 35
	4, -- 35
	5, -- 35
	6, -- 35
	7, -- 35
	8, -- 35
	9, -- 35
	10, -- 35
	11, -- 35
	12, -- 35
	14, -- 35
	15, -- 35
	16, -- 35
	18, -- 35
	20, -- 35
	21, -- 35
	22, -- 35
	24, -- 35
	25, -- 35
	27, -- 35
	28 -- 35
} -- 35
GameDataManager.POOL_HIGH = { -- 35
	3, -- 38
	4, -- 38
	5, -- 38
	6, -- 38
	7, -- 38
	8, -- 38
	9, -- 38
	10, -- 38
	11, -- 38
	12, -- 38
	14, -- 38
	15, -- 38
	16, -- 38
	18, -- 38
	20, -- 38
	21, -- 38
	22, -- 38
	24, -- 38
	25, -- 38
	27, -- 38
	28, -- 38
	30, -- 39
	32, -- 39
	35, -- 39
	36, -- 39
	40, -- 39
	42, -- 39
	45 -- 39
} -- 39
return ____exports -- 39