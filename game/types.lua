-- [ts]: types.ts
local ____exports = {} -- 1
____exports.CoinType = ____exports.CoinType or ({}) -- 4
____exports.CoinType.Normal = "normal" -- 5
____exports.CoinType.Multiply = "multiply" -- 6
____exports.CoinType.Freeze = "freeze" -- 7
____exports.CoinType.Discount = "discount" -- 8
____exports.CoinType.Copy = "copy" -- 9
____exports.CoinType.Wild = "wild" -- 10
____exports.CoinType.Growth = "growth" -- 11
____exports.CoinType.Heal = "heal" -- 12
____exports.CoinType.Disturb = "disturb" -- 13
____exports.COIN_TYPE_ORDER = { -- 17
	____exports.CoinType.Normal, -- 18
	____exports.CoinType.Multiply, -- 19
	____exports.CoinType.Freeze, -- 20
	____exports.CoinType.Discount, -- 21
	____exports.CoinType.Copy, -- 22
	____exports.CoinType.Wild, -- 23
	____exports.CoinType.Growth, -- 24
	____exports.CoinType.Heal, -- 25
	____exports.CoinType.Disturb -- 26
} -- 26
function ____exports.coinTypeName(____type) -- 30
	repeat -- 30
		local ____switch3 = ____type -- 30
		local ____cond3 = ____switch3 == ____exports.CoinType.Normal -- 30
		if ____cond3 then -- 30
			return "普通" -- 32
		end -- 32
		____cond3 = ____cond3 or ____switch3 == ____exports.CoinType.Multiply -- 32
		if ____cond3 then -- 32
			return "乘法" -- 33
		end -- 33
		____cond3 = ____cond3 or ____switch3 == ____exports.CoinType.Freeze -- 33
		if ____cond3 then -- 33
			return "冰冻" -- 34
		end -- 34
		____cond3 = ____cond3 or ____switch3 == ____exports.CoinType.Discount -- 34
		if ____cond3 then -- 34
			return "折扣" -- 35
		end -- 35
		____cond3 = ____cond3 or ____switch3 == ____exports.CoinType.Copy -- 35
		if ____cond3 then -- 35
			return "复制" -- 36
		end -- 36
		____cond3 = ____cond3 or ____switch3 == ____exports.CoinType.Wild -- 36
		if ____cond3 then -- 36
			return "万能" -- 37
		end -- 37
		____cond3 = ____cond3 or ____switch3 == ____exports.CoinType.Growth -- 37
		if ____cond3 then -- 37
			return "增长" -- 38
		end -- 38
		____cond3 = ____cond3 or ____switch3 == ____exports.CoinType.Heal -- 38
		if ____cond3 then -- 38
			return "回复" -- 39
		end -- 39
		____cond3 = ____cond3 or ____switch3 == ____exports.CoinType.Disturb -- 39
		if ____cond3 then -- 39
			return "干扰" -- 40
		end -- 40
		do -- 40
			return "未知" -- 41
		end -- 41
	until true -- 41
end -- 30
return ____exports -- 30