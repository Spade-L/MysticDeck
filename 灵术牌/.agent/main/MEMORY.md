## Core Memory

### User Preferences

- 使用简体中文交流。
- 关注可玩性与可读性：要求交互"跟手"、判定范围清晰、数字/硬币在电脑屏幕上看得清。
- 偏好拖拽式操作（把硬币拖到卡牌上），但也接受点击式兜底。

### Stable Facts

- 项目《灵术牌》为 Dora SSR 工作区游戏，源码 TypeScript（`init.ts` + `game/*.ts`），引擎执行生成的 Lua（`init.lua`/`game/*.lua` 为产物，不要手改）。
- 设计尺寸 720×1280（竖屏），适配用 `Camera2D.zoom = min(w/720, h/1280)`（letterbox）。

### Known Decisions

- 交互采用**节点原生触摸事件**（每个可点击元素自己 `touchEnabled` + `onTapped`/`onTapBegan/Moved/Ended`），命中范围 = 节点 `size` = 视觉，由引擎做命中检测；不再手写坐标换算。
- 拖拽落点用 `node.convertToWorldSpace(touch.location)` 换算到世界（=设计中心）坐标，再与卡牌矩形比对。
- 场上卡牌 3 张（一行三张）。

### Known Issues

- 触摸/拖拽的真实手感无法在无头环境验证，需实机确认。
- 横屏窗口下 letterbox 左右留白（预期行为）。