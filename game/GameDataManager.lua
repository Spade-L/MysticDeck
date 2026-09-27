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
function GameDataManager.prototype.____constructor(self) -- 38
	self.highestLevel = 1 -- 30
	self.currency = 0 -- 31
	self.inventory = {} -- 32
	self.metaMaxHp = ____exports.GameDataManager.START_HP -- 33
	self.deleteCredits = 3 -- 34
	self.state = self:createEmptyState() -- 39
	self:startLevel(1) -- 40
end -- 38
function GameDataManager.prototype.createEmptyState(self) -- 44
	return { -- 45
		hp = ____exports.GameDataManager.START_HP, -- 46
		maxHp = ____exports.GameDataManager.START_HP, -- 47
		level = 1, -- 48
		highestLevel = 1, -- 49
		turn = 0, -- 50
		targetCount = 3, -- 51
		eliminatedCount = 0, -- 52
		currency = 0, -- 53
		cards = {}, -- 54
		inventory = {}, -- 55
		nextCardId = 1, -- 56
		status = "playing" -- 57
	} -- 57
end -- 44
function GameDataManager.prototype.unlockLevel(self, level) -- 62
	local lvl = level -- 63
	if lvl < 1 then -- 63
		lvl = 1 -- 64
	end -- 64
	if lvl > ____exports.GameDataManager.MAX_LEVEL then -- 64
		lvl = ____exports.GameDataManager.MAX_LEVEL -- 65
	end -- 65
	if lvl > self.highestLevel then -- 65
		self.highestLevel = lvl -- 67
		self.state.highestLevel = lvl -- 68
	end -- 68
end -- 62
function GameDataManager.prototype.startLevel(self, level) -- 73
	local lvl = level -- 74
	if lvl < 1 then -- 74
		lvl = 1 -- 75
	end -- 75
	if lvl > ____exports.GameDataManager.MAX_LEVEL then -- 75
		lvl = ____exports.GameDataManager.MAX_LEVEL -- 76
	end -- 76
	if lvl > self.highestLevel then -- 76
		self.highestLevel = lvl -- 77
	end -- 77
	if #self.inventory == 0 then -- 77
		self.inventory = self:buildStartingInventory() -- 78
	end -- 78
	self.state = self:createEmptyState() -- 80
	self.state.level = lvl -- 81
	self.state.highestLevel = self.highestLevel -- 82
	self.state.currency = self.currency -- 83
	self.state.inventory = self.inventory -- 84
	self.state.maxHp = self.metaMaxHp -- 85
	self.state.hp = self.metaMaxHp -- 86
	self.state.targetCount = ____exports.GameDataManager:levelTarget(lvl) -- 87
	self:dealInitialCards() -- 88
end -- 73
function GameDataManager.levelTarget(self, level) -- 92
	local lvl = level -- 93
	if lvl < 1 then -- 93
		lvl = 1 -- 94
	end -- 94
	if lvl > ____exports.GameDataManager.MAX_LEVEL then -- 94
		lvl = ____exports.GameDataManager.MAX_LEVEL -- 95
	end -- 95
	return 3 + math.floor((lvl - 1) * 17 / 14) -- 96
end -- 92
function GameDataManager.prototype.buildStartingInventory(self) -- 100
	local inv = {} -- 101
	self:addToStack(inv, CoinType.Normal, 1, 4) -- 102
	self:addToStack(inv, CoinType.Normal, 2, 3) -- 103
	self:addToStack(inv, CoinType.Normal, 3, 2) -- 104
	self:addToStack(inv, CoinType.Normal, 5, 2) -- 105
	self:addToStack(inv, CoinType.Normal, 10, 1) -- 106
	self:addToStack(inv, CoinType.Multiply, 2, 2) -- 107
	self:addToStack(inv, CoinType.Multiply, 3, 1) -- 108
	self:addToStack(inv, CoinType.Freeze, 1, 1) -- 109
	self:addToStack(inv, CoinType.Discount, 20, 1) -- 110
	self:addToStack(inv, CoinType.Copy, 1, 1) -- 111
	self:addToStack(inv, CoinType.Wild, 1, 1) -- 112
	self:addToStack(inv, CoinType.Growth, 1, 1) -- 113
	self:addToStack(inv, CoinType.Heal, 1, 2) -- 114
	self:addToStack(inv, CoinType.Disturb, 7, 1) -- 115
	return inv -- 116
end -- 100
function GameDataManager.prototype.addToStack(self, inv, ____type, value, count) -- 120
	do -- 120
		local i = 0 -- 121
		while i < #inv do -- 121
			local s = inv[i + 1] -- 122
			if s.type == ____type and s.value == value then -- 122
				s.count = s.count + count -- 124
				return -- 125
			end -- 125
			i = i + 1 -- 121
		end -- 121
	end -- 121
	inv[#inv + 1] = {type = ____type, value = value, count = count} -- 128
end -- 120
function GameDataManager.prototype.addCoin(self, ____type, value, count) -- 132
	self:addToStack(self.state.inventory, ____type, value, count) -- 133
end -- 132
function GameDataManager.prototype.flipCoinSign(self, ____type, value) -- 137
	local inv = self.state.inventory -- 138
	do -- 138
		local i = 0 -- 139
		while i < #inv do -- 139
			local s = inv[i + 1] -- 140
			if s.type == ____type and s.value == value then -- 140
				local count = s.count -- 142
				__TS__ArraySplice(inv, i, 1) -- 143
				self:addToStack(inv, ____type, -value, count) -- 144
				return -- 145
			end -- 145
			i = i + 1 -- 139
		end -- 139
	end -- 139
end -- 137
function GameDataManager.prototype.consumeCoin(self, ____type, value, count) -- 151
	local inv = self.state.inventory -- 152
	do -- 152
		local i = 0 -- 153
		while i < #inv do -- 153
			local s = inv[i + 1] -- 154
			if s.type == ____type and s.value == value then -- 154
				if s.count < count then -- 154
					return false -- 156
				end -- 156
				s.count = s.count - count -- 157
				if s.count <= 0 then -- 157
					__TS__ArraySplice(inv, i, 1) -- 158
				end -- 158
				return true -- 159
			end -- 159
			i = i + 1 -- 153
		end -- 153
	end -- 153
	return false -- 162
end -- 151
function GameDataManager.prototype.stackCount(self, ____type, value) -- 166
	local inv = self.state.inventory -- 167
	do -- 167
		local i = 0 -- 168
		while i < #inv do -- 168
			local s = inv[i + 1] -- 169
			if s.type == ____type and s.value == value then -- 169
				return s.count -- 170
			end -- 170
			i = i + 1 -- 168
		end -- 168
	end -- 168
	return 0 -- 172
end -- 166
function GameDataManager.prototype.coinTotal(self) -- 176
	local n = 0 -- 177
	local inv = self.state.inventory -- 178
	do -- 178
		local i = 0 -- 179
		while i < #inv do -- 179
			n = n + inv[i + 1].count -- 179
			i = i + 1 -- 179
		end -- 179
	end -- 179
	return n -- 180
end -- 176
function GameDataManager.prototype.distinctTypeCount(self) -- 184
	local seen = {} -- 185
	local inv = self.state.inventory -- 186
	do -- 186
		local i = 0 -- 187
		while i < #inv do -- 187
			local t = inv[i + 1].type -- 188
			local found = false -- 189
			do -- 189
				local j = 0 -- 190
				while j < #seen do -- 190
					if seen[j + 1] == t then -- 190
						found = true -- 191
						break -- 191
					end -- 191
					j = j + 1 -- 190
				end -- 190
			end -- 190
			if not found then -- 190
				seen[#seen + 1] = t -- 193
			end -- 193
			i = i + 1 -- 187
		end -- 187
	end -- 187
	return #seen -- 195
end -- 184
function GameDataManager.prototype.typeNameList(self) -- 199
	local names = {} -- 200
	local inv = self.state.inventory -- 201
	do -- 201
		local i = 0 -- 202
		while i < #inv do -- 202
			local name = coinTypeName(inv[i + 1].type) -- 203
			local found = false -- 204
			do -- 204
				local j = 0 -- 205
				while j < #names do -- 205
					if names[j + 1] == name then -- 205
						found = true -- 206
						break -- 206
					end -- 206
					j = j + 1 -- 205
				end -- 205
			end -- 205
			if not found then -- 205
				names[#names + 1] = name -- 208
			end -- 208
			i = i + 1 -- 202
		end -- 202
	end -- 202
	local out = "" -- 210
	do -- 210
		local i = 0 -- 211
		while i < #names do -- 211
			if i > 0 then -- 211
				out = out .. "/" -- 212
			end -- 212
			out = out .. names[i + 1] -- 213
			i = i + 1 -- 211
		end -- 211
	end -- 211
	return out -- 215
end -- 199
function GameDataManager.prototype.randomInt(self, min, max) -- 219
	return math.floor(math.random() * (max - min + 1)) + min -- 220
end -- 219
function GameDataManager.prototype.dealCard(self) -- 224
	local pool = ____exports.GameDataManager.TARGET_POOL -- 225
	local target = pool[self:randomInt(0, #pool - 1) + 1] -- 226
	local card = { -- 227
		id = self.state.nextCardId, -- 228
		target = target, -- 229
		originalTarget = target, -- 230
		countdown = ____exports.GameDataManager.CARD_COUNTDOWN, -- 231
		frozen = false, -- 232
		healAmount = 0, -- 233
		copyArmed = false, -- 234
		coins = {}, -- 235
		eliminated = false, -- 236
		special = false, -- 237
		specialType = "" -- 238
	} -- 238
	local ____self_state_0, ____nextCardId_1 = self.state, "nextCardId" -- 238
	____self_state_0[____nextCardId_1] = ____self_state_0[____nextCardId_1] + 1 -- 240
	local ____self_state_cards_2 = self.state.cards -- 240
	____self_state_cards_2[#____self_state_cards_2 + 1] = card -- 241
end -- 224
function GameDataManager.prototype.dealInitialCards(self) -- 245
	while #self.state.cards < ____exports.GameDataManager.FIELD_CARD_COUNT do -- 245
		self:dealCard() -- 247
	end -- 247
end -- 245
function GameDataManager.prototype.findCard(self, cardId) -- 252
	local cards = self.state.cards -- 253
	do -- 253
		local i = 0 -- 254
		while i < #cards do -- 254
			if cards[i + 1].id == cardId then -- 254
				return cards[i + 1] -- 255
			end -- 255
			i = i + 1 -- 254
		end -- 254
	end -- 254
	return nil -- 257
end -- 252
function GameDataManager.prototype.removeCard(self, cardId) -- 261
	local cards = self.state.cards -- 262
	do -- 262
		local i = 0 -- 263
		while i < #cards do -- 263
			if cards[i + 1].id == cardId then -- 263
				__TS__ArraySplice(cards, i, 1) -- 264
				return -- 264
			end -- 264
			i = i + 1 -- 263
		end -- 263
	end -- 263
end -- 261
function GameDataManager.prototype.placeCoinOnCard(self, cardId, ____type, value) -- 269
	local card = self:findCard(cardId) -- 270
	if not card or card.eliminated then -- 270
		return false -- 271
	end -- 271
	if self:stackCount(____type, value) <= 0 then -- 271
		return false -- 272
	end -- 272
	if ____type == CoinType.Freeze then -- 272
		card.frozen = true -- 276
		self:consumeCoin(____type, value, 1) -- 277
		return true -- 278
	end -- 278
	if ____type == CoinType.Discount then -- 278
		self:applyDiscount(card, value) -- 281
		self:consumeCoin(____type, value, 1) -- 282
		return true -- 283
	end -- 283
	if ____type == CoinType.Heal then -- 283
		card.healAmount = card.healAmount + value -- 286
		self:consumeCoin(____type, value, 1) -- 287
		return true -- 288
	end -- 288
	if ____type == CoinType.Copy then -- 288
		card.copyArmed = true -- 291
		self:consumeCoin(____type, value, 1) -- 292
		return true -- 293
	end -- 293
	if ____type == CoinType.Wild then -- 293
		self:consumeCoin(____type, value, 1) -- 296
		self:eliminateCard(card) -- 297
		return true -- 298
	end -- 298
	local negative = value < 0 -- 303
	local op = "add" -- 304
	if ____type == CoinType.Multiply then -- 304
		op = negative and "div" or "mul" -- 305
	elseif negative then -- 305
		op = "sub" -- 306
	end -- 306
	local placed = { -- 307
		type = ____type, -- 307
		value = math.abs(value), -- 307
		op = op -- 307
	} -- 307
	local ____card_coins_3 = card.coins -- 307
	____card_coins_3[#____card_coins_3 + 1] = placed -- 308
	self:consumeCoin(____type, value, 1) -- 309
	return true -- 310
end -- 269
function GameDataManager.prototype.applyDiscount(self, card, percent) -- 314
	local p = percent -- 315
	if p < 0 then -- 315
		p = 0 -- 316
	end -- 316
	if p > ____exports.GameDataManager.DISCOUNT_MAX then -- 316
		p = ____exports.GameDataManager.DISCOUNT_MAX -- 317
	end -- 317
	card.target = math.max( -- 318
		1, -- 318
		math.floor(card.target * (100 - p) / 100 + 0.5) -- 318
	) -- 318
end -- 314
function GameDataManager.prototype.togglePlacedCoin(self, cardId, index) -- 322
	local card = self:findCard(cardId) -- 323
	if not card or index < 0 or index >= #card.coins then -- 323
		return -- 324
	end -- 324
	local c = card.coins[index + 1] -- 325
	if c.type == CoinType.Multiply then -- 325
		c.op = c.op == "mul" and "div" or "mul" -- 327
	else -- 327
		c.op = c.op == "sub" and "add" or "sub" -- 329
	end -- 329
end -- 322
function GameDataManager.prototype.removePlacedCoin(self, cardId, index) -- 334
	local card = self:findCard(cardId) -- 335
	if not card or index < 0 or index >= #card.coins then -- 335
		return false -- 336
	end -- 336
	local c = card.coins[index + 1] -- 337
	__TS__ArraySplice(card.coins, index, 1) -- 338
	local sign = (c.op == "sub" or c.op == "div") and -1 or 1 -- 340
	self:addCoin(c.type, c.value * sign, 1) -- 341
	return true -- 342
end -- 334
function GameDataManager.prototype.movePlacedCoin(self, fromCardId, index, toCardId) -- 346
	local from = self:findCard(fromCardId) -- 347
	local to = self:findCard(toCardId) -- 348
	if not from or not to or from == to or index < 0 or index >= #from.coins then -- 348
		return false -- 349
	end -- 349
	local c = from.coins[index + 1] -- 350
	__TS__ArraySplice(from.coins, index, 1) -- 351
	local ____to_coins_4 = to.coins -- 351
	____to_coins_4[#____to_coins_4 + 1] = c -- 352
	return true -- 353
end -- 346
function GameDataManager.prototype.evaluateCard(self, card) -- 357
	local total = 0 -- 358
	do -- 358
		local i = 0 -- 359
		while i < #card.coins do -- 359
			local c = card.coins[i + 1] -- 360
			if c.type == CoinType.Multiply then -- 360
				if c.op == "div" then -- 360
					total = c.value == 0 and total or math.floor(total / c.value) -- 363
				else -- 363
					total = total * c.value -- 365
				end -- 365
			else -- 365
				if c.op == "sub" then -- 365
					total = total - c.value -- 368
				else -- 368
					total = total + c.value -- 369
				end -- 369
			end -- 369
			i = i + 1 -- 359
		end -- 359
	end -- 359
	return total -- 372
end -- 357
function GameDataManager.prototype.confirmCard(self, cardId) -- 376
	local result = { -- 377
		ok = false, -- 378
		reason = "none", -- 379
		total = 0, -- 380
		target = 0, -- 381
		healGained = 0, -- 382
		copiedValue = 0 -- 383
	} -- 383
	local card = self:findCard(cardId) -- 385
	if not card then -- 385
		return result -- 386
	end -- 386
	result.target = card.target -- 387
	if card.eliminated then -- 387
		result.reason = "eliminated" -- 388
		return result -- 388
	end -- 388
	local total = self:evaluateCard(card) -- 389
	result.total = total -- 390
	if #card.coins == 0 then -- 390
		result.reason = "no_coin" -- 391
		return result -- 391
	end -- 391
	if total ~= card.target then -- 391
		result.reason = "mismatch" -- 392
		return result -- 392
	end -- 392
	local r = self:eliminateCard(card) -- 393
	result.ok = true -- 394
	result.reason = "ok" -- 395
	result.healGained = r.healGained -- 396
	result.copiedValue = r.copiedValue -- 397
	return result -- 398
end -- 376
function GameDataManager.prototype.eliminateCard(self, card) -- 402
	card.eliminated = true -- 403
	local ____self_state_5, ____eliminatedCount_6 = self.state, "eliminatedCount" -- 403
	____self_state_5[____eliminatedCount_6] = ____self_state_5[____eliminatedCount_6] + 1 -- 404
	local healGained = 0 -- 405
	if card.healAmount > 0 then -- 405
		healGained = card.healAmount -- 407
		self.state.hp = math.min(self.state.maxHp, self.state.hp + healGained) -- 408
	end -- 408
	local copiedValue = 0 -- 410
	if card.copyArmed then -- 410
		copiedValue = card.target -- 412
		self:addCoin(CoinType.Normal, copiedValue, 1) -- 413
	end -- 413
	self:removeCard(card.id) -- 415
	self:dealCard() -- 416
	self:checkWin() -- 417
	return {healGained = healGained, copiedValue = copiedValue} -- 418
end -- 402
function GameDataManager.prototype.endTurn(self) -- 422
	local ____self_state_7, ____turn_8 = self.state, "turn" -- 422
	____self_state_7[____turn_8] = ____self_state_7[____turn_8] + 1 -- 423
	local hpLost = 0 -- 424
	local expiredCount = 0 -- 425
	local cards = self.state.cards -- 426
	do -- 426
		local i = #cards - 1 -- 429
		while i >= 0 do -- 429
			do -- 429
				local card = cards[i + 1] -- 430
				if card.frozen then -- 430
					card.frozen = false -- 431
					goto __continue108 -- 431
				end -- 431
				card.countdown = card.countdown - 1 -- 432
				if card.countdown <= 0 then -- 432
					hpLost = hpLost + 1 -- 434
					expiredCount = expiredCount + 1 -- 435
					local ____self_state_9, ____hp_10 = self.state, "hp" -- 435
					____self_state_9[____hp_10] = ____self_state_9[____hp_10] - 1 -- 436
					__TS__ArraySplice(cards, i, 1) -- 437
				end -- 437
			end -- 437
			::__continue108:: -- 437
			i = i - 1 -- 429
		end -- 429
	end -- 429
	do -- 429
		local ci = 0 -- 442
		while ci < #cards do -- 442
			local card = cards[ci + 1] -- 443
			do -- 443
				local pi = 0 -- 444
				while pi < #card.coins do -- 444
					local pc = card.coins[pi + 1] -- 445
					if pc.type == CoinType.Growth then -- 445
						pc.value = math.min(____exports.GameDataManager.COIN_MAX_VALUE, pc.value * 2) -- 447
					end -- 447
					pi = pi + 1 -- 444
				end -- 444
			end -- 444
			ci = ci + 1 -- 442
		end -- 442
	end -- 442
	local inv = self.state.inventory -- 453
	do -- 453
		local i = #inv - 1 -- 454
		while i >= 0 do -- 454
			if inv[i + 1].type == CoinType.Disturb then -- 454
				__TS__ArraySplice(inv, i, 1) -- 455
			end -- 455
			i = i - 1 -- 454
		end -- 454
	end -- 454
	while #cards < ____exports.GameDataManager.FIELD_CARD_COUNT do -- 454
		self:dealCard() -- 459
	end -- 459
	local won = false -- 462
	local lost = false -- 463
	if self.state.hp <= 0 then -- 463
		self.state.hp = 0 -- 465
		self.state.status = "lost" -- 466
		lost = true -- 467
	else -- 467
		self:checkWin() -- 469
		won = self.state.status == "won" -- 470
	end -- 470
	return {hpLost = hpLost, expiredCount = expiredCount, won = won, lost = lost} -- 472
end -- 422
function GameDataManager.prototype.checkWin(self) -- 476
	if self.state.eliminatedCount >= self.state.targetCount and self.state.status == "playing" then -- 476
		self.state.status = self.state.level >= ____exports.GameDataManager.MAX_LEVEL and "complete" or "won" -- 478
	end -- 478
end -- 476
function GameDataManager.prototype.applyWinRewards(self) -- 483
	local gain = 50 + self.state.level * 10 -- 484
	local ____self_state_11, ____currency_12 = self.state, "currency" -- 484
	____self_state_11[____currency_12] = ____self_state_11[____currency_12] + gain -- 485
	self.currency = self.state.currency -- 486
	local r = self:randomRewardCoin() -- 487
	self:addCoin(r.type, r.value, 1) -- 488
	return {currency = gain, coinType = r.type, coinValue = r.value} -- 489
end -- 483
function GameDataManager.prototype.randomRewardCoin(self) -- 493
	local r = self:randomInt(1, 100) -- 494
	if r <= 60 then -- 494
		return { -- 495
			type = CoinType.Normal, -- 495
			value = self:randomInt(1, 10), -- 495
			count = 1 -- 495
		} -- 495
	end -- 495
	if r <= 80 then -- 495
		return { -- 496
			type = CoinType.Multiply, -- 496
			value = self:randomInt(2, 4), -- 496
			count = 1 -- 496
		} -- 496
	end -- 496
	local specials = {CoinType.Freeze, CoinType.Heal, CoinType.Growth, CoinType.Disturb} -- 497
	return { -- 498
		type = specials[self:randomInt(0, #specials - 1) + 1], -- 498
		value = 1, -- 498
		count = 1 -- 498
	} -- 498
end -- 493
function GameDataManager.prototype.coinCap(self, ____type) -- 504
	return ____type == CoinType.Discount and ____exports.GameDataManager.DISCOUNT_MAX or ____exports.GameDataManager.COIN_MAX_VALUE -- 505
end -- 504
function GameDataManager.prototype.synthesizeCoins(self, ____type, valueA, valueB) -- 509
	if self:stackCount(____type, valueA) < 1 then -- 509
		return {ok = false, resultValue = 0} -- 510
	end -- 510
	if valueA == valueB and self:stackCount(____type, valueA) < 2 then -- 510
		return {ok = false, resultValue = 0} -- 511
	end -- 511
	if valueA ~= valueB and self:stackCount(____type, valueB) < 1 then -- 511
		return {ok = false, resultValue = 0} -- 512
	end -- 512
	self:consumeCoin(____type, valueA, 1) -- 513
	self:consumeCoin(____type, valueB, 1) -- 514
	local sum = math.min( -- 515
		self:coinCap(____type), -- 515
		valueA + valueB -- 515
	) -- 515
	self:addCoin(____type, sum, 1) -- 516
	return {ok = true, resultValue = sum} -- 517
end -- 509
function GameDataManager.prototype.synthesizeOnce(self) -- 521
	do -- 521
		local t = 0 -- 522
		while t < #COIN_TYPE_ORDER do -- 522
			do -- 522
				local ____type = COIN_TYPE_ORDER[t + 1] -- 523
				local values = {} -- 524
				local inv = self.state.inventory -- 525
				do -- 525
					local i = 0 -- 526
					while i < #inv do -- 526
						if inv[i + 1].type == ____type then -- 526
							do -- 526
								local k = 0 -- 528
								while k < inv[i + 1].count do -- 528
									values[#values + 1] = inv[i + 1].value -- 528
									k = k + 1 -- 528
								end -- 528
							end -- 528
						end -- 528
						i = i + 1 -- 526
					end -- 526
				end -- 526
				if #values < 2 then -- 526
					goto __continue135 -- 531
				end -- 531
				local i1 = 0 -- 532
				local i2 = 1 -- 533
				if values[i2 + 1] < values[i1 + 1] then -- 533
					local tmp = i1 -- 534
					i1 = i2 -- 534
					i2 = tmp -- 534
				end -- 534
				do -- 534
					local i = 2 -- 535
					while i < #values do -- 535
						if values[i + 1] < values[i1 + 1] then -- 535
							i2 = i1 -- 536
							i1 = i -- 536
						elseif values[i + 1] < values[i2 + 1] then -- 536
							i2 = i -- 537
						end -- 537
						i = i + 1 -- 535
					end -- 535
				end -- 535
				local a = values[i1 + 1] -- 539
				local b = values[i2 + 1] -- 540
				local r = self:synthesizeCoins(____type, a, b) -- 541
				return { -- 542
					ok = r.ok, -- 542
					type = ____type, -- 542
					valueA = a, -- 542
					valueB = b, -- 542
					resultValue = r.resultValue -- 542
				} -- 542
			end -- 542
			::__continue135:: -- 542
			t = t + 1 -- 522
		end -- 522
	end -- 522
	return { -- 544
		ok = false, -- 544
		type = CoinType.Normal, -- 544
		valueA = 0, -- 544
		valueB = 0, -- 544
		resultValue = 0 -- 544
	} -- 544
end -- 521
function GameDataManager.prototype.deleteCoin(self, ____type, value, count) -- 548
	if self.deleteCredits < count then -- 548
		return {ok = false, reason = "删除次数不足"} -- 549
	end -- 549
	if not self:consumeCoin(____type, value, count) then -- 549
		return {ok = false, reason = "硬币不足"} -- 550
	end -- 550
	self.deleteCredits = self.deleteCredits - count -- 551
	return {ok = true, reason = ""} -- 552
end -- 548
function GameDataManager.prototype.deleteOnce(self) -- 556
	local inv = self.state.inventory -- 557
	if #inv == 0 then -- 557
		return {ok = false, type = CoinType.Normal, value = 0, reason = "背包为空"} -- 558
	end -- 558
	local st = inv[1] -- 559
	local r = self:deleteCoin(st.type, st.value, 1) -- 560
	return {ok = r.ok, type = st.type, value = st.value, reason = r.reason} -- 561
end -- 556
function GameDataManager.prototype.upgradeMaxHp(self) -- 565
	local cost = 100 -- 566
	if self.metaMaxHp >= ____exports.GameDataManager.MAX_HP then -- 566
		return {ok = false, cost = cost, newMaxHp = self.metaMaxHp, reason = "已达上限"} -- 567
	end -- 567
	if self.currency < cost then -- 567
		return {ok = false, cost = cost, newMaxHp = self.metaMaxHp, reason = "货币不足"} -- 568
	end -- 568
	self.currency = self.currency - cost -- 569
	self.state.currency = self.currency -- 570
	self.metaMaxHp = self.metaMaxHp + 1 -- 571
	self.state.maxHp = self.metaMaxHp -- 572
	return {ok = true, cost = cost, newMaxHp = self.metaMaxHp, reason = ""} -- 573
end -- 565
function GameDataManager.prototype.upgradeDeleteCredits(self) -- 577
	local cost = 80 -- 578
	if self.currency < cost then -- 578
		return {ok = false, cost = cost, newCredits = self.deleteCredits, reason = "货币不足"} -- 579
	end -- 579
	self.currency = self.currency - cost -- 580
	self.state.currency = self.currency -- 581
	self.deleteCredits = self.deleteCredits + 2 -- 582
	return {ok = true, cost = cost, newCredits = self.deleteCredits, reason = ""} -- 583
end -- 577
function GameDataManager.prototype.sweepLevel(self) -- 587
	if self.highestLevel < 2 then -- 587
		return { -- 588
			ok = false, -- 588
			currency = 0, -- 588
			coinType = CoinType.Normal, -- 588
			coinValue = 0, -- 588
			reason = "通关首关后开启" -- 588
		} -- 588
	end -- 588
	local gain = math.min(1000, self.highestLevel * 30) -- 589
	self.currency = self.currency + gain -- 590
	self.state.currency = self.currency -- 591
	local r = self:randomRewardCoin() -- 592
	self:addCoin(r.type, r.value, 1) -- 593
	return { -- 594
		ok = true, -- 594
		currency = gain, -- 594
		coinType = r.type, -- 594
		coinValue = r.value, -- 594
		reason = "" -- 594
	} -- 594
end -- 587
GameDataManager.START_HP = 2 -- 587
GameDataManager.MAX_LEVEL = 15 -- 587
GameDataManager.CARD_COUNTDOWN = 3 -- 587
GameDataManager.FIELD_CARD_COUNT = 3 -- 587
GameDataManager.COIN_MAX_VALUE = 999 -- 587
GameDataManager.DISCOUNT_MAX = 100 -- 587
GameDataManager.MAX_HP = 5 -- 587
GameDataManager.TARGET_POOL = { -- 587
	2, -- 26
	3, -- 26
	4, -- 26
	5, -- 26
	6, -- 26
	7, -- 26
	8, -- 26
	9, -- 26
	10, -- 26
	11, -- 26
	12, -- 26
	14, -- 26
	15, -- 26
	16, -- 26
	18, -- 26
	20, -- 26
	21, -- 26
	24, -- 26
	25, -- 26
	27, -- 26
	30 -- 26
} -- 26
return ____exports -- 26