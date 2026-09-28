-- [ts]: GameArt.ts
local ____exports = {} -- 1
local ____Dora = require("Dora") -- 3
local Color = ____Dora.Color -- 3
local Content = ____Dora.Content -- 3
local Director = ____Dora.Director -- 3
local DrawNode = ____Dora.DrawNode -- 3
local Label = ____Dora.Label -- 3
local Node = ____Dora.Node -- 3
local Path = ____Dora.Path -- 3
local RenderTarget = ____Dora.RenderTarget -- 3
local Vec2 = ____Dora.Vec2 -- 3
local thread = ____Dora.thread -- 3
local C_BG = Color(14, 11, 20, 255) -- 6
local C_GOLD = Color(160, 136, 200, 255) -- 7
local C_GOLD_BRIGHT = Color(226, 214, 252, 255) -- 8
local C_GOLD_DARK = Color(84, 66, 112, 255) -- 9
local C_GOLD_TEXT = Color(206, 190, 244, 255) -- 10
local C_DIM = Color(172, 158, 196, 255) -- 11
local C_BADGE = Color(18, 14, 26, 255) -- 12
local function rectVerts(cx, cy, w, h) -- 14
	return { -- 15
		Vec2(cx - w / 2, cy - h / 2), -- 16
		Vec2(cx + w / 2, cy - h / 2), -- 17
		Vec2(cx + w / 2, cy + h / 2), -- 18
		Vec2(cx - w / 2, cy + h / 2) -- 19
	} -- 19
end -- 14
local function lerpC(a, b, t) -- 23
	return Color( -- 24
		math.floor(a[1] + (b[1] - a[1]) * t + 0.5), -- 25
		math.floor(a[2] + (b[2] - a[2]) * t + 0.5), -- 26
		math.floor(a[3] + (b[3] - a[3]) * t + 0.5), -- 27
		math.floor(a[4] + (b[4] - a[4]) * t + 0.5) -- 28
	) -- 28
end -- 23
local function grad(d, cx, cy, w, h, top, bottom) -- 32
	local steps = 28 -- 33
	local x0 = cx - w / 2 -- 34
	local x1 = cx + w / 2 -- 35
	do -- 35
		local i = 0 -- 36
		while i < steps do -- 36
			local yT = cy + h / 2 - h * (i / steps) -- 37
			local yB = cy + h / 2 - h * ((i + 1) / steps) -- 38
			d:drawPolygon( -- 39
				{ -- 39
					Vec2(x0, yT), -- 39
					Vec2(x1, yT), -- 39
					Vec2(x1, yB), -- 39
					Vec2(x0, yB) -- 39
				}, -- 39
				lerpC(top, bottom, (i + 0.5) / steps), -- 39
				0 -- 39
			) -- 39
			i = i + 1 -- 36
		end -- 36
	end -- 36
end -- 32
local function band(d, cx, cy, w, h, t, color) -- 43
	d:drawPolygon( -- 44
		rectVerts(cx, cy + h / 2 - t / 2, w, t), -- 44
		color, -- 44
		0 -- 44
	) -- 44
	d:drawPolygon( -- 45
		rectVerts(cx, cy - h / 2 + t / 2, w, t), -- 45
		color, -- 45
		0 -- 45
	) -- 45
	d:drawPolygon( -- 46
		rectVerts(cx - w / 2 + t / 2, cy, t, h - 2 * t), -- 46
		color, -- 46
		0 -- 46
	) -- 46
	d:drawPolygon( -- 47
		rectVerts(cx + w / 2 - t / 2, cy, t, h - 2 * t), -- 47
		color, -- 47
		0 -- 47
	) -- 47
end -- 43
local function stud(d, x, y, r, color) -- 50
	d:drawPolygon( -- 51
		{ -- 51
			Vec2(x, y + r), -- 51
			Vec2(x + r, y), -- 51
			Vec2(x, y - r), -- 51
			Vec2(x - r, y) -- 51
		}, -- 51
		color, -- 51
		0 -- 51
	) -- 51
end -- 50
local function corners(d, cx, cy, w, h, inset, r, color) -- 54
	local hx = w / 2 - inset -- 55
	local hy = h / 2 - inset -- 56
	stud( -- 57
		d, -- 57
		cx - hx, -- 57
		cy + hy, -- 57
		r, -- 57
		color -- 57
	) -- 57
	stud( -- 58
		d, -- 58
		cx + hx, -- 58
		cy + hy, -- 58
		r, -- 58
		color -- 58
	) -- 58
	stud( -- 59
		d, -- 59
		cx - hx, -- 59
		cy - hy, -- 59
		r, -- 59
		color -- 59
	) -- 59
	stud( -- 60
		d, -- 60
		cx + hx, -- 60
		cy - hy, -- 60
		r, -- 60
		color -- 60
	) -- 60
end -- 54
local function diamonds(d, halfW, halfH, step, color) -- 64
	local n = math.ceil((halfW + halfH) / step) + 1 -- 65
	do -- 65
		local i = -n -- 66
		while i <= n do -- 66
			local x = i * step -- 67
			d:drawSegment( -- 68
				Vec2(x, -halfH), -- 68
				Vec2(x + halfH * 2, halfH), -- 68
				1, -- 68
				color -- 68
			) -- 68
			d:drawSegment( -- 69
				Vec2(x, halfH), -- 69
				Vec2(x + halfH * 2, -halfH), -- 69
				1, -- 69
				color -- 69
			) -- 69
			i = i + 1 -- 66
		end -- 66
	end -- 66
end -- 64
local function text(parent, s, x, y, size, color) -- 73
	local l = Label("sarasa-mono-sc-regular", size) -- 74
	if l then -- 74
		l.text = s -- 76
		l.position = Vec2(x, y) -- 77
		l.anchor = Vec2(0.5, 0.5) -- 78
		l.color = color -- 79
		l:addTo(parent) -- 80
	end -- 80
end -- 73
local function cardFace(d, cx, cy, w, h, bright) -- 85
	grad( -- 86
		d, -- 86
		cx, -- 86
		cy, -- 86
		w, -- 86
		h, -- 86
		{72, 56, 96, 255}, -- 86
		{30, 23, 42, 255} -- 86
	) -- 86
	band( -- 87
		d, -- 87
		cx, -- 87
		cy, -- 87
		w, -- 87
		h, -- 87
		4, -- 87
		C_GOLD_DARK -- 87
	) -- 87
	band( -- 88
		d, -- 88
		cx, -- 88
		cy, -- 88
		w, -- 88
		h, -- 88
		1.5, -- 88
		bright and C_GOLD_BRIGHT or C_GOLD -- 88
	) -- 88
	band( -- 89
		d, -- 89
		cx, -- 89
		cy, -- 89
		w - 14, -- 89
		h - 14, -- 89
		1, -- 89
		C_GOLD_DARK -- 89
	) -- 89
	corners( -- 90
		d, -- 90
		cx, -- 90
		cy, -- 90
		w, -- 90
		h, -- 90
		14, -- 90
		7, -- 90
		C_GOLD_BRIGHT -- 90
	) -- 90
end -- 85
local function medallion(d, cx, cy, r) -- 94
	d:drawDot( -- 95
		Vec2(cx, cy), -- 95
		r, -- 95
		C_GOLD -- 95
	) -- 95
	d:drawDot( -- 96
		Vec2(cx, cy), -- 96
		r - 6, -- 96
		C_BADGE -- 96
	) -- 96
	d:drawDot( -- 97
		Vec2(cx, cy), -- 97
		r - 10, -- 97
		C_GOLD_DARK -- 97
	) -- 97
	stud( -- 98
		d, -- 98
		cx, -- 98
		cy, -- 98
		r * 0.52, -- 98
		C_GOLD_BRIGHT -- 98
	) -- 98
	d:drawDot( -- 99
		Vec2(cx - r * 0.34, cy + r * 0.34), -- 99
		r * 0.15, -- 99
		Color(242, 236, 255, 150) -- 99
	) -- 99
end -- 94
local function buildIcon() -- 103
	local S = 512 -- 104
	local half = S / 2 -- 105
	local rt = RenderTarget(S, S) -- 106
	local root = Node() -- 107
	root.position = Vec2(S / 2, S / 2) -- 109
	local d = DrawNode() -- 110
	d:drawPolygon( -- 112
		rectVerts(0, 0, S, S), -- 112
		C_BG, -- 112
		0 -- 112
	) -- 112
	diamonds( -- 113
		d, -- 113
		half, -- 113
		half, -- 113
		64, -- 113
		Color(38, 30, 54, 255) -- 113
	) -- 113
	band( -- 114
		d, -- 114
		0, -- 114
		0, -- 114
		S - 14, -- 114
		S - 14, -- 114
		6, -- 114
		C_GOLD_DARK -- 114
	) -- 114
	band( -- 115
		d, -- 115
		0, -- 115
		0, -- 115
		S - 14, -- 115
		S - 14, -- 115
		2, -- 115
		C_GOLD -- 115
	) -- 115
	corners( -- 116
		d, -- 116
		0, -- 116
		0, -- 116
		S - 14, -- 116
		S - 14, -- 116
		26, -- 116
		11, -- 116
		C_GOLD_BRIGHT -- 116
	) -- 116
	d:addTo(root) -- 117
	cardFace( -- 119
		d, -- 119
		0, -- 119
		46, -- 119
		200, -- 119
		268, -- 119
		true -- 119
	) -- 119
	medallion(d, 0, 66, 64) -- 120
	stud( -- 122
		d, -- 122
		0, -- 122
		214, -- 122
		11, -- 122
		C_GOLD_BRIGHT -- 122
	) -- 122
	stud( -- 123
		d, -- 123
		-40, -- 123
		214, -- 123
		7, -- 123
		C_GOLD -- 123
	) -- 123
	stud( -- 124
		d, -- 124
		40, -- 124
		214, -- 124
		7, -- 124
		C_GOLD -- 124
	) -- 124
	text( -- 126
		root, -- 126
		"灵术牌", -- 126
		0, -- 126
		-168, -- 126
		54, -- 126
		C_GOLD_TEXT -- 126
	) -- 126
	d:drawSegment( -- 127
		Vec2(-70, -206), -- 127
		Vec2(70, -206), -- 127
		1, -- 127
		C_GOLD_DARK -- 127
	) -- 127
	local out = Path(Content.searchPaths[1], "Art", "icon.png") -- 129
	Content:remove(out) -- 130
	rt:renderWithClear(root, C_BG) -- 131
	rt:saveAsync(out) -- 132
end -- 103
local function buildCover() -- 136
	local W = 1280 -- 137
	local H = 720 -- 138
	local rt = RenderTarget(W, H) -- 139
	local root = Node() -- 140
	root.position = Vec2(W / 2, H / 2) -- 142
	local d = DrawNode() -- 143
	d:drawPolygon( -- 145
		rectVerts(0, 0, W, H), -- 145
		C_BG, -- 145
		0 -- 145
	) -- 145
	diamonds( -- 146
		d, -- 146
		W / 2, -- 146
		H / 2, -- 146
		96, -- 146
		Color(38, 30, 54, 255) -- 146
	) -- 146
	band( -- 147
		d, -- 147
		0, -- 147
		0, -- 147
		W - 30, -- 147
		H - 30, -- 147
		8, -- 147
		C_GOLD_DARK -- 147
	) -- 147
	band( -- 148
		d, -- 148
		0, -- 148
		0, -- 148
		W - 30, -- 148
		H - 30, -- 148
		2, -- 148
		C_GOLD -- 148
	) -- 148
	corners( -- 149
		d, -- 149
		0, -- 149
		0, -- 149
		W - 30, -- 149
		H - 30, -- 149
		46, -- 149
		14, -- 149
		C_GOLD_BRIGHT -- 149
	) -- 149
	d:addTo(root) -- 150
	text( -- 153
		root, -- 153
		"灵 术 牌", -- 153
		0, -- 153
		190, -- 153
		132, -- 153
		C_GOLD_TEXT -- 153
	) -- 153
	text( -- 154
		root, -- 154
		"暗 影 术 法 · 卡 牌 消 除", -- 154
		0, -- 154
		88, -- 154
		34, -- 154
		C_DIM -- 154
	) -- 154
	d:drawSegment( -- 155
		Vec2(-260, 40), -- 155
		Vec2(260, 40), -- 155
		2, -- 155
		C_GOLD_DARK -- 155
	) -- 155
	d:drawSegment( -- 156
		Vec2(-220, 40), -- 156
		Vec2(220, 40), -- 156
		1, -- 156
		C_GOLD -- 156
	) -- 156
	stud( -- 157
		d, -- 157
		0, -- 157
		40, -- 157
		12, -- 157
		C_GOLD_BRIGHT -- 157
	) -- 157
	stud( -- 158
		d, -- 158
		-260, -- 158
		40, -- 158
		7, -- 158
		C_GOLD -- 158
	) -- 158
	stud( -- 159
		d, -- 159
		260, -- 159
		40, -- 159
		7, -- 159
		C_GOLD -- 159
	) -- 159
	cardFace( -- 162
		d, -- 162
		-190, -- 162
		-140, -- 162
		160, -- 162
		230, -- 162
		false -- 162
	) -- 162
	cardFace( -- 163
		d, -- 163
		190, -- 163
		-140, -- 163
		160, -- 163
		230, -- 163
		false -- 163
	) -- 163
	cardFace( -- 164
		d, -- 164
		0, -- 164
		-110, -- 164
		190, -- 164
		270, -- 164
		true -- 164
	) -- 164
	medallion(d, 0, -80, 60) -- 165
	medallion(d, -330, -190, 30) -- 168
	medallion(d, 330, -190, 30) -- 169
	medallion(d, -330, -60, 22) -- 170
	medallion(d, 330, -60, 22) -- 171
	text( -- 174
		root, -- 174
		"拖拽硬币 · 组成算式 · 消除卡牌", -- 174
		0, -- 174
		-300, -- 174
		26, -- 174
		C_GOLD_TEXT -- 174
	) -- 174
	local out = Path(Content.searchPaths[1], "Art", "cover.png") -- 176
	Content:remove(out) -- 177
	rt:renderWithClear(root, C_BG) -- 178
	rt:saveAsync(out) -- 179
end -- 136
local function buildPortraitCover() -- 183
	local W = 1080 -- 184
	local H = 1920 -- 185
	local rt = RenderTarget(W, H) -- 186
	local root = Node() -- 187
	root.position = Vec2(W / 2, H / 2) -- 188
	local d = DrawNode() -- 189
	d:drawPolygon( -- 191
		rectVerts(0, 0, W, H), -- 191
		C_BG, -- 191
		0 -- 191
	) -- 191
	diamonds( -- 192
		d, -- 192
		W / 2, -- 192
		H / 2, -- 192
		130, -- 192
		Color(38, 30, 54, 255) -- 192
	) -- 192
	band( -- 193
		d, -- 193
		0, -- 193
		0, -- 193
		W - 44, -- 193
		H - 44, -- 193
		12, -- 193
		C_GOLD_DARK -- 193
	) -- 193
	band( -- 194
		d, -- 194
		0, -- 194
		0, -- 194
		W - 44, -- 194
		H - 44, -- 194
		3, -- 194
		C_GOLD -- 194
	) -- 194
	corners( -- 195
		d, -- 195
		0, -- 195
		0, -- 195
		W - 44, -- 195
		H - 44, -- 195
		72, -- 195
		22, -- 195
		C_GOLD_BRIGHT -- 195
	) -- 195
	d:addTo(root) -- 196
	text( -- 199
		root, -- 199
		"灵 术 牌", -- 199
		0, -- 199
		640, -- 199
		220, -- 199
		C_GOLD_TEXT -- 199
	) -- 199
	text( -- 200
		root, -- 200
		"暗 影 术 法 · 卡 牌 消 除", -- 200
		0, -- 200
		476, -- 200
		56, -- 200
		C_DIM -- 200
	) -- 200
	d:drawSegment( -- 201
		Vec2(-420, 396), -- 201
		Vec2(420, 396), -- 201
		3, -- 201
		C_GOLD_DARK -- 201
	) -- 201
	d:drawSegment( -- 202
		Vec2(-360, 396), -- 202
		Vec2(360, 396), -- 202
		1.5, -- 202
		C_GOLD -- 202
	) -- 202
	stud( -- 203
		d, -- 203
		0, -- 203
		396, -- 203
		20, -- 203
		C_GOLD_BRIGHT -- 203
	) -- 203
	stud( -- 204
		d, -- 204
		-420, -- 204
		396, -- 204
		12, -- 204
		C_GOLD -- 204
	) -- 204
	stud( -- 205
		d, -- 205
		420, -- 205
		396, -- 205
		12, -- 205
		C_GOLD -- 205
	) -- 205
	cardFace( -- 208
		d, -- 208
		-310, -- 208
		-260, -- 208
		340, -- 208
		480, -- 208
		false -- 208
	) -- 208
	cardFace( -- 209
		d, -- 209
		310, -- 209
		-260, -- 209
		340, -- 209
		480, -- 209
		false -- 209
	) -- 209
	cardFace( -- 210
		d, -- 210
		0, -- 210
		-180, -- 210
		460, -- 210
		660, -- 210
		true -- 210
	) -- 210
	medallion(d, 0, -120, 140) -- 211
	medallion(d, -420, 300, 56) -- 214
	medallion(d, 420, 300, 56) -- 215
	medallion(d, -420, -780, 46) -- 216
	medallion(d, 420, -780, 46) -- 217
	text( -- 219
		root, -- 219
		"拖拽硬币 · 组成算式 · 消除卡牌", -- 219
		0, -- 219
		-880, -- 219
		40, -- 219
		C_GOLD_TEXT -- 219
	) -- 219
	local out = Path(Content.searchPaths[1], "Art", "cover_portrait.png") -- 221
	Content:remove(out) -- 222
	rt:renderWithClear(root, C_BG) -- 223
	rt:saveAsync(out) -- 224
end -- 183
local scene = Node() -- 228
scene:addTo(Director.entry) -- 229
scene:schedule(function() -- 230
	thread(function() -- 232
		buildIcon() -- 233
		buildCover() -- 234
		buildPortraitCover() -- 235
	end) -- 232
	return true -- 237
end) -- 230
return ____exports -- 230