// 《灵术牌》美术资源生成器：用矢量绘制导出 PNG 图标与封面
// 运行方式：enterEntryAsync({ fileName: "Art/GameArt.ts" })
import { Color, Content, Director, DrawNode, Label, Node, Path, RenderTarget, Vec2, thread } from 'Dora';

// ===== 配色（与游戏一致：紫罗兰暗金属）=====
const C_BG: Color.Type = Color(14, 11, 20, 255);
const C_GOLD: Color.Type = Color(160, 136, 200, 255);
const C_GOLD_BRIGHT: Color.Type = Color(226, 214, 252, 255);
const C_GOLD_DARK: Color.Type = Color(84, 66, 112, 255);
const C_GOLD_TEXT: Color.Type = Color(206, 190, 244, 255);
const C_DIM: Color.Type = Color(172, 158, 196, 255);
const C_BADGE: Color.Type = Color(18, 14, 26, 255);

function rectVerts(cx: number, cy: number, w: number, h: number): Vec2.Type[] {
  return [
    Vec2(cx - w / 2, cy - h / 2),
    Vec2(cx + w / 2, cy - h / 2),
    Vec2(cx + w / 2, cy + h / 2),
    Vec2(cx - w / 2, cy + h / 2),
  ];
}

function lerpC(a: number[], b: number[], t: number): Color.Type {
  return Color(
    Math.round(a[0] + (b[0] - a[0]) * t),
    Math.round(a[1] + (b[1] - a[1]) * t),
    Math.round(a[2] + (b[2] - a[2]) * t),
    Math.round(a[3] + (b[3] - a[3]) * t),
  );
}

function grad(d: DrawNode.Type, cx: number, cy: number, w: number, h: number, top: number[], bottom: number[]): void {
  const steps = 28;
  const x0 = cx - w / 2;
  const x1 = cx + w / 2;
  for (let i = 0; i < steps; i++) {
    const yT = cy + h / 2 - h * (i / steps);
    const yB = cy + h / 2 - h * ((i + 1) / steps);
    d.drawPolygon([Vec2(x0, yT), Vec2(x1, yT), Vec2(x1, yB), Vec2(x0, yB)], lerpC(top, bottom, (i + 0.5) / steps), 0);
  }
}

function band(d: DrawNode.Type, cx: number, cy: number, w: number, h: number, t: number, color: Color.Type): void {
  d.drawPolygon(rectVerts(cx, cy + h / 2 - t / 2, w, t), color, 0);
  d.drawPolygon(rectVerts(cx, cy - h / 2 + t / 2, w, t), color, 0);
  d.drawPolygon(rectVerts(cx - w / 2 + t / 2, cy, t, h - 2 * t), color, 0);
  d.drawPolygon(rectVerts(cx + w / 2 - t / 2, cy, t, h - 2 * t), color, 0);
}

function stud(d: DrawNode.Type, x: number, y: number, r: number, color: Color.Type): void {
  d.drawPolygon([Vec2(x, y + r), Vec2(x + r, y), Vec2(x, y - r), Vec2(x - r, y)], color, 0);
}

function corners(d: DrawNode.Type, cx: number, cy: number, w: number, h: number, inset: number, r: number, color: Color.Type): void {
  const hx = w / 2 - inset;
  const hy = h / 2 - inset;
  stud(d, cx - hx, cy + hy, r, color);
  stud(d, cx + hx, cy + hy, r, color);
  stud(d, cx - hx, cy - hy, r, color);
  stud(d, cx + hx, cy - hy, r, color);
}

// 斜向菱格暗纹
function diamonds(d: DrawNode.Type, halfW: number, halfH: number, step: number, color: Color.Type): void {
  const n = Math.ceil((halfW + halfH) / step) + 1;
  for (let i = -n; i <= n; i++) {
    const x = i * step;
    d.drawSegment(Vec2(x, -halfH), Vec2(x + halfH * 2, halfH), 1, color);
    d.drawSegment(Vec2(x, halfH), Vec2(x + halfH * 2, -halfH), 1, color);
  }
}

function text(parent: Node.Type, s: string, x: number, y: number, size: number, color: Color.Type): void {
  const l = Label('sarasa-mono-sc-regular', size);
  if (l) {
    l.text = s;
    l.position = Vec2(x, y);
    l.anchor = Vec2(0.5, 0.5);
    l.color = color;
    l.addTo(parent);
  }
}

// 一张卡牌（金属渐变 + 双描边 + 角饰）
function cardFace(d: DrawNode.Type, cx: number, cy: number, w: number, h: number, bright: boolean): void {
  grad(d, cx, cy, w, h, [72, 56, 96, 255], [30, 23, 42, 255]);
  band(d, cx, cy, w, h, 4, C_GOLD_DARK);
  band(d, cx, cy, w, h, 1.5, bright ? C_GOLD_BRIGHT : C_GOLD);
  band(d, cx, cy, w - 14, h - 14, 1, C_GOLD_DARK);
  corners(d, cx, cy, w, h, 14, 7, C_GOLD_BRIGHT);
}

// 硬币/法术徽章
function medallion(d: DrawNode.Type, cx: number, cy: number, r: number): void {
  d.drawDot(Vec2(cx, cy), r, C_GOLD);
  d.drawDot(Vec2(cx, cy), r - 6, C_BADGE);
  d.drawDot(Vec2(cx, cy), r - 10, C_GOLD_DARK);
  stud(d, cx, cy, r * 0.52, C_GOLD_BRIGHT);
  d.drawDot(Vec2(cx - r * 0.34, cy + r * 0.34), r * 0.15, Color(242, 236, 255, 150));
}

// ===== 图标 512x512 =====
function buildIcon(): void {
  const S = 512;
  const half = S / 2;
  const rt = RenderTarget(S, S);
  const root = Node();
  // RenderTarget 坐标原点在左下角，偏移半画布使中心坐标生效
  root.position = Vec2(S / 2, S / 2);
  const d = DrawNode();

  d.drawPolygon(rectVerts(0, 0, S, S), C_BG, 0);
  diamonds(d, half, half, 64, Color(38, 30, 54, 255));
  band(d, 0, 0, S - 14, S - 14, 6, C_GOLD_DARK);
  band(d, 0, 0, S - 14, S - 14, 2, C_GOLD);
  corners(d, 0, 0, S - 14, S - 14, 26, 11, C_GOLD_BRIGHT);
  d.addTo(root);

  cardFace(d, 0, 46, 200, 268, true);
  medallion(d, 0, 66, 64);
  // 顶端装饰
  stud(d, 0, 214, 11, C_GOLD_BRIGHT);
  stud(d, -40, 214, 7, C_GOLD);
  stud(d, 40, 214, 7, C_GOLD);
  // 底部标题（直接在 DrawNode 之后加文本节点）
  text(root, '灵术牌', 0, -168, 54, C_GOLD_TEXT);
  d.drawSegment(Vec2(-70, -206), Vec2(70, -206), 1, C_GOLD_DARK);

  const out = Path(Content.searchPaths[0], 'Art', 'icon.png');
  Content.remove(out);
  rt.renderWithClear(root, C_BG);
  rt.saveAsync(out);
}

// ===== 封面 1280x720 =====
function buildCover(): void {
  const W = 1280;
  const H = 720;
  const rt = RenderTarget(W, H);
  const root = Node();
  // RenderTarget 坐标原点在左下角，偏移半画布使中心坐标生效
  root.position = Vec2(W / 2, H / 2);
  const d = DrawNode();

  d.drawPolygon(rectVerts(0, 0, W, H), C_BG, 0);
  diamonds(d, W / 2, H / 2, 96, Color(38, 30, 54, 255));
  band(d, 0, 0, W - 30, H - 30, 8, C_GOLD_DARK);
  band(d, 0, 0, W - 30, H - 30, 2, C_GOLD);
  corners(d, 0, 0, W - 30, H - 30, 46, 14, C_GOLD_BRIGHT);
  d.addTo(root);

  // 标题区
  text(root, '灵 术 牌', 0, 190, 132, C_GOLD_TEXT);
  text(root, '暗 影 术 法 · 卡 牌 消 除', 0, 88, 34, C_DIM);
  d.drawSegment(Vec2(-260, 40), Vec2(260, 40), 2, C_GOLD_DARK);
  d.drawSegment(Vec2(-220, 40), Vec2(220, 40), 1, C_GOLD);
  stud(d, 0, 40, 12, C_GOLD_BRIGHT);
  stud(d, -260, 40, 7, C_GOLD);
  stud(d, 260, 40, 7, C_GOLD);

  // 三张卡牌
  cardFace(d, -190, -140, 160, 230, false);
  cardFace(d, 190, -140, 160, 230, false);
  cardFace(d, 0, -110, 190, 270, true);
  medallion(d, 0, -80, 60);

  // 散落硬币
  medallion(d, -330, -190, 30);
  medallion(d, 330, -190, 30);
  medallion(d, -330, -60, 22);
  medallion(d, 330, -60, 22);

  // 底部标语
  text(root, '拖拽硬币 · 组成算式 · 消除卡牌', 0, -300, 26, C_GOLD_TEXT);

  const out = Path(Content.searchPaths[0], 'Art', 'cover.png');
  Content.remove(out);
  rt.renderWithClear(root, C_BG);
  rt.saveAsync(out);
}

// ===== 竖版封面 1080x1920 =====
function buildPortraitCover(): void {
  const W = 1080;
  const H = 1920;
  const rt = RenderTarget(W, H);
  const root = Node();
  root.position = Vec2(W / 2, H / 2);
  const d = DrawNode();

  d.drawPolygon(rectVerts(0, 0, W, H), C_BG, 0);
  diamonds(d, W / 2, H / 2, 130, Color(38, 30, 54, 255));
  band(d, 0, 0, W - 44, H - 44, 12, C_GOLD_DARK);
  band(d, 0, 0, W - 44, H - 44, 3, C_GOLD);
  corners(d, 0, 0, W - 44, H - 44, 72, 22, C_GOLD_BRIGHT);
  d.addTo(root);

  // 标题区
  text(root, '灵 术 牌', 0, 640, 220, C_GOLD_TEXT);
  text(root, '暗 影 术 法 · 卡 牌 消 除', 0, 476, 56, C_DIM);
  d.drawSegment(Vec2(-420, 396), Vec2(420, 396), 3, C_GOLD_DARK);
  d.drawSegment(Vec2(-360, 396), Vec2(360, 396), 1.5, C_GOLD);
  stud(d, 0, 396, 20, C_GOLD_BRIGHT);
  stud(d, -420, 396, 12, C_GOLD);
  stud(d, 420, 396, 12, C_GOLD);

  // 三张卡牌（中间更大、在前）
  cardFace(d, -310, -260, 340, 480, false);
  cardFace(d, 310, -260, 340, 480, false);
  cardFace(d, 0, -180, 460, 660, true);
  medallion(d, 0, -120, 140);

  // 散落硬币
  medallion(d, -420, 300, 56);
  medallion(d, 420, 300, 56);
  medallion(d, -420, -780, 46);
  medallion(d, 420, -780, 46);

  text(root, '拖拽硬币 · 组成算式 · 消除卡牌', 0, -880, 40, C_GOLD_TEXT);

  const out = Path(Content.searchPaths[0], 'Art', 'cover_portrait.png');
  Content.remove(out);
  rt.renderWithClear(root, C_BG);
  rt.saveAsync(out);
}

// ===== 入口：渲染一帧后导出 =====
const scene = Node();
scene.addTo(Director.entry);
scene.schedule(() => {
  // RenderTarget.saveAsync 必须在协程（thread）中执行
  thread(() => {
    buildIcon();
    buildCover();
    buildPortraitCover();
  });
  return true;
});
