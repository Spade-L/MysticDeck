## Project Memory

### Project Facts

- 项目名：《灵术牌》，Dora SSR 工作区游戏，源码为 TypeScript（`init.ts` + `game/*.ts` + `Music/*.ts`），引擎执行生成的 Lua（`*.lua` 为产物，不要手改）。
- 玩法：场上卡牌带"目标数字"与倒计时，玩家把硬币拖到卡牌上组成算式，算式结果等于目标即可消除；"结束回合"扣减倒计时并结算胜负。

### Build And Run

- `build` 目标为 `.`；共 9 个 TS 文件（`init.ts`、`game/types.ts`、`game/GameDataManager.ts`、`game/GameUI.ts`、`game/SaveData.ts`、`Music/CoinSfx.ts`、`Music/CardSfx.ts`、`Music/Bgm.ts`、`Art/GameArt.ts`）均需编译通过。
- 视觉验证用 `previewGame({entry="init.ts", captureAtSeconds={...}})` 截图后 `analyze_image` 检查（每轮有 capture/analysis 预算上限）。
- 命令环境（execute_command Lua）中 `Content` 只支持**项目相对路径**的 exist/isdir/getAttr/load（写操作不可用）；`Node` 沙箱不可用于变换测试，需用独立测试入口（如 `test-*.ts` + `enterEntryAsync`）验证；命令环境里 `Audio:play` 返回 0（无游戏运行时音频被挂起），需在真实入口里验证。
- 音频生成：`Music/*.ts` 定义 `MusicDefinition`，`build` 后用 `requireProjectModule("Music.X")` + `requireProjectModule("Agent.Gen.Music").generateMusicAsync(projectDir, definition, {onProgress=reportProgress})` 生成 wav。

### Files And Architecture

- `init.ts`：入口，创建 `new GameDataManager()` 与 `new GameUI(mgr)`，调用 `ui.refresh()`。
- `game/types.ts`：`CoinType` 枚举、`Card`/`GameState`/`CoinStack` 等数据结构、`COIN_TYPE_ORDER`、`coinTypeName`。
- `game/GameDataManager.ts`：纯逻辑层（无论渲染节点）。关键常量 `START_HP`、`MAX_LEVEL=15`、`CARD_COUNTDOWN=3`、`FIELD_CARD_COUNT`（场上卡牌数，当前=3）、`levelTarget()`。含 `flipCoinSign(type,value)`（背包硬币数值取反并合并堆叠）、`placeCoinOnCard`（按 value 符号决定 op：负→−/÷，正→+/×，value 存绝对值）、`togglePlacedCoin`、`removePlacedCoin`（按 op 还原符号归还）、`movePlacedCoin`。
- `game/GameUI.ts`：渲染与交互层。设计尺寸 `DESIGN_W=720` / `DESIGN_H=1280`。分层：bgLayer/hudLayer/cardLayer/coinLayer/actionLayer/overlayLayer/fxLayer。卡牌网格 `CARD_COLS=3`、`CARD_ROWS=1` 一行三张；`CARD_W=200`、`CARD_H=300`。交互=节点原生触摸事件；拖拽由 `updater` 每帧轮询 `Mouse` 续接。
- `Music/CoinSfx.ts` + `Audio/coin.wav`：硬币放置音效；`Music/CardSfx.ts` + `Audio/card_paper.wav`：卡牌确认消除音效（均为引擎内置合成器 `generateMusicAsync` 生成）。播放：放置成功→`Audio.play('Audio/coin.wav')`；确认消除成功→`Audio.play('Audio/card_paper.wav')`。可直接用外部音效覆盖同名 wav。

### 界面与存档

- `game/SaveData.ts`：存档（`Content.writablePath` 下的 `lingshu_save.txt`，`key=value` 文本），保存 `highestLevel` / `bgmVolume` / `sfxVolume`。
- `GameUI` 内置界面状态机 `screen: 'menu' | 'levels' | 'settings' | 'game'` + 最顶层 `screenLayer`；`refresh()` 按 screen 分发。
- 主菜单/设置/选关/养成（`screen: 'menu'|'levels'|'settings'|'meta'|'game'`；15 关蛇形地图，选关页与胜利 overlay 都有「养成」入口）；对局内只有「结束回合」按钮（**已删除「确定」**）每次进入对局重建；结算 `syncProgress()` 解锁下一关并存档。
- **对局规则（当前）**：硬币循环 = 硬币槽（`state.inventory`）+ 预备槽（`reserve` 队列）。`consumeCoin()` 用掉的硬币只 push 到预备槽末尾（使用时**不补牌**）；`refillHand()` 在 `endTurn()` 第 4.5 步从预备槽前端补满到 `HAND_SIZE=12`。`startLevel()` → `resetCoinCycle()`：基础(12)+购买的基础+技能+额外硬币**全部打乱**后发 12 枚（技能硬币只 `skillsSeeded` 种一次，靠 `extraCoins()` 循环携带，否则每关重发会把池子灌爆）。**结束回合会自动消除算式匹配的卡牌**（`endTurn()` 第 0 步）。卡牌 3 回合到期→销毁 + 扣 1 血。难度：`POOL_LOW/MID/HIGH` 按关卡分层（<7 / 7–11 / ≥12）+ 同屏大牌限制。通关奖励 = **关卡数 × 100**。养成可花 100 货币买 1/2/3/5/10/50 点基础硬币（`buyBaseCoin`）。

### 美术资源生成（图标 / 封面）

- `Art/GameArt.ts`：矢量绘制导出 PNG 的图标/封面生成器。运行：`enterEntryAsync({ fileName: "Art/GameArt.ts" })`；产物 `Art/icon.png`、`Art/cover.png`、`Art/cover_portrait.png`。每次生成前先 `Content.remove` 旧图。
- 踩坑：`RenderTarget.saveAsync` 必须在 `thread()` 协程里调用；RenderTarget 原点在左下角（根节点 position 设 `Vec2(w/2,h/2)`）；`saveAsync` 不覆盖已存在文件。

### Decisions

- 屏幕适配：`Camera2D.zoom = min(View.size.width/720, View.size.height/1280)`（letterbox），全屏背景在 `screenBgNode` 上按 `w/zoom × h/zoom` 重绘铺满信箱边；`Director.entry.onAppChange('Size')` 时重算。
- 交互用**节点原生触摸事件**：每个可点击元素自己 `touchEnabled = true` + `onTapped`（硬币芯片用 `onTapBegan/Moved/Ended`），命中范围 = 节点自身 `size`，由引擎按屏幕位置做命中检测（自动处理 Camera2D 缩放）。**不再手写坐标换算**。
- 操作流程为**拖拽 + 点击**：把硬币芯片拖到某张卡牌上放置（**只有拖拽能放置**）；在硬币槽点击硬币会切换数值正负（按数值分组，取反后并入对应堆叠）；点卡牌上已放置硬币切换运算符（+/− 或 ×/÷）。**卡牌不使用「确定」按钮**：点「结束回合」时自动消除算式匹配的卡牌；拖动已放置硬币到另一张卡牌可移动、拖到空白处则移除（归还背包时保留符号）。
- 数值正负由硬币的 `value` 符号承载（可为负）；`placeCoinOnCard` 时把符号转成运算符（负→−/÷，正→+/×，value 存绝对值）；`togglePlacedCoin` 切换运算符；`removePlacedCoin` 按运算符归还带符号的硬币。
- 拖拽落点换算用 `touch.worldLocation` 得到设计中心（世界）坐标，再用 `cardRects` 做矩形命中。
- **Dora 的 tap 手势会在指针移出节点后立即 `onTapEnded`**（实测拖拽只走了 ~50 设计单位就"自动释放"，日志 `drag end moved=25~58`，与硬币节点 68×68 边界吻合）。因此拖拽不能仅靠节点自身的 moved/ended 完成：`endDrag` 里若 `Mouse.leftButtonPressed` 仍为真，只标记 `dragEndedEarly` 并保留拖拽，由每帧轮询（`updater.schedule`）读 `Mouse.position` 继续跟随，松开时用 `Mouse.position` 换算落点完成放置。
- Dora 会把一次按下派发给**所有包含该点的可触摸节点**；相邻硬币命中区重叠会导致一次手势触发多次 `onTapBegan`，需在 `beginDrag` 里用 `if (this.drag) return` 去重。
- 所有可点击/拖拽的芯片（背包硬币、已放置硬币）都作为**所属层的直接子节点、用绝对坐标**（与卡牌命中节点同构）。卡牌命中节点先加入 cardLayer，硬币芯片后加入，保证芯片在命中层之上。
- `convertToNodeSpace` / `convertToWorldSpace` 实测均为左下角原点（范围 `[0,width]×[0,height]`，与 anchor 无关）；带非零 position 的未设尺寸父节点也会正确累加子节点世界坐标。
- **TS→Lua 闭包陷阱（已踩坑）**：`for (let i...)` 会编译为 `local i = 0; while ... do ... i = i + 1 end`，`i` 是**单个共享变量**。在循环内注册、延迟执行的闭包（`onTapped/onTapBegan/...`）会在调用时读到 `i` 的最终值，导致 `stacks[i]` 为 nil 并抛错（表现为"点了没反应"，控制台有 `attempt to index a nil value`）。必须把闭包要用的值先存进循环体内新建的 `const` 局部变量（如 `const stack = stacks[i]`、`const idx = i`）；`const card = cards[i]` 这类每轮新建的局部变量是安全的。
- **美术风格（古典暗金属，纯矢量绘制）**：项目无位图素材，全部用 `DrawNode` 绘制。调色板在 `GameUI.ts` 顶部 `C_*` / `C_GOLD*` 常量（当前为**紫色系**：深紫罗兰底 + 淡紫银描边 + 淡紫白文字；`C_GOLD*` 现为紫罗兰金属色）；`coinColor()` 为低饱和金属色（用于区分硬币类型）。辅助函数：`drawGrad`（竖直金属渐变）、`drawBand`（边缘框）、`drawStud`/`drawCorners`（菱形角饰）、`drawSheen`（顶部高光带）。面板/卡牌/按钮 = 渐变 + 双金边 + 角饰 + 高光；背景加斜向菱格暗纹避免大面积纯色。

### Known Issues

- letterbox 适配在"更宽"的窗口（宽高比 > 720:1280）下会左右留黑边、底部内容贴近下缘；属预期行为，非裁切。
- 「普通」硬币组初始有 5 个不同面值，同组并排时相邻硬币会轻微重叠（放大硬币的取舍）；其余组 1~2 枚。
- 当前美术为代码矢量绘制（项目无位图素材），"华丽感"有限：大面积纯色留白、卡牌为深色矩形+细金边、硬币较扁平。若要真正的雕花/纹理/材质，需引入 PNG/SVG 素材（本 Agent 无图像生成工具，且 `fetch_url` 不可用，需用户提供素材文件）。
- 新增的菜单/设置/选关三界面的**点击导航（按钮与关卡节点）无法在无头环境验证**（截图已确认三界面渲染正常、对局界面无回归）；存档 `save()` 的写入往返也未经运行时验证。
- 主菜单与选关页内容偏上、下方留白较多。