## Session Summary

### Current Goal

按用户要求重做《灵术牌》UI 交互：加回硬币拖拽、放大数字与硬币（电脑屏幕上看得清），并修复"硬币点击没反应"。

### Recent Progress

- 已完成：场上卡牌 9→3（`FIELD_CARD_COUNT=3`、`CARD_ROWS=1`）；卡牌加长（`CARD_H` 220→300）；硬币槽放大（组 200×70→216×128、硬币半径 17→26、命中区 40→68）。
- 交互重构：移除 `touchLayer` 手写命中，改为**节点原生触摸事件**（按钮/卡牌/硬币芯片各自 `touchEnabled` + 事件）。卡牌点击已由用户确认可用。
- 诊断：`showDebug` 调试框截图确认硬币/卡牌命中框与视觉对齐（排除"错位"）；独立测试入口 `test-nested.ts` 验证嵌套未设尺寸父节点的世界坐标正确（center=110,220）。
- 本轮（进行中）：把硬币芯片与已放置硬币芯片改为**所属层直接子节点 + 绝对坐标**（与可用卡牌命中节点同构），并加回拖拽（`onTapBegan/Moved/Ended`，落点用 `node.convertToWorldSpace(t.location)`），放大卡牌目标数字 52→72、硬币半径 21→26、芯片文字 15→18、命中区 52→68；关闭 `showDebug`。已提交 5 处编辑（checkpoint 16），**尚未 build**。

### Open Issues

- 硬币点击"没反应"的根因未 100% 确认（疑为需先选卡牌 + 提示太小 + 缺拖拽）。
- 拖拽落点坐标换算（`convertToWorldSpace(t.location)`）未经实机验证。
- 触摸/拖拽真实手感无法在无头环境验证，需用户实机确认。

### Active Checkpoint

- 当前目标：完成"加回拖拽 + 放大数字/硬币"的改动并验证。
- 已完成：`game/GameUI.ts` 已提交 5 处编辑（import 加回 `Touch`；新增 `drag`/`dragGhost`/`dragStart`/`cardRects` 字段；`renderHud` 提示文案放大；`renderCards` 重置 `cardRects`；`buildCard` 重写为放大数字 + 已放置硬币芯片挂 cardLayer 绝对坐标并绑定拖拽事件）。**注意：`buildCoinGroup` 重写、`renderCoins` 尺寸/行列、`buildStatic` 底部面板、底部信息 y、以及新增拖拽辅助方法（`touchWorld`/`beginDrag`/`moveDrag`/`endDrag`/`cardAtPoint`/`makeGhost`/`hideGhost`）尚未提交**。
- 待办：删除临时文件 `test-nested.ts`。
- 最新验证结果：上一次 `build` 通过（4/4 文件），但那是本轮编辑之前的状态；本轮编辑后尚未 build。
- 已读/已改文件：`game/GameUI.ts`（已改）、`game/GameDataManager.ts`（已改 FIELD_CARD_COUNT）、`test-nested.ts`（临时，待删）。
- **Next tool**: `edit_file`（继续提交 `buildCoinGroup`/`renderCoins`/`buildStatic`/底部信息/拖拽辅助方法的编辑），随后 `build`。