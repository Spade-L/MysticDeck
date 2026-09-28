// 《灵术牌》UI 层 —— 第二步：节点树、卡牌/硬币预制体、全屏比例适配
import { App, AudioSource, Color, Director, DrawNode, Label, Mouse, Node, Size, Touch, TypeName, Vec2, View, tolua } from 'Dora';
import { Card, CoinStack, CoinType, COIN_TYPE_ORDER, coinTypeName } from 'game/types';
import { GameDataManager } from 'game/GameDataManager';
import { SaveFile } from 'game/SaveData';

// 设计尺寸（逻辑坐标系，所有 UI 都在此坐标系内布局）
export const DESIGN_W = 720;
export const DESIGN_H = 1280;

// 卡牌网格参数（一行三张）
const CARD_COLS = 3;
const CARD_ROWS = 1;
const CARD_W = 200;
const CARD_H = 300;
const CARD_GAP_X = 14;
const CARD_GAP_Y = 14;

// 颜色常量（古典暗金属 · 紫色系：深紫罗兰底 + 淡紫银描边 + 淡紫白文字）
const C_BG: Color.Type = Color(14, 11, 20, 255);
const C_PANEL: Color.Type = Color(32, 24, 44, 255);
const C_PANEL_BORDER: Color.Type = Color(96, 76, 130, 255);
const C_CARD: Color.Type = Color(32, 24, 44, 255);
const C_CARD_BORDER: Color.Type = Color(152, 128, 192, 255);
const C_GROUP: Color.Type = Color(36, 27, 50, 255);
const C_TEXT: Color.Type = Color(228, 222, 244, 255);
const C_TEXT_DIM: Color.Type = Color(172, 158, 196, 255);
const C_TEXT_FAINT: Color.Type = Color(206, 190, 242, 255);
const C_DANGER: Color.Type = Color(198, 78, 112, 255);
const C_CONFIRM: Color.Type = Color(124, 98, 168, 255);
const C_CONFIRM_BORDER: Color.Type = Color(216, 200, 248, 255);
const C_ENDTURN: Color.Type = Color(88, 66, 120, 255);
const C_BADGE: Color.Type = Color(18, 14, 26, 255);
const C_GOLD: Color.Type = Color(160, 136, 200, 255);
const C_GOLD_BRIGHT: Color.Type = Color(226, 214, 252, 255);
const C_GOLD_DARK: Color.Type = Color(84, 66, 112, 255);
const C_GOLD_TEXT: Color.Type = Color(206, 190, 244, 255);

// 硬币类型对应的颜色（紫色系金属：同色相、不同明度/冷暖区分）
function coinColor(type: CoinType): Color.Type {
  switch (type) {
    case CoinType.Normal: return Color(170, 148, 214, 255);
    case CoinType.Multiply: return Color(200, 126, 196, 255);
    case CoinType.Freeze: return Color(126, 152, 216, 255);
    case CoinType.Discount: return Color(146, 116, 190, 255);
    case CoinType.Copy: return Color(202, 132, 176, 255);
    case CoinType.Wild: return Color(222, 202, 250, 255);
    case CoinType.Growth: return Color(118, 172, 196, 255);
    case CoinType.Heal: return Color(148, 192, 182, 255);
    case CoinType.Disturb: return Color(190, 98, 130, 255);
    default: return Color(160, 150, 190, 255);
  }
}

// 硬币芯片显示文本（按类型显示有意义的符号/数值）
function coinChipText(type: CoinType, value: number): string {
  switch (type) {
    case CoinType.Freeze: return '冻';
    case CoinType.Discount: return value + '%';
    case CoinType.Copy: return '复';
    case CoinType.Wild: return '万';
    case CoinType.Heal: return (value >= 0 ? '+' : '') + value;
    case CoinType.Growth: return '' + value;
    case CoinType.Normal:
    case CoinType.Multiply:
    case CoinType.Disturb:
    default: return '' + value;
  }
}

// 以中心点为基准的矩形顶点
function rectVerts(cx: number, cy: number, w: number, h: number): Vec2.Type[] {
  return [
    Vec2(cx - w / 2, cy - h / 2),
    Vec2(cx + w / 2, cy - h / 2),
    Vec2(cx + w / 2, cy + h / 2),
    Vec2(cx - w / 2, cy + h / 2),
  ];
}

// 颜色插值（用于金属渐变）
function lerpC(a: number[], b: number[], t: number): Color.Type {
  return Color(
    Math.round(a[0] + (b[0] - a[0]) * t),
    Math.round(a[1] + (b[1] - a[1]) * t),
    Math.round(a[2] + (b[2] - a[2]) * t),
    Math.round(a[3] + (b[3] - a[3]) * t),
  );
}

// 竖直金属渐变（用多条横带近似）
function drawGrad(d: DrawNode.Type, cx: number, cy: number, w: number, h: number, top: number[], bottom: number[]): void {
  const steps = 14;
  const x0 = cx - w / 2;
  const x1 = cx + w / 2;
  for (let i = 0; i < steps; i++) {
    const yT = cy + h / 2 - h * (i / steps);
    const yB = cy + h / 2 - h * ((i + 1) / steps);
    d.drawPolygon([Vec2(x0, yT), Vec2(x1, yT), Vec2(x1, yB), Vec2(x0, yB)], lerpC(top, bottom, (i + 0.5) / steps), 0);
  }
}

// 菱形饰钉
function drawStud(d: DrawNode.Type, x: number, y: number, r: number, color: Color.Type): void {
  d.drawPolygon([Vec2(x, y + r), Vec2(x + r, y), Vec2(x, y - r), Vec2(x - r, y)], color, 0);
}

// 沿矩形边缘画一圈框
function drawBand(d: DrawNode.Type, cx: number, cy: number, w: number, h: number, band: number, color: Color.Type): void {
  d.drawPolygon(rectVerts(cx, cy + h / 2 - band / 2, w, band), color, 0);
  d.drawPolygon(rectVerts(cx, cy - h / 2 + band / 2, w, band), color, 0);
  d.drawPolygon(rectVerts(cx - w / 2 + band / 2, cy, band, h - 2 * band), color, 0);
  d.drawPolygon(rectVerts(cx + w / 2 - band / 2, cy, band, h - 2 * band), color, 0);
}

// 四角菱形装饰
function drawCorners(d: DrawNode.Type, cx: number, cy: number, w: number, h: number, inset: number, r: number, color: Color.Type): void {
  const hx = w / 2 - inset;
  const hy = h / 2 - inset;
  drawStud(d, cx - hx, cy + hy, r, color);
  drawStud(d, cx + hx, cy + hy, r, color);
  drawStud(d, cx - hx, cy - hy, r, color);
  drawStud(d, cx + hx, cy - hy, r, color);
}

// 顶部高光（金属反光带，用透明浅色模拟镜面反射）
function drawSheen(d: DrawNode.Type, cx: number, cy: number, w: number, h: number, alpha: number): void {
  const inset = 8;
  const iw = w - inset * 2;
  d.drawPolygon(rectVerts(cx, cy + h / 2 - h * 0.20, iw, h * 0.16), Color(240, 234, 255, alpha), 0);
  d.drawPolygon(rectVerts(cx, cy + h / 2 - h * 0.34, iw * 0.72, h * 0.05), Color(246, 240, 255, alpha), 0);
}

// 便捷创建居中文本
function makeLabel(
  parent: Node.Type,
  text: string,
  x: number,
  y: number,
  size: number,
  color: Color.Type,
  anchor?: Vec2.Type,
): Label.Type | undefined {
  const l = Label('sarasa-mono-sc-regular', size);
  if (!l) return undefined;
  l.text = text;
  l.position = Vec2(x, y);
  l.anchor = anchor ? anchor : Vec2(0.5, 0.5);
  l.color = color;
  l.addTo(parent);
  return l;
}

export class GameUI {
  // 按钮矩形（供后续交互使用）
  confirmBtn = { x: 290, y: 568, w: 110, h: 44 };
  endTurnBtn = { x: 0, y: -20, w: 170, h: 44 };

  private mgr: GameDataManager;
  private screenBgNode: Node.Type;
  private screenDraw: DrawNode.Type;
  private gameRoot: Node.Type;
  private bgLayer: Node.Type;
  private hudLayer: Node.Type;
  private cardLayer: Node.Type;
  private coinLayer: Node.Type;
  private actionLayer: Node.Type;
  private overlayLayer: Node.Type;
  private fxLayer: Node.Type;
  private updater: Node.Type;
  private selectedCardId: number | undefined;
  private hintText = '';
  private drag: { kind: 'inventory' | 'placed'; cardId: number; index: number; type: CoinType; value: number } | undefined;
  private dragGhost: Node.Type | undefined;
  private dragStart: Vec2.Type | undefined;
  private dragEndedEarly = false;
  private cardRects: { id: number; x: number; y: number; w: number; h: number }[] = [];
  private rewardsApplied = false;
  private lastReward: { currency: number; coinType: CoinType; coinValue: number } | undefined;
  private metaOpen = false;
  private metaMessage = '';
  private viewZoom = 1;
  private dbg = 0;
  private lastMoveLog = 0;
  // ===== 界面状态与设置 =====
  private screenLayer: Node.Type;
  private screen: 'menu' | 'levels' | 'settings' | 'meta' | 'game' = 'menu';
  private settingsBack: 'menu' | 'levels' = 'menu';
  private save: SaveFile;
  private bgmSource: AudioSource.Type | undefined;
  private bgmVolume = 0.5;
  private sfxVolume = 0.8;

  private log(msg: string): void {
    if (this.dbg < 120) {
      this.dbg++;
      print('[ui] ' + msg);
    }
  }

  constructor(mgr: GameDataManager) {
    this.mgr = mgr;

    // 全屏背景（不缩放，铺满包括信箱边在内的整个窗口）
    this.screenBgNode = Node();
    this.screenDraw = DrawNode();
    this.screenDraw.addTo(this.screenBgNode);
    this.screenBgNode.addTo(Director.entry);

    // 游戏内容根（按设计尺寸缩放）
    this.gameRoot = Node();
    this.gameRoot.addTo(Director.entry);

    this.bgLayer = Node();
    this.hudLayer = Node();
    this.cardLayer = Node();
    this.coinLayer = Node();
    this.actionLayer = Node();
    this.overlayLayer = Node();
    this.fxLayer = Node();
    this.bgLayer.addTo(this.gameRoot);
    this.hudLayer.addTo(this.gameRoot);
    this.cardLayer.addTo(this.gameRoot);
    this.coinLayer.addTo(this.gameRoot);
    this.actionLayer.addTo(this.gameRoot);
    this.overlayLayer.addTo(this.gameRoot);
    this.fxLayer.addTo(this.gameRoot);
    // 菜单/设置/选关界面层（最顶层）
    this.screenLayer = Node();
    this.screenLayer.addTo(this.gameRoot);

    // 每帧轮询：处理“拖动手势提前结束”的情况（指针仍按下则继续跟随，松开时落下）
    this.updater = Node();
    this.updater.addTo(this.gameRoot);
    this.updater.schedule(() => {
      this.tick();
      return false;
    });

    this.buildStatic();
    this.updateScale();

    // 存档与音量设置
    this.save = new SaveFile();
    this.bgmVolume = this.save.bgmVolume;
    this.sfxVolume = this.save.sfxVolume;
    this.mgr.unlockLevel(this.save.highestLevel);

    // 背景音乐：用 AudioSource 播放，便于运行时调音量（playStream 无音量参数）
    const bgm = AudioSource('Audio/bgm.ogg', false);
    if (bgm) {
      bgm.looping = true;
      bgm.volume = this.bgmVolume;
      bgm.addTo(this.gameRoot);
      bgm.play();
      this.bgmSource = bgm;
    }

    // 窗口尺寸变化时重新适配
    Director.entry.onAppChange((name) => {
      if (name === 'Size') this.updateScale();
    });
  }

  // 根据当前窗口比例缩放摄像机，保证 720x1280 设计区域完整可见。
  // 使用 Camera2D.zoom 而非节点 scale：引擎会把相机缩放自动应用到触摸坐标换算。
  private updateScale(): void {
    const w = View.size.width;
    const h = View.size.height;
    const zoom = Math.min(w / DESIGN_W, h / DESIGN_H);
    this.viewZoom = zoom;
    const camera = tolua.cast(Director.currentCamera, TypeName.Camera2D);
    if (camera) {
      camera.zoom = zoom;
    }

    // 重绘全屏背景，铺满相机可见范围（含信箱边）
    const vw = w / zoom;
    const vh = h / zoom;
    this.screenDraw.clear();
    this.screenDraw.drawPolygon(
      [Vec2(-vw / 2, -vh / 2), Vec2(vw / 2, -vh / 2), Vec2(vw / 2, vh / 2), Vec2(-vw / 2, vh / 2)],
      C_BG,
      0,
    );
  }

  // 构建静态元素（背景纹样、面板、按钮）
  private buildStatic(): void {
    const d = DrawNode();
    // 背景：深紫底 + 斜向菱格暗纹（避免大面积纯色）
    d.drawPolygon(rectVerts(0, 0, DESIGN_W, DESIGN_H), C_BG, 0);
    const pattern = Color(44, 34, 62, 255);
    for (let i = -10; i <= 26; i++) {
      const x = i * 72;
      d.drawSegment(Vec2(x, -640), Vec2(x + 1280, 640), 1, pattern);
      d.drawSegment(Vec2(x, 640), Vec2(x + 1280, -640), 1, pattern);
    }

    // 顶部卡牌面板：金属渐变 + 紫银框 + 角饰
    drawGrad(d, 0, 250, 664, 380, [54, 41, 74, 255], [24, 18, 34, 255]);
    drawBand(d, 0, 250, 664, 380, 4, C_GOLD_DARK);
    drawBand(d, 0, 250, 664, 380, 1, C_GOLD);
    drawBand(d, 0, 250, 648, 364, 1, Color(84, 66, 112, 255));
    drawCorners(d, 0, 250, 664, 380, 12, 8, C_GOLD_BRIGHT);
    drawCorners(d, 0, 250, 664, 380, 26, 5, C_GOLD);

    // 底部硬币面板
    drawGrad(d, 0, -412, 664, 432, [54, 41, 74, 255], [24, 18, 34, 255]);
    drawBand(d, 0, -412, 664, 432, 4, C_GOLD_DARK);
    drawBand(d, 0, -412, 664, 432, 1, C_GOLD);
    drawBand(d, 0, -412, 648, 416, 1, Color(84, 66, 112, 255));
    drawCorners(d, 0, -412, 664, 432, 12, 8, C_GOLD_BRIGHT);
    drawCorners(d, 0, -412, 664, 432, 26, 5, C_GOLD);

    // 顶部装饰：分隔线 + 顶端装饰带（金线 + 菱形）
    d.drawSegment(Vec2(-332, 465), Vec2(332, 465), 2, C_GOLD_DARK);
    d.drawSegment(Vec2(-300, 465), Vec2(300, 465), 1, C_GOLD);
    drawStud(d, 0, 465, 9, C_GOLD_BRIGHT);
    drawStud(d, -170, 465, 5, C_GOLD);
    drawStud(d, 170, 465, 5, C_GOLD);
    d.drawSegment(Vec2(-190, 620), Vec2(190, 620), 1, C_GOLD_DARK);
    drawStud(d, 0, 620, 7, C_GOLD);
    drawStud(d, -190, 620, 5, C_GOLD);
    drawStud(d, 190, 620, 5, C_GOLD);

    // 中段（卡牌区与硬币区之间）：按钮两侧的装饰线，填补空白
    d.drawSegment(Vec2(-300, -20), Vec2(-120, -20), 1, C_GOLD_DARK);
    d.drawSegment(Vec2(120, -20), Vec2(300, -20), 1, C_GOLD_DARK);
    drawStud(d, -300, -20, 6, C_GOLD);
    drawStud(d, -120, -20, 4, C_GOLD);
    drawStud(d, 120, -20, 4, C_GOLD);
    drawStud(d, 300, -20, 6, C_GOLD);

    d.addTo(this.bgLayer);
  }

  // 根据当前界面/游戏状态刷新动态内容
  refresh(): void {
    if (this.screen === 'game') {
      if (this.selectedCardId !== undefined) {
        const c = this.mgr.findCard(this.selectedCardId);
        if (!c || c.eliminated) this.selectedCardId = undefined;
      }
      this.screenLayer.removeAllChildren();
      this.updateOverlay();
      this.renderHud();
      this.renderCards();
      this.renderCoins();
      this.renderActionButtons();
      return;
    }
    // 非对局界面：清空对局各层（包括其中的可点击节点），再渲染界面
    this.hudLayer.removeAllChildren();
    this.cardLayer.removeAllChildren();
    this.coinLayer.removeAllChildren();
    this.overlayLayer.removeAllChildren();
    this.actionLayer.removeAllChildren();
    this.renderScreen();
  }

  // 对局内的常驻按钮（每次进入对局重建，避免菜单界面上残留）
  // 已删除「确定」：改为「结束回合」时自动消除算式匹配的卡牌
  private renderActionButtons(): void {
    this.actionLayer.removeAllChildren();
    this.makeButton(this.endTurnBtn, '结束回合', [132, 106, 172, 255], [74, 55, 100, 255], Color(234, 226, 250, 255), () => this.doEndTurn());
  }

  // ===== 主界面 / 设置 / 选关 =====

  private renderScreen(): void {
    this.screenLayer.removeAllChildren();
    const d = DrawNode();
    d.drawPolygon(rectVerts(0, 0, DESIGN_W, DESIGN_H), C_BG, 0);
    const pattern = Color(44, 34, 62, 255);
    for (let i = -10; i <= 26; i++) {
      const x = i * 72;
      d.drawSegment(Vec2(x, -640), Vec2(x + 1280, 640), 1, pattern);
      d.drawSegment(Vec2(x, 640), Vec2(x + 1280, -640), 1, pattern);
    }
    d.addTo(this.screenLayer);

    if (this.screen === 'menu') this.renderMenu();
    else if (this.screen === 'settings') this.renderSettings();
    else if (this.screen === 'levels') this.renderLevels();
    else if (this.screen === 'meta') this.renderMetaPanel(this.screenLayer);
  }

  private renderMenu(): void {
    const d = DrawNode();
    drawGrad(d, 0, 320, 560, 210, [54, 41, 74, 255], [24, 18, 34, 255]);
    drawBand(d, 0, 320, 560, 210, 3, C_GOLD_DARK);
    drawBand(d, 0, 320, 560, 210, 1, C_GOLD);
    drawCorners(d, 0, 320, 560, 210, 14, 8, C_GOLD_BRIGHT);
    d.addTo(this.screenLayer);

    makeLabel(this.screenLayer, '灵 术 牌', 0, 350, 56, C_GOLD_TEXT);
    makeLabel(this.screenLayer, '暗 影 术 法', 0, 268, 20, C_TEXT_DIM);

    this.makeButton({ x: 0, y: 40, w: 300, h: 70 }, '开始游戏', [188, 160, 234, 255], [116, 90, 156, 255], Color(30, 20, 44, 255), () => { this.screen = 'levels'; this.refresh(); }, this.screenLayer, 26);
    this.makeButton({ x: 0, y: -60, w: 300, h: 70 }, '设置', [132, 106, 172, 255], [74, 55, 100, 255], Color(234, 226, 250, 255), () => { this.settingsBack = 'menu'; this.screen = 'settings'; this.refresh(); }, this.screenLayer, 26);
    this.makeButton({ x: 0, y: -160, w: 300, h: 70 }, '退出游戏', [96, 74, 118, 255], [52, 40, 66, 255], Color(226, 216, 240, 255), () => { App.shutdown(); }, this.screenLayer, 26);
  }

  private renderSettings(): void {
    const d = DrawNode();
    drawGrad(d, 0, 20, 620, 540, [50, 38, 68, 255], [22, 17, 32, 255]);
    drawBand(d, 0, 20, 620, 540, 3, C_GOLD_DARK);
    drawBand(d, 0, 20, 620, 540, 1, C_GOLD);
    drawCorners(d, 0, 20, 620, 540, 14, 8, C_GOLD_BRIGHT);
    d.addTo(this.screenLayer);

    makeLabel(this.screenLayer, '设 置', 0, 220, 38, C_GOLD_TEXT);
    this.renderVolumeRow(90, '背景音乐', this.bgmVolume, (delta) => this.changeBgmVolume(delta));
    this.renderVolumeRow(-40, '音效', this.sfxVolume, (delta) => this.changeSfxVolume(delta));

    this.makeButton({ x: 0, y: -200, w: 260, h: 64 }, '返回', [132, 106, 172, 255], [74, 55, 100, 255], Color(234, 226, 250, 255), () => { this.screen = this.settingsBack; this.refresh(); }, this.screenLayer, 24);
  }

  private renderVolumeRow(y: number, label: string, value: number, onChange: (delta: number) => void): void {
    const d = DrawNode();
    d.drawPolygon(rectVerts(0, y, 360, 16), Color(22, 17, 32, 255), 1, C_GOLD_DARK);
    const bar = 360 * value;
    if (bar > 2) d.drawPolygon(rectVerts(-180 + bar / 2, y, bar, 16), C_GOLD, 0);
    d.addTo(this.screenLayer);

    makeLabel(this.screenLayer, label + '  ' + Math.round(value * 100) + '%', 0, y + 52, 24, C_TEXT);
    this.makeButton({ x: -250, y: y, w: 64, h: 56 }, '−', [150, 124, 190, 255], [86, 66, 112, 255], Color(236, 228, 252, 255), () => onChange(-0.1), this.screenLayer, 28);
    this.makeButton({ x: 250, y: y, w: 64, h: 56 }, '+', [150, 124, 190, 255], [86, 66, 112, 255], Color(236, 228, 252, 255), () => onChange(0.1), this.screenLayer, 28);
  }

  private renderLevels(): void {
    const maxLevel = GameDataManager.MAX_LEVEL;
    let unlocked = this.mgr.state.highestLevel;
    if (unlocked < 1) unlocked = 1;
    if (unlocked > maxLevel) unlocked = maxLevel;

    const d = DrawNode();
    drawGrad(d, 0, 0, 660, 960, [50, 38, 68, 255], [22, 17, 32, 255]);
    drawBand(d, 0, 0, 660, 960, 3, C_GOLD_DARK);
    drawBand(d, 0, 0, 660, 960, 1, C_GOLD);
    drawCorners(d, 0, 0, 660, 960, 14, 8, C_GOLD_BRIGHT);

    const cols = [-200, 0, 200];
    const rows = [330, 150, -30, -210, -390];
    const px: number[] = [];
    const py: number[] = [];
    for (let i = 0; i < maxLevel; i++) {
      const row = Math.floor(i / 3);
      const col = i % 3;
      const c = (row % 2 === 0) ? col : (2 - col);
      px.push(cols[c]);
      py.push(rows[row]);
    }
    for (let i = 0; i + 1 < maxLevel; i++) {
      d.drawSegment(Vec2(px[i], py[i]), Vec2(px[i + 1], py[i + 1]), 3, C_GOLD_DARK);
    }
    d.addTo(this.screenLayer);

    makeLabel(this.screenLayer, '选 择 关 卡', 0, 545, 38, C_GOLD_TEXT);
    makeLabel(this.screenLayer, '共 ' + maxLevel + ' 关 · 已解锁 ' + unlocked, 0, 498, 22, C_TEXT_DIM);

    for (let i = 0; i < maxLevel; i++) {
      const lv = i + 1;
      const open = lv <= unlocked;
      const x = px[i];
      const y = py[i];

      const nd = DrawNode();
      if (open) {
        nd.drawDot(Vec2(x, y), 40, C_GOLD);
        nd.drawDot(Vec2(x, y), 34, C_BADGE);
      } else {
        nd.drawDot(Vec2(x, y), 40, Color(58, 48, 74, 255));
        nd.drawDot(Vec2(x, y), 34, Color(26, 20, 34, 255));
      }
      nd.addTo(this.screenLayer);
      makeLabel(this.screenLayer, '' + lv, x, y, open ? 26 : 22, open ? C_GOLD_TEXT : Color(104, 94, 120, 255));

      if (open) {
        const hit = Node();
        hit.position = Vec2(x, y);
        hit.size = Size(84, 84);
        hit.anchor = Vec2(0.5, 0.5);
        hit.touchEnabled = true;
        hit.onTapped(() => this.startLevelAt(lv));
        hit.addTo(this.screenLayer);
      }
    }

    this.makeButton({ x: -140, y: -560, w: 220, h: 62 }, '养成', [132, 106, 172, 255], [74, 55, 100, 255], Color(234, 226, 250, 255), () => { this.metaMessage = ''; this.screen = 'meta'; this.refresh(); }, this.screenLayer, 24);
    this.makeButton({ x: 140, y: -560, w: 220, h: 62 }, '返回', [132, 106, 172, 255], [74, 55, 100, 255], Color(234, 226, 250, 255), () => { this.screen = 'menu'; this.refresh(); }, this.screenLayer, 24);
  }

  // 开始指定关卡（重置结算状态）
  private startLevelAt(level: number): void {
    this.mgr.startLevel(level);
    this.rewardsApplied = false;
    this.lastReward = undefined;
    this.selectedCardId = undefined;
    this.metaOpen = false;
    this.metaMessage = '';
    this.screen = 'game';
    this.refresh();
  }

  private changeBgmVolume(delta: number): void {
    let v = this.bgmVolume + delta;
    if (v < 0) v = 0;
    if (v > 1) v = 1;
    this.bgmVolume = v;
    if (this.bgmSource) this.bgmSource.volume = v;
    this.save.bgmVolume = v;
    this.save.save();
    this.refresh();
  }

  private changeSfxVolume(delta: number): void {
    let v = this.sfxVolume + delta;
    if (v < 0) v = 0;
    if (v > 1) v = 1;
    this.sfxVolume = v;
    this.save.sfxVolume = v;
    this.save.save();
    this.refresh();
  }

  // 结算后同步进度：解锁下一关并写入存档
  private syncProgress(): void {
    const st = this.mgr.state.status;
    if (st === 'won' || st === 'complete') {
      let next = this.mgr.state.level + 1;
      if (next > GameDataManager.MAX_LEVEL) next = GameDataManager.MAX_LEVEL;
      this.mgr.unlockLevel(next);
    }
    const hl = this.mgr.state.highestLevel;
    if (hl > this.save.highestLevel) {
      this.save.highestLevel = hl;
      this.save.save();
    }
  }

  private renderHud(): void {
    this.hudLayer.removeAllChildren();
    const s = this.mgr.state;
    makeLabel(this.hudLayer, '生命 ' + s.hp + '/' + s.maxHp, -280, 585, 24,
      s.hp <= 1 ? C_DANGER : C_TEXT);
    makeLabel(this.hudLayer, '第 ' + s.level + ' 关', 0, 585, 26, C_TEXT);
    makeLabel(this.hudLayer, '需消除 ' + s.eliminatedCount + '/' + s.targetCount + ' 张', 0, 545, 18, C_TEXT_DIM);
    makeLabel(this.hudLayer, '回合 ' + s.turn, 120, 585, 22, C_TEXT);
    // 操作提示
    const hint = this.hintText !== '' ? this.hintText : '拖硬币到卡牌 · 点硬币切换正负 · 结束回合自动消除';
    makeLabel(this.hudLayer, hint, 0, 498, 22, this.hintText !== '' ? C_DANGER : C_GOLD_TEXT);
  }

  private renderCards(): void {
    this.cardLayer.removeAllChildren();
    this.cardRects = [];
    const cards = this.mgr.state.cards;
    const gridW = CARD_COLS * CARD_W + (CARD_COLS - 1) * CARD_GAP_X;
    const gridH = CARD_ROWS * CARD_H + (CARD_ROWS - 1) * CARD_GAP_Y;
    const startX = -gridW / 2 + CARD_W / 2;
    const startY = 250 + gridH / 2 - CARD_H / 2;
    const maxCards = CARD_COLS * CARD_ROWS;

    for (let i = 0; i < cards.length && i < maxCards; i++) {
      const card = cards[i];
      const col = i % CARD_COLS;
      const row = Math.floor(i / CARD_COLS);
      const x = startX + col * (CARD_W + CARD_GAP_X);
      const y = startY - row * (CARD_H + CARD_GAP_Y);
      this.buildCard(card, x, y);
    }
  }

  // 卡牌预制体
  private buildCard(card: Card, x: number, y: number): void {
    this.cardRects.push({ id: card.id, x: x, y: y, w: CARD_W, h: CARD_H });

    // 命中节点先加入，位于卡牌视觉与硬币之下；点击卡牌即选中
    const hit = Node();
    hit.position = Vec2(x, y);
    hit.size = Size(CARD_W, CARD_H);
    hit.anchor = Vec2(0.5, 0.5);
    hit.touchEnabled = true;
    hit.onTapped(() => {
      this.selectedCardId = card.id;
      this.hintText = '';
      this.refresh();
    });
    hit.addTo(this.cardLayer);

    const node = Node();
    node.position = Vec2(x, y);

    const selected = card.id === this.selectedCardId;
    const border = selected ? C_GOLD_BRIGHT : C_GOLD;
    const borderW = selected ? 4 : 3;

    const d = DrawNode();
    // 卡面：金属渐变 + 金框 + 角饰
    if (selected) {
      drawGrad(d, 0, 0, CARD_W, CARD_H, [90, 70, 122, 255], [46, 35, 64, 255]);
    } else {
      drawGrad(d, 0, 0, CARD_W, CARD_H, [58, 44, 78, 255], [28, 21, 40, 255]);
    }
    drawBand(d, 0, 0, CARD_W, CARD_H, borderW, border);
    drawBand(d, 0, 0, CARD_W - 12, CARD_H - 12, 1, selected ? C_GOLD_BRIGHT : C_GOLD_DARK);
    drawCorners(d, 0, 0, CARD_W, CARD_H, 14, 7, C_GOLD_BRIGHT);
    // 倒计时徽章（外圈 + 内芯）
    d.drawDot(Vec2(74, 104), 25, C_GOLD);
    d.drawDot(Vec2(74, 104), 21, C_BADGE);
    d.addTo(node);

    // 目标数字（放大）
    makeLabel(node, '' + card.target, 0, 52, 72, C_TEXT);
    makeLabel(node, '目标', 0, 112, 16, C_TEXT_DIM);

    // 倒计时
    makeLabel(node, '' + card.countdown, 74, 104, 22,
      card.countdown <= 1 ? C_DANGER : C_TEXT);
    makeLabel(node, '回合', 74, 132, 11, C_TEXT_DIM);

    // 特殊状态徽章（折扣/冰冻/回复/复制）
    let bx = -92;
    const by = 112;
    if (card.target !== card.originalTarget) {
      d.drawDot(Vec2(bx, by), 12, coinColor(CoinType.Discount));
      makeLabel(node, '折', bx, by, 12, C_TEXT);
      bx += 26;
    }
    if (card.frozen) {
      d.drawDot(Vec2(bx, by), 12, coinColor(CoinType.Freeze));
      makeLabel(node, '冻', bx, by, 12, C_TEXT);
      bx += 26;
    }
    if (card.healAmount > 0) {
      d.drawDot(Vec2(bx, by), 12, coinColor(CoinType.Heal));
      makeLabel(node, '回', bx, by, 12, C_TEXT);
      bx += 26;
    }
    if (card.copyArmed) {
      d.drawDot(Vec2(bx, by), 12, coinColor(CoinType.Copy));
      makeLabel(node, '复', bx, by, 12, C_TEXT);
      bx += 26;
    }

    // 算式预览（放大）
    const eq = this.equationText(card);
    makeLabel(node, eq, 0, -22, 20, eq === '算式：0' ? C_TEXT_DIM : C_TEXT);

    node.addTo(this.cardLayer);

    // 已放置的算式硬币芯片（可拖走或点击移除），绝对坐标加到 cardLayer，位于卡牌视觉之上
    const n = card.coins.length;
    const chipGap = n > 1 ? Math.min(46, (CARD_W - 44) / (n - 1)) : 0;
    for (let i = 0; i < n; i++) {
      const pc = card.coins[i];
      const idx = i;
      const chipX = (i - (n - 1) / 2) * chipGap;
      const chipY = -100;
      d.drawDot(Vec2(chipX, chipY), 18, coinColor(pc.type));
      d.drawDot(Vec2(chipX, chipY), 13, C_BADGE);
      makeLabel(node, this.opSymbol(pc.op) + pc.value, chipX, chipY, 17, C_TEXT);
      const chip = Node();
      chip.position = Vec2(x + chipX, y + chipY);
      chip.size = Size(48, 48);
      chip.anchor = Vec2(0.5, 0.5);
      chip.touchEnabled = true;
      chip.swallowTouches = true;
      chip.onTapped(() => {
        this.mgr.togglePlacedCoin(card.id, idx);
        this.refresh();
      });
      chip.onTapBegan((t) => this.beginDrag('placed', card.id, idx, pc.type, pc.value, t));
      chip.onTapMoved((t) => this.moveDrag(t));
      chip.onTapEnded((t) => this.endDrag(t));
      chip.addTo(this.cardLayer);
    }
  }

  // 格式化卡牌当前算式
  private equationText(card: Card): string {
    if (card.coins.length === 0) return '算式：0';
    let s = '算式：0';
    for (let i = 0; i < card.coins.length; i++) {
      const c = card.coins[i];
      if (c.type === CoinType.Multiply) {
        s += c.op === 'div' ? ' ÷ ' + c.value : ' × ' + c.value;
      } else {
        s += c.op === 'sub' ? ' − ' + c.value : ' + ' + c.value;
      }
    }
    return s + ' = ' + this.mgr.evaluateCard(card);
  }

  private renderCoins(): void {
    this.coinLayer.removeAllChildren();
    makeLabel(this.coinLayer, '硬币背包', 0, -168, 20, C_TEXT_DIM);

    const inv = this.mgr.state.inventory;
    const cols = 3;
    const groupW = 216;
    const groupH = 128;
    const rowCenters = [-262, -396, -530];
    const colCenters = [-220, 0, 220];

    let idx = 0;
    for (let t = 0; t < COIN_TYPE_ORDER.length; t++) {
      const type = COIN_TYPE_ORDER[t];
      const stacks: CoinStack[] = [];
      let total = 0;
      for (let i = 0; i < inv.length; i++) {
        if (inv[i].type === type) {
          stacks.push(inv[i]);
          total += inv[i].count;
        }
      }
      if (stacks.length === 0) continue;

      const col = idx % cols;
      const row = Math.floor(idx / cols);
      if (row >= 3) break;
      const gx = colCenters[col];
      const gy = rowCenters[row];
      this.buildCoinGroup(type, stacks, total, gx, gy, groupW, groupH);
      idx++;
    }

    makeLabel(this.coinLayer,
      '最高关卡 ' + this.mgr.state.highestLevel + ' · 货币 ' + this.mgr.state.currency + ' · 单次奖励上限 1000',
      0, -600, 15, C_GOLD_TEXT);
  }

  // 硬币类型分组预制体
  private buildCoinGroup(
    type: CoinType,
    stacks: CoinStack[],
    total: number,
    gx: number,
    gy: number,
    w: number,
    h: number,
  ): void {
    const node = Node();
    node.position = Vec2(gx, gy);

    const d = DrawNode();
    // 分组框：金属渐变 + 金边 + 角饰
    drawGrad(d, 0, 0, w, h, [50, 38, 68, 255], [24, 18, 34, 255]);
    drawBand(d, 0, 0, w, h, 2, C_GOLD_DARK);
    drawCorners(d, 0, 0, w, h, 10, 5, C_GOLD);
    d.addTo(node);
    node.addTo(this.coinLayer);

    makeLabel(node, coinTypeName(type) + ' ×' + total, -100, 46, 20, C_GOLD_TEXT, Vec2(0, 0.5));

    const n = stacks.length;
    const chipRadius = 26;
    const chipGap = n > 1 ? Math.min(44, (w - 2 * chipRadius) / (n - 1)) : 0;
    for (let i = 0; i < n; i++) {
      // 关键：闭包必须引用每轮新建的局部变量，不能引用循环变量 i
      // （TS->Lua 的 for 循环变量是共享的，闭包延迟执行时 i 已经是最终值）。
      const stack = stacks[i];
      const chipX = (i - (n - 1) / 2) * chipGap;
      const chipY = -12;
      // 金属币：外圈（类型色）+ 暗金环 + 深色芯 + 高光
      const cc = coinColor(type);
      d.drawDot(Vec2(chipX, chipY), chipRadius, cc);
      d.drawDot(Vec2(chipX, chipY), chipRadius - 3, C_GOLD_DARK);
      d.drawDot(Vec2(chipX, chipY), chipRadius - 6, C_BADGE);
      d.drawDot(Vec2(chipX - chipRadius * 0.3, chipY + chipRadius * 0.34), chipRadius * 0.26, Color(238, 226, 198, 26));
      makeLabel(node, coinChipText(type, stack.value), chipX, chipY + 6, 20, C_TEXT);
      if (stack.count > 1) {
        makeLabel(node, '×' + stack.count, chipX, chipY - 36, 13, C_TEXT_FAINT);
      }
      // 硬币芯片：拖到卡牌上才能放置；点击切换数值正负
      const chip = Node();
      chip.position = Vec2(gx + chipX, gy + chipY);
      chip.size = Size(68, 68);
      chip.anchor = Vec2(0.5, 0.5);
      chip.touchEnabled = true;
      chip.swallowTouches = true;
      chip.onTapped(() => {
        this.log('FLIP ' + stack.value);
        this.mgr.flipCoinSign(type, stack.value);
        this.hintText = '';
        this.refresh();
      });
      chip.onTapBegan((t) => this.beginDrag('inventory', 0, 0, type, stack.value, t));
      chip.onTapMoved((t) => this.moveDrag(t));
      chip.onTapEnded((t) => this.endDrag(t));
      chip.addTo(this.coinLayer);
    }
  }

  // ===== 胜负、关卡流转与局外养成（第五/六步） =====

  private updateOverlay(): void {
    const s = this.mgr.state;
    this.overlayLayer.removeAllChildren();

    if (s.status === 'playing') {
      this.metaOpen = false;
      this.metaMessage = '';
      return;
    }

    // 半透明遮罩
    const dim = DrawNode();
    dim.drawPolygon(rectVerts(0, 0, DESIGN_W, DESIGN_H), Color(8, 6, 5, 210), 0);
    dim.addTo(this.overlayLayer);

    if (this.metaOpen) {
      this.renderMetaPanel(this.overlayLayer);
      return;
    }

    // 中央面板
    const panel = DrawNode();
    panel.drawPolygon(rectVerts(0, 0, 520, 430), C_PANEL, 4, C_PANEL_BORDER);
    panel.addTo(this.overlayLayer);

    if (s.status === 'lost') {
      makeLabel(this.overlayLayer, '游戏失败', 0, 120, 34, C_DANGER);
      makeLabel(this.overlayLayer, '生命归零，未能完成本关', 0, 60, 18, C_TEXT_DIM);
      makeLabel(this.overlayLayer, '第 ' + s.level + ' 关 · 已消除 ' + s.eliminatedCount + '/' + s.targetCount + ' 张', 0, 22, 16, C_TEXT_DIM);
      this.addOverlayButton('重试', 0, -120, 220, 50, C_ENDTURN, 'retry');
    } else if (s.status === 'complete') {
      if (!this.rewardsApplied) { this.lastReward = this.mgr.applyWinRewards(); this.rewardsApplied = true; }
      makeLabel(this.overlayLayer, '全部通关！', 0, 120, 34, C_GOLD_TEXT);
      makeLabel(this.overlayLayer, '你完成了全部 ' + GameDataManager.MAX_LEVEL + ' 关', 0, 60, 18, C_TEXT);
      makeLabel(this.overlayLayer, '总货币 ' + s.currency, 0, 22, 16, C_TEXT_DIM);
      this.addOverlayButton('重新开始', 0, -90, 220, 44, C_CONFIRM, 'restart');
      this.addOverlayButton('选择关卡', 0, -150, 220, 44, Color(104, 82, 148, 255), 'toLevels');
    } else {
      if (!this.rewardsApplied) { this.lastReward = this.mgr.applyWinRewards(); this.rewardsApplied = true; }
      makeLabel(this.overlayLayer, '关卡完成！', 0, 120, 34, C_GOLD_TEXT);
      makeLabel(this.overlayLayer, '已消除 ' + s.eliminatedCount + '/' + s.targetCount + ' 张 · 生命 ' + s.hp + '/' + s.maxHp, 0, 60, 18, C_TEXT);
      let rewardText = '货币 +0 · 新硬币 +1';
      if (this.lastReward) {
        rewardText = '货币 +' + this.lastReward.currency + ' · 新硬币：' + coinTypeName(this.lastReward.coinType) + ' ' + this.lastReward.coinValue;
      }
      makeLabel(this.overlayLayer, rewardText, 0, 22, 16, C_TEXT_DIM);
      this.addOverlayButton('下一关', 0, -80, 220, 44, C_CONFIRM, 'next');
      this.addOverlayButton('选择关卡', 0, -135, 220, 44, Color(104, 82, 148, 255), 'toLevels');
      this.addOverlayButton('养成', 0, -190, 220, 44, Color(104, 82, 148, 255), 'meta');
    }
  }

  private renderMetaPanel(parent: Node.Type): void {
    const W = 660;
    const H = 1010;
    const panel = DrawNode();
    panel.drawPolygon(rectVerts(0, 0, W, H), C_PANEL, 4, C_PANEL_BORDER);
    drawBand(panel, 0, 0, W, H, 3, C_GOLD_DARK);
    drawBand(panel, 0, 0, W - 16, H - 16, 1, C_GOLD);
    drawCorners(panel, 0, 0, W, H, 20, 11, C_GOLD_BRIGHT);
    panel.drawSegment(Vec2(-286, 292), Vec2(286, 292), 1, C_GOLD_DARK);
    panel.drawSegment(Vec2(-286, 96), Vec2(286, 96), 1, C_GOLD_DARK);
    panel.addTo(parent);

    const s = this.mgr.state;
    makeLabel(parent, '局外养成', 0, 436, 36, C_GOLD_TEXT);
    makeLabel(parent, '货币 ' + s.currency + ' · 血量上限 ' + s.maxHp + ' · 删除次数 ' + this.mgr.deleteCredits, 0, 384, 17, C_TEXT);
    makeLabel(parent, '扫荡奖励按最高关卡计，货币上限 1000', 0, 354, 13, C_TEXT_DIM);
    if (this.metaMessage !== '') {
      makeLabel(parent, this.metaMessage, 0, 320, 16, C_GOLD_TEXT);
    }

    makeLabel(parent, '增加基础硬币（每枚 100 货币）', 0, 258, 21, C_TEXT);
    const buyValues: number[] = [1, 2, 3, 5, 10, 50];
    for (let i = 0; i < buyValues.length; i++) {
      const col = i % 3;
      const row = Math.floor(i / 3);
      const bx = -212 + col * 212;
      const by = 202 - row * 74;
      this.addOverlayButton('＋' + buyValues[i], bx, by, 186, 52, C_ENDTURN, 'buy' + i, parent, 22);
    }

    this.addOverlayButton('合成硬币', 0, 50, 340, 52, Color(104, 82, 148, 255), 'synthesize', parent, 21);
    this.addOverlayButton('强化血量（100）', 0, -24, 340, 52, C_ENDTURN, 'upgradeHp', parent, 21);
    this.addOverlayButton('强化删除次数（80）', 0, -98, 340, 52, C_ENDTURN, 'upgradeDelete', parent, 21);
    this.addOverlayButton('删除一枚硬币', 0, -172, 340, 52, Color(158, 70, 104, 255), 'delete', parent, 21);
    this.addOverlayButton('扫荡', 0, -246, 340, 52, C_CONFIRM, 'sweep', parent, 21);

    this.addOverlayButton('返回', 0, -388, 320, 58, Color(84, 70, 118, 255), 'back', parent, 23);
  }

  private addOverlayButton(text: string, cx: number, cy: number, w: number, h: number, color: Color.Type, action: string, parent?: Node.Type, fontSize?: number): void {
    const node = Node();
    node.position = Vec2(cx, cy);
    node.size = Size(w, h);
    node.anchor = Vec2(0.5, 0.5);
    const d = DrawNode();
    d.drawPolygon(rectVerts(w / 2, h / 2, w, h), color, 2, C_CONFIRM_BORDER);
    d.addTo(node);
    makeLabel(node, text, w / 2, h / 2, fontSize ? fontSize : 20, C_TEXT);
    node.touchEnabled = true;
    node.onTapped(() => this.handleOverlayAction(action));
    node.addTo(parent ? parent : this.overlayLayer);
  }

  private handleOverlayAction(action: string): void {
    if (action === 'toLevels') {
      this.metaOpen = false;
      this.metaMessage = '';
      this.screen = 'levels';
      this.refresh();
      return;
    }
    if (action === 'retry') {
      this.mgr.startLevel(this.mgr.state.level);
      this.rewardsApplied = false;
      this.lastReward = undefined;
      this.selectedCardId = undefined;
      this.metaOpen = false;
      this.metaMessage = '';
      this.refresh();
      return;
    }
    if (action === 'next') {
      this.mgr.startLevel(this.mgr.state.level + 1);
      this.rewardsApplied = false;
      this.lastReward = undefined;
      this.selectedCardId = undefined;
      this.metaOpen = false;
      this.metaMessage = '';
      this.refresh();
      return;
    }
    if (action === 'restart') {
      this.mgr.startLevel(1);
      this.rewardsApplied = false;
      this.lastReward = undefined;
      this.selectedCardId = undefined;
      this.metaOpen = false;
      this.metaMessage = '';
      this.refresh();
      return;
    }
    if (action === 'meta') {
      this.metaOpen = true;
      this.metaMessage = '';
      this.refresh();
      return;
    }
    if (action === 'back') {
      this.metaOpen = false;
      this.metaMessage = '';
      if (this.screen === 'meta') this.screen = 'levels';
      this.refresh();
      return;
    }
    if (action.indexOf('buy') === 0) {
      const idx = Number(action.substring(3));
      const br = this.mgr.buyBaseCoin(idx);
      this.metaMessage = br.ok ? ('已增加基础硬币 ' + br.value) : br.reason;
      this.refresh();
      return;
    }
    if (action === 'synthesize') {
      const r = this.mgr.synthesizeOnce();
      this.metaMessage = r.ok
        ? '合成成功：' + coinTypeName(r.type) + ' ' + r.valueA + ' + ' + r.valueB + ' → ' + r.resultValue
        : '无可合成硬币（需同类型至少 2 枚）';
      this.refresh();
      return;
    }
    if (action === 'upgradeHp') {
      const r = this.mgr.upgradeMaxHp();
      this.metaMessage = r.ok ? '血量上限提升至 ' + r.newMaxHp : r.reason;
      this.refresh();
      return;
    }
    if (action === 'upgradeDelete') {
      const r = this.mgr.upgradeDeleteCredits();
      this.metaMessage = r.ok ? '删除次数 +2（当前 ' + r.newCredits + '）' : r.reason;
      this.refresh();
      return;
    }
    if (action === 'delete') {
      const r = this.mgr.deleteOnce();
      this.metaMessage = r.ok ? '已删除 ' + coinTypeName(r.type) + ' ' + r.value : r.reason;
      this.refresh();
      return;
    }
    if (action === 'sweep') {
      const r = this.mgr.sweepLevel();
      this.metaMessage = r.ok ? '扫荡获得货币 +' + r.currency + ' · 硬币 ' + coinTypeName(r.coinType) + ' ' + r.coinValue : r.reason;
      this.refresh();
      return;
    }
  }

  // ===== 触摸交互（第三步：节点原生事件 + 点击式操作） =====

  // 创建带原生点击事件的按钮节点（金属渐变 + 双金边）
  private makeButton(
    rect: { x: number; y: number; w: number; h: number },
    text: string,
    top: number[],
    bottom: number[],
    textColor: Color.Type,
    onTap: () => void,
    parent?: Node.Type,
    fontSize?: number,
  ): void {
    const node = Node();
    node.position = Vec2(rect.x, rect.y);
    node.size = Size(rect.w, rect.h);
    node.anchor = Vec2(0.5, 0.5);
    const d = DrawNode();
    drawGrad(d, rect.w / 2, rect.h / 2, rect.w, rect.h, top, bottom);
    drawSheen(d, rect.w / 2, rect.h / 2, rect.w, rect.h, 48);
    drawBand(d, rect.w / 2, rect.h / 2, rect.w, rect.h, 2, C_GOLD_DARK);
    drawBand(d, rect.w / 2, rect.h / 2, rect.w - 8, rect.h - 8, 1, C_GOLD_BRIGHT);
    d.addTo(node);
    makeLabel(node, text, rect.w / 2, rect.h / 2, fontSize ? fontSize : 20, textColor);
    node.touchEnabled = true;
    node.onTapped(() => onTap());
    node.addTo(parent ? parent : this.actionLayer);
  }

  // 触摸点在世界（= 设计中心）坐标系中的位置。
  // 优先用 worldLocation；缺失时回退到节点本地坐标 + 世界变换。
  private dragPoint(t: Touch.Type, node?: Node.Type): Vec2.Type {
    const wl = (t as { worldLocation?: Vec2.Type }).worldLocation;
    if (wl !== undefined) return Vec2(wl.x, wl.y);
    if (node) return node.convertToWorldSpace(t.location);
    return Vec2(t.location.x, t.location.y);
  }

  private beginDrag(
    kind: 'inventory' | 'placed',
    cardId: number,
    index: number,
    type: CoinType,
    value: number,
    t: Touch.Type,
  ): void {
    // 相邻硬币命中区可能重叠（一次按下触发多次 began），已有拖拽时忽略
    if (this.drag) return;
    this.lastMoveLog = 0;
    this.dragEndedEarly = false;
    this.log('BEGIN ' + kind + ' val=' + value + ' mouseDown=' + Mouse.leftButtonPressed);
    this.drag = { kind: kind, cardId: cardId, index: index, type: type, value: value };
    const wp = this.dragPoint(t);
    this.dragStart = wp;
    this.makeGhost(type, value, wp);
    // 可见反馈：按下硬币立即提示（只重建 HUD 层，不会破坏硬币节点）
    this.hintText = '把硬币放到某张卡牌上';
    this.renderHud();
  }

  private moveDrag(t: Touch.Type): void {
    if (!this.drag) return;
    const wp = this.dragPoint(t);
    if (this.dragGhost) this.dragGhost.position = wp;
    const s = this.dragStart;
    if (s) {
      const d = Math.abs(wp.x - s.x) + Math.abs(wp.y - s.y);
      if (d - this.lastMoveLog >= 40) {
        this.lastMoveLog = d;
        this.log('MOVE d=' + Math.round(d));
      }
    }
  }

  private endDrag(t: Touch.Type): void {
    if (!this.drag) return;
    // 指针仍按下时，“结束”只是手势离开了节点；保留拖拽，交给每帧轮询继续
    if (Mouse.leftButtonPressed) {
      this.dragEndedEarly = true;
      this.log('END early (still pressed)');
      return;
    }
    this.finalizeDrag(this.dragPoint(t));
  }

  // 每帧轮询：手势提前结束后，继续跟随指针，松开时落下
  private tick(): void {
    if (!this.drag || !this.dragEndedEarly) return;
    if (Mouse.leftButtonPressed) {
      const p = this.mouseDesignPoint();
      if (this.dragGhost) this.dragGhost.position = p;
    } else {
      this.finalizeDrag(this.mouseDesignPoint());
    }
  }

  // 鼠标位置 -> 设计中心坐标（按引擎文档的换算公式）
  private mouseDesignPoint(): Vec2.Type {
    const mouse = Mouse.position;
    const visual = App.visualSize;
    const view = View.size;
    const z = this.viewZoom;
    const vx = mouse.x * view.width / visual.width - view.width / 2;
    const vy = view.height / 2 - mouse.y * view.height / visual.height;
    return Vec2(vx / z, vy / z);
  }

  private finalizeDrag(p: Vec2.Type): void {
    const d = this.drag;
    this.drag = undefined;
    this.dragEndedEarly = false;
    this.hideGhost();
    const start = this.dragStart;
    this.dragStart = undefined;
    if (!d) return;
    const moved = start ? Math.abs(p.x - start.x) + Math.abs(p.y - start.y) : 0;
    this.log('END moved=' + Math.round(moved));
    // 轻点由 onTapped 处理；这里只处理真正的拖动
    if (moved < 20) return;
    if (d.kind === 'inventory') {
      const target = this.cardAtPoint(p);
      if (target !== undefined) {
        if (this.mgr.placeCoinOnCard(target, d.type, d.value)) this.playCoinSound();
        this.hintText = '';
      } else {
        this.hintText = '把硬币拖到某张卡牌上';
      }
      this.refresh();
    } else {
      const target = this.cardAtPoint(p);
      if (target === undefined) {
        this.mgr.removePlacedCoin(d.cardId, d.index);
      } else if (target !== d.cardId) {
        if (this.mgr.movePlacedCoin(d.cardId, d.index, target)) this.playCoinSound();
      }
      this.refresh();
    }
  }

  // 放置硬币音效
  private playCoinSound(): void {
    this.playSfx('Audio/coin.wav');
  }

  // 卡牌确认消除音效
  private playCardSound(): void {
    this.playSfx('Audio/card_paper.wav');
  }

  // 播放音效：用 AudioSource 以便按设置音量播放（Audio.play 无音量参数）
  private playSfx(path: string): void {
    const s = AudioSource(path);
    if (s) {
      s.volume = this.sfxVolume;
      s.addTo(this.fxLayer);
      s.play();
    }
  }

  private cardAtPoint(p: Vec2.Type): number | undefined {
    for (let i = 0; i < this.cardRects.length; i++) {
      const r = this.cardRects[i];
      if (p.x >= r.x - r.w / 2 && p.x <= r.x + r.w / 2 &&
        p.y >= r.y - r.h / 2 && p.y <= r.y + r.h / 2) {
        return r.id;
      }
    }
    return undefined;
  }

  private makeGhost(type: CoinType, value: number, pos: Vec2.Type): void {
    this.hideGhost();
    const node = Node();
    node.position = pos;
    const d = DrawNode();
    d.drawDot(Vec2.zero, 26, coinColor(type));
    d.drawDot(Vec2.zero, 20, C_BADGE);
    d.addTo(node);
    const l = Label('sarasa-mono-sc-regular', 20);
    if (l) { l.text = coinChipText(type, value); l.position = Vec2.zero; l.color = C_TEXT; l.addTo(node); }
    node.addTo(this.fxLayer);
    this.dragGhost = node;
  }

  private hideGhost(): void {
    if (this.dragGhost) { this.dragGhost.removeFromParent(); this.dragGhost = undefined; }
  }

  private doConfirm(): void {
    if (this.mgr.state.status !== 'playing') return;
    if (this.selectedCardId === undefined) return;
    const res = this.mgr.confirmCard(this.selectedCardId);
    if (res.ok) {
      this.selectedCardId = undefined;
      this.playCardSound();
    }
    this.syncProgress();
    this.refresh();
  }

  private doEndTurn(): void {
    if (this.mgr.state.status !== 'playing') return;
    this.mgr.endTurn();
    this.selectedCardId = undefined;
    this.syncProgress();
    this.refresh();
  }

  private opSymbol(op: string): string {
    if (op === 'sub') return '−';
    if (op === 'mul') return '×';
    if (op === 'div') return '÷';
    return '+';
  }
}
