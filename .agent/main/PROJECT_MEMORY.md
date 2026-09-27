## Project Memory

### Project Facts

- 项目名：《灵术牌》，Dora SSR 工作区游戏，源码为 TypeScript（`init.ts` + `game/*.ts`），引擎执行生成的 Lua（`init.lua` / `game/*.lua` 为产物，不要手改）。
- 玩法：场上卡牌带"目标数字"与倒计时，玩家把硬币拖到卡牌上组成算式，算式结果等于目标即可消除；"结束回合"扣减倒计时并结算胜负。

### Build And Run

- `build` 目标为 `.`；共 8 个 TS 文件（`init.ts`、`game/types.ts`、`game/GameDataManager.ts`、`game/GameUI.ts`、`game/SaveData.ts`、`Music/CoinSfx.ts`、`Music/CardSfx.ts`、`Music/Bgm.ts`）均需编译通过。
- 视觉验证用 `previewGame({entry="init.ts", captureAtSeconds={...}})` 截图后 `analyze_image` 检查。
- 命令环境（execute_command Lua）中 `Content` 只支持**项目相对路径**的 exist/isdir/getAttr/load（写操作不可用）；`Node` 沙箱不可用于变换测试，需用独立测试入口（如 `test-nested.ts` + `enterEntryAsync`）验证。

### Files And Architecture

- `init.ts`：入口，创建 `new GameDataManager()` 与 `new GameUI(mgr)`，调用 `ui.refresh()`。
- `game/types.ts`：`CoinType` 枚举、`Card`/`GameState`/`CoinStack` 等数据结构、`COIN_TYPE_ORDER`、`coinTypeName`。
- `game/GameDataManager.ts`：纯逻辑层（无论渲染节点）。关键常量 `START_HP`、`MAX_LEVEL=15`、`CARD_COUNTDOWN=3`、`FIELD_CARD_COUNT`（场上卡牌数，当前=3）、`levelTarget()`。
- `game/GameUI.ts`：渲染与交互层。设计尺寸 `DESIGN_W=720` / `DESIGN_H=1280`。分层：bgLayer/hudLayer/cardLayer/coinLayer/actionLayer/overlayLayer/fxLayer。卡牌网格 `CARD_COLS=3`、`CARD_ROWS=1` 一行三张；`CARD_W=200`、`CARD_H=300`。交互 = 节点原生触摸事件（每个可点击元素自己 `touchEnabled` + 事件）。
- `Music/CoinSfx.ts` + `Audio/coin.wav`：硬币放置音效；`Music/CardSfx.ts` + `Audio/card_paper.wav`：卡牌确认消除音效（均已把音量减半）；`Music/Bgm.ts` + `Audio/bgm.ogg`：黑暗奇幻氛围 BGM（连绵 `pad` 氛围垫音 + 极轻 `sine` 高音泛音、无打击乐、约 58s 循环）。**音色避坑**：早期用 `strings` 长音 + `pluck` 稀疏短音，听起来像断续的报错哔声，已改为连绵无空隙的 pad/sine。播放：放置成功→`playSfx('Audio/coin.wav')`；确认消除成功→`playSfx('Audio/card_paper.wav')`；`GameUI` 构造时用 `AudioSource('Audio/bgm.ogg')`（`looping=true`）播放循环 BGM。素材自身音量写在各自 `Music/*.ts` 的 `audio.volume` 里（可用外部同名文件直接覆盖）；运行时可调音量见下方「运行时音量控制」。

### 界面与存档

- `game/SaveData.ts`：存档（`Content.writablePath` 下的 `lingshu_save.txt`，`key=value` 文本，避免依赖 JSON），保存 `highestLevel` / `bgmVolume` / `sfxVolume`。
- `GameUI` 内置界面状态机 `screen: 'menu' | 'levels' | 'settings' | 'game'` + 最顶层 `screenLayer`；`refresh()` 按 screen 分发（非 game 时清空对局各层以避免叠层与点击穿透）。
- 主菜单：标题 + 开始游戏/设置/退出游戏；设置：BGM/音效各一组 −/＋ 按钮 + 百分比与音量条；选关：15 关蛇形连线地图（`GameDataManager.MAX_LEVEL`），`state.highestLevel` 为已解锁数，锁定节点不可点，点已解锁节点进入对应关卡。
- 对局内的 `确定` / `结束回合` 按钮改为每次进入对局时重建（`renderActionButtons`），以免残留在菜单界面上。
- 结算：`syncProgress()` 在 `status` 变为 `won`/`complete` 时 `unlockLevel(关卡+1)` 并存档；胜利 overlay 新增「选择关卡」按钮（`toLevels`）。

### Decisions

- 屏幕适配：`Camera2D.zoom = min(View.size.width/720, View.size.height/1280)`（letterbox），全屏背景在 `screenBgNode` 上按 `w/zoom × h/zoom` 重绘铺满信箱边；`Director.entry.onAppChange('Size')` 时重算。
- 交互用**节点原生触摸事件**：每个可点击元素（确定/结束回合按钮、卡牌命中节点、硬币芯片、弹窗按钮）自己 `touchEnabled = true` + `onTapped`（硬币芯片用 `onTapBegan/Moved/Ended` 支持拖拽），命中范围 = 节点自身 `size`（与视觉一致），由引擎按屏幕位置做命中检测（自动处理 Camera2D 缩放）。**不再手写坐标换算**：`touch.location` / `worldLocation` 在相机缩放下语义不确定，曾导致点击错位。
- 操作流程为**拖拽 + 点击**：把硬币芯片拖到某张卡牌上放置（**只有拖拽能放置**）；在硬币槽点击硬币会切换数值正负（背包按数值分组，取反后会移动到对应堆叠）；点卡牌上已放置硬币切换运算符（+/− 或 ×/÷）。点卡牌选中后可用"确定"消除；拖动已放置硬币到另一张卡牌可移动、拖到空白处则移除（归还背包时保留符号）。
- 数值正负由硬币的 `value` 符号承载（可为负）；`placeCoinOnCard` 时把符号转成运算符（负→−/÷，正→+/×，value 存绝对值）；`togglePlacedCoin` 切换运算符；`removePlacedCoin` 按运算符归还带符号的硬币。
- 拖拽落点换算用 `touch.worldLocation` 得到设计中心（世界）坐标，再用 `cardRects` 做矩形命中。
- **Dora 的 tap 手势会在指针移出节点后立即 `onTapEnded`**（实测拖拽只走了 ~50 设计单位就"自动释放"，日志 `drag end moved=25~58`，与硬币节点 68×68 边界吻合）。因此拖拽不能仅靠节点自身的 moved/ended 完成：`endDrag` 里若 `Mouse.leftButtonPressed` 仍为真，只标记 `dragEndedEarly` 并保留拖拽，由每帧轮询（`updater.schedule`）读 `Mouse.position` 继续跟随，松开时用 `Mouse.position` 换算落点完成放置。
- Dora 会把一次按下派发给**所有包含该点的可触摸节点**；相邻硬币命中区重叠会导致一次手势触发多次 `onTapBegan`，需在 `beginDrag` 里用 `if (this.drag) return` 去重。
- 所有可点击/拖拽的芯片（背包硬币、已放置硬币）都作为**所属层的直接子节点、用绝对坐标**（与卡牌命中节点同构），避免嵌在带非零 position 的未设尺寸父节点下。卡牌命中节点先加入 cardLayer，硬币芯片后加入，保证芯片在命中层之上。
- **运行时音量控制**：`Audio.play` / `Audio.playStream` 都没有音量参数、`Audio.globalVolume` 会影响全部音频，所以 BGM 改用 `AudioSource('Audio/bgm.ogg')`（`looping=true` + `volume`）播放并持有引用；音效改为 `playSfx(path)`（每次 `AudioSource(path)` + `volume = sfxVolume` + `addTo(fxLayer)` + `play()`）。音量存于存档并在设置页调整。
- 退出游戏用 `App.shutdown()`（`App.devMode` 为 true 时它只发出一个 `"Shutdown"` 全局事件，不会真正关闭引擎；Web IDE 下即如此）。
- `convertToNodeSpace` / `convertToWorldSpace` 实测均为左下角原点（范围 `[0,width]×[0,height]`，与 anchor 无关）；带非零 position 的未设尺寸父节点也会正确累加子节点世界坐标（独立测试入口验证：嵌套 center=110,220 正确）。
- **美术风格（紫罗兰暗金属，纯矢量绘制）**：项目无位图素材，全部用 `DrawNode` 绘制。调色板在 `GameUI.ts` 顶部 `C_*` / `C_GOLD*` 常量（深紫罗兰底 + 淡紫银描边 + 淡紫白文字；`C_GOLD*` 现为紫色系）；`coinColor()` 为紫色系金属色。辅助函数：`drawGrad`（竖直金属渐变）、`drawBand`（边缘框）、`drawStud`/`drawCorners`（菱形角饰）、`drawSheen`（高光带，现仅用于按钮）。背景为斜向菱格暗纹（`buildStatic` 内两组对角 `drawSegment`）。
- **TS→Lua 闭包陷阱（已踩坑）**：`for (let i...)` 会编译为 `local i = 0; while ... do ... i = i + 1 end`，`i` 是**单个共享变量**。在循环内注册、延迟执行的闭包（`onTapped/onTapBegan/...`）会在调用时读到 `i` 的最终值，导致 `stacks[i]` 为 nil 并抛错（表现为"点了没反应"，控制台有 `attempt to index a nil value`）。必须把闭包要用的值先存进循环体内新建的 `const` 局部变量（如 `const stack = stacks[i]`、`const idx = i`）；`const card = cards[i]` 这类每轮新建的局部变量是安全的。

### Known Issues

- letterbox 适配在"更宽"的窗口（宽高比 > 720:1280）下会左右留黑边、底部内容贴近下缘；属预期行为，非裁切。
- 「普通」硬币组初始有 5 个不同面值，同组并排时相邻硬币会轻微重叠（放大硬币的取舍）；其余组 1~2 枚。
- 当前美术为代码矢量绘制（项目无位图素材），"华丽感"有限：大面积纯色留白、卡牌为深色矩形+细金边、硬币较扁平。若要真正的雕花/纹理/材质，需引入 PNG/SVG 素材（本 Agent 无图像生成工具，且 `fetch_url` 在本环境不可用，需用户提供素材文件）。
- 新增的菜单/设置/选关三界面的**点击导航（按钮与关卡节点）无法在无头环境验证**（截图已确认三界面渲染正常、对局界面无回归）；存档 `save()` 的写入往返也未经运行时验证。
- 主菜单与选关页内容偏上、下方留白较多。