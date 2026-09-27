<div align="center">

<!-- Dora logo 及官网链接 -->
<a href="https://dora-ssr.com/">
  <img src="https://dora-ssr.com/logo.png" alt="Dora SSR Logo" width="100">
</a>

<h1>灵术牌 (MysticDeck)</h1>

<!-- 开源标签及 LICENSE 链接 -->
<a href="LICENSE">
  <img src="https://img.shields.io/badge/License-AGPL--3.0--only-blue.svg" alt="AGPL-3.0-only License">
</a>

<!-- QQ 群标签及社群链接（点击图片可加群） -->
<a href="https://qm.qq.com/q/512620381">
  <img src="https://img.shields.io/badge/QQ_Group-512620381-12B7F5.svg" alt="QQ Group 512620381">
</a>

</div>

## 🎮 游戏介绍
**正式名称**：灵术牌 (MysticDeck)
**玩法与目标**：这是一款隐蔽的西幻风格数字消除卡牌策略游戏。玩家需要将底部带有数字的“硬币”拖拽到“卡牌”上，通过加减乘除运算匹配卡牌数字进行消除。玩家需在有限回合内消除指定数量卡牌以获取胜利。游戏内含9种特殊硬币（冰冻、折扣、万能、复制、增长、回复等），并结合了局外硬币合成与强化系统。
**特色**：将传统数字算术与策略卡牌构筑相结合，回合制结算带来紧张刺激的生存挑战。

## 📦 项目内容
本项目主要包含以下源码与资源：
- **核心源码**：`game/` 目录（包括 `GameDataManager.ts` 核心逻辑与 `GameUI.ts` 交互逻辑），以及 `Music/` 目录下的音频控制代码。
- **游戏资源**：`Audio/` 目录（包含 `bgm.ogg` 背景音乐、`card_paper.wav` 和 `coin.wav` 音效）、`vision/` 目录下的视觉资源与脚本。
- **工具与文档**：`.agent/` 目录（Agent 配置文件与会话记录）、`README.md`、`LICENSE`。

## 🚀 运行方法
**Dora SSR 版本**：最新稳定版（Dora SSR 开源游戏引擎）。
**源码入口**：项目根目录下的 `game/GameDataManager.ts` 与 `game/GameUI.ts` 为游戏主逻辑入口，`Music/Bgm.ts` 为音频启动入口。
**依赖与启动步骤**：
1. 从 AtomGit 克隆本项目到本地。
2. 打开 Dora SSR 引擎客户端。
3. 在引擎工作空间中选择“导入本地项目”，定位到克隆下来的 `MysticDeck` 文件夹。
4. 点击运行即可启动项目。

## 🌐 Web 版本
**HTML 导出包**：我们在 Release 附件（或项目根目录）中提供了 Web 版导出包，文件名为：**【MysticDeck_Web.zip】**（请根据实际生成的 ZIP 文件名修改此处）。
**打开方法**：
1. 下载 `MysticDeck_Web.zip` 压缩包并解压到本地任意文件夹。
2. 双击解压后目录中的 `index.html` 文件（或运行本地 Web 服务器），即可在电脑浏览器中直接游玩。

## 🕹️ 操作说明
- **电脑按键/鼠标**：使用鼠标左键点击并拖拽硬币，放置到卡牌上；点击界面的“确定”与“结束回合”按钮进行操作。无需使用键盘。
- **手机触控**：使用手指长按并拖拽硬币至卡牌，点击界面按钮进行确认。
- **已测设备**：Windows 10/11 (PC 端 Dora SSR 引擎运行)、现代浏览器（Web 导出包运行）。

## 📄 开源说明
本作品由 **SpadeL** 创作，使用 Dora SSR 开发，参与原子派社区小游戏征集活动。

- **原创代码开源许可**：本项目原创代码采用 **AGPL-3.0-only** 许可协议发布，详细许可条款请查阅根目录下的 [LICENSE](LICENSE) 文件。
- **发布与展示平台**：原子派 [https://atompie.osgame.org/](https://atompie.osgame.org/)
- **引擎**：Dora SSR [https://dora-ssr.com/](https://dora-ssr.com/)
- **活动**：原子派社区小游戏征集活动
- **社群交流**：QQ 群 512620381，加群链接：[点击加入](https://qm.qq.com/q/512620381)
- **版权信息**：Copyright (C) 2026 SpadeL
- **第三方素材说明**：项目内引用的所有第三方音效与素材均保留其原始许可与署名，并确保符合其使用和分发条件。
