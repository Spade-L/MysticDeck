<a href="https://dora-ssr.net/">
  <img src="https://dora-ssr.net/img/site/dora.svg" alt="Dora SSR" width="96" />
</a>

# 灵术牌

[![License: AGPL-3.0-only](https://img.shields.io/badge/License-AGPL--3.0--only-527A35?style=for-the-badge)](LICENSE)
[![Dora SSR QQ 群：512620381](https://img.shields.io/badge/QQ%E7%BE%A4-512620381-12B7F5?style=for-the-badge&logo=qq&logoColor=white)](https://qm.qq.com/q/VnzYhvCDgy)
[![Discord](https://img.shields.io/badge/Discord-%E5%8A%A0%E5%85%A5%E9%A2%91%E9%81%93-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/ZfNBSKXnf9)

将硬币拖拽到卡牌上，通过加减乘除运算消除卡牌，在限定回合内挑战更高关卡。

本作品使用 **[Dora SSR](https://dora-ssr.net/)** 游戏引擎开发，参与原子派社区小游戏征集活动。

**发布与展示平台：[原子派](https://atompie.osgame.org/)**  
**活动页面：[社区小游戏征集活动](https://atompie.osgame.org/events/minigame-2026)**

## 游戏介绍

- **核心目标：** 在限定回合内，消除指定数量的卡牌即可通关。回合结束时未消除的卡牌会扣除玩家血量，血量归零则游戏失败。
- **操作方式：** 拖拽底部硬币到上方卡牌，匹配运算结果后点击结束回合消除。
- **玩法特色：** 游戏包含 9 种功能各异的特殊硬币（如冰冻、折扣、万能、复制、增长、回复等），打破纯计算的枯燥感；结合局外硬币合成（上限 999）与属性强化系统，提升长线可玩性。
- **画面与声音：** 采用隐秘的风格，配有极简的氛围背景音乐与操作音效。
- **作者／团队：** SpadeL。

| 操作 | 键鼠 | 触屏 |
| --- | --- | --- |
| 移动硬币 | 鼠标左键点击并拖拽 | 手指长按并拖拽 |
| 确认消除 | 点击“结束回合”按钮 | 点击“结束回合”按钮 |

## 开发环境

- 引擎：Dora SSR **1.9.3** 或最新稳定版。
- 编程语言：TypeScript。
- 官方文档：https://dora-ssr.net/docs/tutorial/quick-start/
- 引擎源码：https://github.com/IppClub/Dora-SSR

## 运行项目

1. 启动 Dora SSR，打开引擎显示的 Web IDE 地址。
2. 将本仓库完整源码放入 Dora SSR 工作空间的独立项目目录。
3. 打开根目录入口 `init.ts` 并运行，代码无需额外编译。
4. 保留 `game/`、`Music/`、`Audio/`、`vision/` 等资源的相对位置。项目不需要 API Key、账号登录或外部服务。

## Web（HTML）版本与测试

- **导出方法：** 在 Dora SSR Web IDE 打开项目文件，点击快捷操作栏的“打包”按钮，在弹窗中选择“导出 HTML”。
- **已测试 Web 版本：** [灵术牌-web-html.zip](灵术牌-web-html.zip)，游戏代码与本仓库一致。
- **启动方法：** 完整解压后打开根目录 `index.html`，保留所有配套资源。
- **测试环境：** Windows 10 桌面、Edge 浏览器。
- **测试结果：** 已验证基础移动、消除、硬币合成及回合结算功能。
- **范围：** 当前为单人可玩原型，手机真机多点触控及长期数值平衡尚未完整验证。

## 项目内容

```text
game/                         游戏逻辑、界面、程序化绘制、字体与音频
Music/                        背景音乐与音效控制脚本
Audio/                        音频资源文件
vision/                       美术与视觉资源
init.ts                       Dora 项目入口
LICENSE                       AGPL-3.0-only 全文
灵术牌-web-html.zip            已测试的完整 HTML 导出包
