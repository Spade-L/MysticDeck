## Core Memory

### User Preferences

- 使用简体中文交流。
- 关注可玩性与可读性：要求交互"跟手"、判定范围清晰、数字/硬币在电脑屏幕上看得清。
- 偏好拖拽式操作（把硬币拖到卡牌上），但也接受点击式兜底。
- 美术偏好：古典华丽、暗沉金属色；当前要求整体色调改为**紫色系**、背景不要太空（要加纹样）、硬币高光透明度 10%。

### Stable Facts

- 项目《灵术牌》为 Dora SSR 工作区游戏，源码 TypeScript（`init.ts` + `game/*.ts` + `Music/*.ts`），引擎执行生成的 Lua（`*.lua` 为产物，不要手改）。
- 设计尺寸 720×1280（竖屏），适配用 `Camera2D.zoom = min(w/720, h/1280)`（letterbox）。
- 项目**没有任何位图美术素材**，界面全部用 `DrawNode` 矢量绘制；本 Agent **没有图像生成工具**，`fetch_url` 在本环境损坏（连 example.com 都报 `failed to move downloaded file into target path`），无法下载外部素材。

### Known Decisions

- 交互采用**节点原生触摸事件**（每个可点击元素自己 `touchEnabled` + `onTapped`/`onTapBegan/Moved/Ended`），命中范围 = 节点 `size` = 视觉，由引擎做命中检测；不再手写坐标换算。
- 拖拽落点用 `touch.worldLocation`（世界=设计中心坐标）与 `cardRects` 比对；但 Dora 的 tap 手势会在指针移出节点后立即 `onTapEnded`，故拖拽必须配合每帧轮询 `Mouse.leftButtonPressed`/`Mouse.position` 续接（见 PROJECT_MEMORY）。
- 场上卡牌 3 张（一行三张）。
- 音效：硬币放置 `Audio.play('Audio/coin.wav')`；卡牌确认消除 `Audio.play('Audio/card_paper.wav')`；两个 wav 均由引擎内置合成器生成，可用外部同名文件覆盖。

### Known Issues

- 触摸/拖拽的真实手感无法在无头环境验证，需实机确认。
- 横屏窗口下 letterbox 左右留白（预期行为）。
- 纯矢量绘制难以做到真正的"雕花华丽"（大面积留白、卡牌为深色矩形+细边、硬币较扁平）；若要材质/纹理需用户提供 PNG/SVG 素材。
- `game/GameUI.ts` 里仍保留有界的 `[ui]` 调试打印（BEGIN/MOVE/END/FLIP），待用户确认后清理。