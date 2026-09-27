// @preview-file on clear
// 《灵术牌》入口 —— 第二步：UI 节点树与卡牌/硬币预制体
import { Audio } from 'Dora';
import { GameDataManager } from 'game/GameDataManager';
import { GameUI } from 'game/GameUI';

const mgr = new GameDataManager();
const ui = new GameUI(mgr);
ui.refresh();

// 背景音乐：低调循环（黑暗奇幻 / 隐秘氛围）
Audio.playStream('Audio/bgm.ogg', true);
