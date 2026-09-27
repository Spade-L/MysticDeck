// 《灵术牌》数据管理类 —— 纯逻辑层，不依赖任何渲染节点
import {
  Card,
  CoinStack,
  CoinType,
  COIN_TYPE_ORDER,
  ConfirmResult,
  GameState,
  PlacedCoin,
  TurnResult,
  coinTypeName,
} from 'game/types';

export class GameDataManager {
  // 游戏基础常量
  static readonly START_HP = 2;          // 初始血量
  static readonly MAX_LEVEL = 15;        // 总关卡数
  static readonly CARD_COUNTDOWN = 3;    // 每张卡牌初始倒计时
  static readonly FIELD_CARD_COUNT = 3;  // 场上同时存在的卡牌数
  static readonly COIN_MAX_VALUE = 999;  // 硬币数值上限
  static readonly DISCOUNT_MAX = 100;    // 折扣上限（百分比）
  static readonly MAX_HP = 5;             // 强化后的血量上限

  // 可消除的目标数字池（保证开局可解）
  private static readonly TARGET_POOL: number[] = [
    2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 16, 18, 20, 21, 24, 25, 27, 30,
  ];

  // 历史最高关卡、货币、硬币背包（跨关卡保留）
  private highestLevel = 1;
  private currency = 0;
  private inventory: CoinStack[] = [];
  private metaMaxHp = GameDataManager.START_HP;
  deleteCredits = 3;

  state: GameState;

  constructor() {
    this.state = this.createEmptyState();
    this.startLevel(1);
  }

  // 创建空白游戏状态
  private createEmptyState(): GameState {
    return {
      hp: GameDataManager.START_HP,
      maxHp: GameDataManager.START_HP,
      level: 1,
      highestLevel: 1,
      turn: 0,
      targetCount: 3,
      eliminatedCount: 0,
      currency: 0,
      cards: [],
      inventory: [],
      nextCardId: 1,
      status: 'playing',
    };
  }

  // 解锁关卡（用于选关进度）
  unlockLevel(level: number): void {
    let lvl = level;
    if (lvl < 1) lvl = 1;
    if (lvl > GameDataManager.MAX_LEVEL) lvl = GameDataManager.MAX_LEVEL;
    if (lvl > this.highestLevel) {
      this.highestLevel = lvl;
      this.state.highestLevel = lvl;
    }
  }

  // 开始指定关卡
  startLevel(level: number): void {
    let lvl = level;
    if (lvl < 1) lvl = 1;
    if (lvl > GameDataManager.MAX_LEVEL) lvl = GameDataManager.MAX_LEVEL;
    if (lvl > this.highestLevel) this.highestLevel = lvl;
    if (this.inventory.length === 0) this.inventory = this.buildStartingInventory();

    this.state = this.createEmptyState();
    this.state.level = lvl;
    this.state.highestLevel = this.highestLevel;
    this.state.currency = this.currency;
    this.state.inventory = this.inventory;
    this.state.maxHp = this.metaMaxHp;
    this.state.hp = this.metaMaxHp;
    this.state.targetCount = GameDataManager.levelTarget(lvl);
    this.dealInitialCards();
  }

  // 关卡目标卡牌数：第 1 关 3 张，第 15 关 20 张，线性递增
  static levelTarget(level: number): number {
    let lvl = level;
    if (lvl < 1) lvl = 1;
    if (lvl > GameDataManager.MAX_LEVEL) lvl = GameDataManager.MAX_LEVEL;
    return 3 + Math.floor((lvl - 1) * 17 / 14);
  }

  // 初始硬币背包（覆盖 9 种硬币，便于功能验证）
  private buildStartingInventory(): CoinStack[] {
    const inv: CoinStack[] = [];
    this.addToStack(inv, CoinType.Normal, 1, 4);
    this.addToStack(inv, CoinType.Normal, 2, 3);
    this.addToStack(inv, CoinType.Normal, 3, 2);
    this.addToStack(inv, CoinType.Normal, 5, 2);
    this.addToStack(inv, CoinType.Normal, 10, 1);
    this.addToStack(inv, CoinType.Multiply, 2, 2);
    this.addToStack(inv, CoinType.Multiply, 3, 1);
    this.addToStack(inv, CoinType.Freeze, 1, 1);
    this.addToStack(inv, CoinType.Discount, 20, 1);
    this.addToStack(inv, CoinType.Copy, 1, 1);
    this.addToStack(inv, CoinType.Wild, 1, 1);
    this.addToStack(inv, CoinType.Growth, 1, 1);
    this.addToStack(inv, CoinType.Heal, 1, 2);
    this.addToStack(inv, CoinType.Disturb, 7, 1);
    return inv;
  }

  // 向指定背包追加硬币（自动合并同类型同数值）
  private addToStack(inv: CoinStack[], type: CoinType, value: number, count: number): void {
    for (let i = 0; i < inv.length; i++) {
      const s = inv[i];
      if (s.type === type && s.value === value) {
        s.count += count;
        return;
      }
    }
    inv.push({ type: type, value: value, count: count });
  }

  // 公开：向玩家背包追加硬币
  addCoin(type: CoinType, value: number, count: number): void {
    this.addToStack(this.state.inventory, type, value, count);
  }

  // 切换背包中某硬币数值的正负号（与目标堆叠合并）
  flipCoinSign(type: CoinType, value: number): void {
    const inv = this.state.inventory;
    for (let i = 0; i < inv.length; i++) {
      const s = inv[i];
      if (s.type === type && s.value === value) {
        const count = s.count;
        inv.splice(i, 1);
        this.addToStack(inv, type, -value, count);
        return;
      }
    }
  }

  // 消耗指定硬币，成功返回 true
  consumeCoin(type: CoinType, value: number, count: number): boolean {
    const inv = this.state.inventory;
    for (let i = 0; i < inv.length; i++) {
      const s = inv[i];
      if (s.type === type && s.value === value) {
        if (s.count < count) return false;
        s.count -= count;
        if (s.count <= 0) inv.splice(i, 1);
        return true;
      }
    }
    return false;
  }

  // 查询某类型某数值硬币的数量
  stackCount(type: CoinType, value: number): number {
    const inv = this.state.inventory;
    for (let i = 0; i < inv.length; i++) {
      const s = inv[i];
      if (s.type === type && s.value === value) return s.count;
    }
    return 0;
  }

  // 硬币总枚数
  coinTotal(): number {
    let n = 0;
    const inv = this.state.inventory;
    for (let i = 0; i < inv.length; i++) n += inv[i].count;
    return n;
  }

  // 背包中不重复硬币类型的数量
  distinctTypeCount(): number {
    const seen: string[] = [];
    const inv = this.state.inventory;
    for (let i = 0; i < inv.length; i++) {
      const t = inv[i].type;
      let found = false;
      for (let j = 0; j < seen.length; j++) {
        if (seen[j] === t) { found = true; break; }
      }
      if (!found) seen.push(t);
    }
    return seen.length;
  }

  // 背包中硬币类型中文名列表（用 / 分隔，用于摘要显示）
  typeNameList(): string {
    const names: string[] = [];
    const inv = this.state.inventory;
    for (let i = 0; i < inv.length; i++) {
      const name = coinTypeName(inv[i].type);
      let found = false;
      for (let j = 0; j < names.length; j++) {
        if (names[j] === name) { found = true; break; }
      }
      if (!found) names.push(name);
    }
    let out = '';
    for (let i = 0; i < names.length; i++) {
      if (i > 0) out += '/';
      out += names[i];
    }
    return out;
  }

  // 随机整数 [min, max]
  randomInt(min: number, max: number): number {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  // 发一张卡牌
  private dealCard(): void {
    const pool = GameDataManager.TARGET_POOL;
    const target = pool[this.randomInt(0, pool.length - 1)];
    const card: Card = {
      id: this.state.nextCardId,
      target: target,
      originalTarget: target,
      countdown: GameDataManager.CARD_COUNTDOWN,
      frozen: false,
      healAmount: 0,
      copyArmed: false,
      coins: [],
      eliminated: false,
      special: false,
      specialType: '',
    };
    this.state.nextCardId++;
    this.state.cards.push(card);
  }

  // 初始发牌，填满场上卡牌区
  private dealInitialCards(): void {
    while (this.state.cards.length < GameDataManager.FIELD_CARD_COUNT) {
      this.dealCard();
    }
  }

  // 查找卡牌
  findCard(cardId: number): Card | undefined {
    const cards = this.state.cards;
    for (let i = 0; i < cards.length; i++) {
      if (cards[i].id === cardId) return cards[i];
    }
    return undefined;
  }

  // 移除卡牌
  private removeCard(cardId: number): void {
    const cards = this.state.cards;
    for (let i = 0; i < cards.length; i++) {
      if (cards[i].id === cardId) { cards.splice(i, 1); return; }
    }
  }

  // 将硬币放置到卡牌上（算式硬币追加；特殊硬币立即生效）
  placeCoinOnCard(cardId: number, type: CoinType, value: number): boolean {
    const card = this.findCard(cardId);
    if (!card || card.eliminated) return false;
    if (this.stackCount(type, value) <= 0) return false;

    // 特殊硬币：放置即生效
    if (type === CoinType.Freeze) {
      card.frozen = true;
      this.consumeCoin(type, value, 1);
      return true;
    }
    if (type === CoinType.Discount) {
      this.applyDiscount(card, value);
      this.consumeCoin(type, value, 1);
      return true;
    }
    if (type === CoinType.Heal) {
      card.healAmount += value;
      this.consumeCoin(type, value, 1);
      return true;
    }
    if (type === CoinType.Copy) {
      card.copyArmed = true;
      this.consumeCoin(type, value, 1);
      return true;
    }
    if (type === CoinType.Wild) {
      this.consumeCoin(type, value, 1);
      this.eliminateCard(card);
      return true;
    }

    // 算式硬币：普通 / 乘法 / 增长 / 干扰
    // 数值正负决定运算符：正数用 + / ×，负数用 − / ÷
    const negative = value < 0;
    let op = 'add';
    if (type === CoinType.Multiply) op = negative ? 'div' : 'mul';
    else if (negative) op = 'sub';
    const placed: PlacedCoin = { type: type, value: Math.abs(value), op: op };
    card.coins.push(placed);
    this.consumeCoin(type, value, 1);
    return true;
  }

  // 折扣：按百分比降低目标数字（上限 100%）
  private applyDiscount(card: Card, percent: number): void {
    let p = percent;
    if (p < 0) p = 0;
    if (p > GameDataManager.DISCOUNT_MAX) p = GameDataManager.DISCOUNT_MAX;
    card.target = Math.max(1, Math.round(card.target * (100 - p) / 100));
  }

  // 切换已放置硬币的运算符（普通/增长/干扰：+/-；乘法：×/÷）
  togglePlacedCoin(cardId: number, index: number): void {
    const card = this.findCard(cardId);
    if (!card || index < 0 || index >= card.coins.length) return;
    const c = card.coins[index];
    if (c.type === CoinType.Multiply) {
      c.op = c.op === 'mul' ? 'div' : 'mul';
    } else {
      c.op = c.op === 'sub' ? 'add' : 'sub';
    }
  }

  // 移除已放置硬币并归还背包
  removePlacedCoin(cardId: number, index: number): boolean {
    const card = this.findCard(cardId);
    if (!card || index < 0 || index >= card.coins.length) return false;
    const c = card.coins[index];
    card.coins.splice(index, 1);
    // 归还时保留正负（运算符为 − / ÷ 时归还负数）
    const sign = (c.op === 'sub' || c.op === 'div') ? -1 : 1;
    this.addCoin(c.type, c.value * sign, 1);
    return true;
  }

  // 将已放置硬币移动到另一张卡牌（保留运算符，不经过背包）
  movePlacedCoin(fromCardId: number, index: number, toCardId: number): boolean {
    const from = this.findCard(fromCardId);
    const to = this.findCard(toCardId);
    if (!from || !to || from === to || index < 0 || index >= from.coins.length) return false;
    const c = from.coins[index];
    from.coins.splice(index, 1);
    to.coins.push(c);
    return true;
  }

  // 计算卡牌算式结果（按放置顺序从左到右；÷ 向下取整）
  evaluateCard(card: Card): number {
    let total = 0;
    for (let i = 0; i < card.coins.length; i++) {
      const c = card.coins[i];
      if (c.type === CoinType.Multiply) {
        if (c.op === 'div') {
          total = c.value === 0 ? total : Math.floor(total / c.value);
        } else {
          total = total * c.value;
        }
      } else {
        if (c.op === 'sub') total = total - c.value;
        else total = total + c.value;
      }
    }
    return total;
  }

  // 确定消除
  confirmCard(cardId: number): ConfirmResult {
    const result: ConfirmResult = {
      ok: false,
      reason: 'none',
      total: 0,
      target: 0,
      healGained: 0,
      copiedValue: 0,
    };
    const card = this.findCard(cardId);
    if (!card) return result;
    result.target = card.target;
    if (card.eliminated) { result.reason = 'eliminated'; return result; }
    const total = this.evaluateCard(card);
    result.total = total;
    if (card.coins.length === 0) { result.reason = 'no_coin'; return result; }
    if (total !== card.target) { result.reason = 'mismatch'; return result; }
    const r = this.eliminateCard(card);
    result.ok = true;
    result.reason = 'ok';
    result.healGained = r.healGained;
    result.copiedValue = r.copiedValue;
    return result;
  }

  // 消除卡牌（confirm 与万能硬币共用），触发回复/复制，并补发新卡
  private eliminateCard(card: Card): { healGained: number; copiedValue: number } {
    card.eliminated = true;
    this.state.eliminatedCount++;
    let healGained = 0;
    if (card.healAmount > 0) {
      healGained = card.healAmount;
      this.state.hp = Math.min(this.state.maxHp, this.state.hp + healGained);
    }
    let copiedValue = 0;
    if (card.copyArmed) {
      copiedValue = card.target;
      this.addCoin(CoinType.Normal, copiedValue, 1);
    }
    this.removeCard(card.id);
    this.dealCard();
    this.checkWin();
    return { healGained: healGained, copiedValue: copiedValue };
  }

  // 回合结算
  endTurn(): TurnResult {
    this.state.turn++;
    let hpLost = 0;
    let expiredCount = 0;
    const cards = this.state.cards;

    // 1. 倒计时扣减与扣血
    for (let i = cards.length - 1; i >= 0; i--) {
      const card = cards[i];
      if (card.frozen) { card.frozen = false; continue; }
      card.countdown--;
      if (card.countdown <= 0) {
        hpLost++;
        expiredCount++;
        this.state.hp--;
        cards.splice(i, 1);
      }
    }

    // 2. 场上增长硬币数值翻倍
    for (let ci = 0; ci < cards.length; ci++) {
      const card = cards[ci];
      for (let pi = 0; pi < card.coins.length; pi++) {
        const pc = card.coins[pi];
        if (pc.type === CoinType.Growth) {
          pc.value = Math.min(GameDataManager.COIN_MAX_VALUE, pc.value * 2);
        }
      }
    }

    // 3. 背包中未使用的干扰硬币自动消失
    const inv = this.state.inventory;
    for (let i = inv.length - 1; i >= 0; i--) {
      if (inv[i].type === CoinType.Disturb) inv.splice(i, 1);
    }

    // 4. 补发卡牌
    while (cards.length < GameDataManager.FIELD_CARD_COUNT) this.dealCard();

    // 5. 胜负判定
    let won = false;
    let lost = false;
    if (this.state.hp <= 0) {
      this.state.hp = 0;
      this.state.status = 'lost';
      lost = true;
    } else {
      this.checkWin();
      won = this.state.status === 'won';
    }
    return { hpLost: hpLost, expiredCount: expiredCount, won: won, lost: lost };
  }

  // 检查是否达成关卡目标
  private checkWin(): void {
    if (this.state.eliminatedCount >= this.state.targetCount && this.state.status === 'playing') {
      this.state.status = this.state.level >= GameDataManager.MAX_LEVEL ? 'complete' : 'won';
    }
  }

  // 关卡胜利后的奖励（货币 + 随机新硬币），返回奖励信息供 UI 展示
  applyWinRewards(): { currency: number; coinType: CoinType; coinValue: number } {
    const gain = 50 + this.state.level * 10;
    this.state.currency += gain;
    this.currency = this.state.currency;
    const r = this.randomRewardCoin();
    this.addCoin(r.type, r.value, 1);
    return { currency: gain, coinType: r.type, coinValue: r.value };
  }

  // 随机奖励硬币
  private randomRewardCoin(): CoinStack {
    const r = this.randomInt(1, 100);
    if (r <= 60) return { type: CoinType.Normal, value: this.randomInt(1, 10), count: 1 };
    if (r <= 80) return { type: CoinType.Multiply, value: this.randomInt(2, 4), count: 1 };
    const specials: CoinType[] = [CoinType.Freeze, CoinType.Heal, CoinType.Growth, CoinType.Disturb];
    return { type: specials[this.randomInt(0, specials.length - 1)], value: 1, count: 1 };
  }

  // ===== 局外养成（第六步） =====

  // 硬币数值上限（折扣硬币为百分比上限 100）
  private coinCap(type: CoinType): number {
    return type === CoinType.Discount ? GameDataManager.DISCOUNT_MAX : GameDataManager.COIN_MAX_VALUE;
  }

  // 合成两枚同类型硬币：数值相加，上限 999（折扣 100%）
  synthesizeCoins(type: CoinType, valueA: number, valueB: number): { ok: boolean; resultValue: number } {
    if (this.stackCount(type, valueA) < 1) return { ok: false, resultValue: 0 };
    if (valueA === valueB && this.stackCount(type, valueA) < 2) return { ok: false, resultValue: 0 };
    if (valueA !== valueB && this.stackCount(type, valueB) < 1) return { ok: false, resultValue: 0 };
    this.consumeCoin(type, valueA, 1);
    this.consumeCoin(type, valueB, 1);
    const sum = Math.min(this.coinCap(type), valueA + valueB);
    this.addCoin(type, sum, 1);
    return { ok: true, resultValue: sum };
  }

  // 自动合成一次：取同类型中两枚最小数值的硬币
  synthesizeOnce(): { ok: boolean; type: CoinType; valueA: number; valueB: number; resultValue: number } {
    for (let t = 0; t < COIN_TYPE_ORDER.length; t++) {
      const type = COIN_TYPE_ORDER[t];
      const values: number[] = [];
      const inv = this.state.inventory;
      for (let i = 0; i < inv.length; i++) {
        if (inv[i].type === type) {
          for (let k = 0; k < inv[i].count; k++) values.push(inv[i].value);
        }
      }
      if (values.length < 2) continue;
      let i1 = 0;
      let i2 = 1;
      if (values[i2] < values[i1]) { const tmp = i1; i1 = i2; i2 = tmp; }
      for (let i = 2; i < values.length; i++) {
        if (values[i] < values[i1]) { i2 = i1; i1 = i; }
        else if (values[i] < values[i2]) { i2 = i; }
      }
      const a = values[i1];
      const b = values[i2];
      const r = this.synthesizeCoins(type, a, b);
      return { ok: r.ok, type: type, valueA: a, valueB: b, resultValue: r.resultValue };
    }
    return { ok: false, type: CoinType.Normal, valueA: 0, valueB: 0, resultValue: 0 };
  }

  // 删除硬币（消耗删除次数）
  deleteCoin(type: CoinType, value: number, count: number): { ok: boolean; reason: string } {
    if (this.deleteCredits < count) return { ok: false, reason: '删除次数不足' };
    if (!this.consumeCoin(type, value, count)) return { ok: false, reason: '硬币不足' };
    this.deleteCredits -= count;
    return { ok: true, reason: '' };
  }

  // 删除背包中第一枚硬币
  deleteOnce(): { ok: boolean; type: CoinType; value: number; reason: string } {
    const inv = this.state.inventory;
    if (inv.length === 0) return { ok: false, type: CoinType.Normal, value: 0, reason: '背包为空' };
    const st = inv[0];
    const r = this.deleteCoin(st.type, st.value, 1);
    return { ok: r.ok, type: st.type, value: st.value, reason: r.reason };
  }

  // 强化血量上限（上限 5）
  upgradeMaxHp(): { ok: boolean; cost: number; newMaxHp: number; reason: string } {
    const cost = 100;
    if (this.metaMaxHp >= GameDataManager.MAX_HP) return { ok: false, cost: cost, newMaxHp: this.metaMaxHp, reason: '已达上限' };
    if (this.currency < cost) return { ok: false, cost: cost, newMaxHp: this.metaMaxHp, reason: '货币不足' };
    this.currency -= cost;
    this.state.currency = this.currency;
    this.metaMaxHp += 1;
    this.state.maxHp = this.metaMaxHp;
    return { ok: true, cost: cost, newMaxHp: this.metaMaxHp, reason: '' };
  }

  // 强化删除次数（每次 +2）
  upgradeDeleteCredits(): { ok: boolean; cost: number; newCredits: number; reason: string } {
    const cost = 80;
    if (this.currency < cost) return { ok: false, cost: cost, newCredits: this.deleteCredits, reason: '货币不足' };
    this.currency -= cost;
    this.state.currency = this.currency;
    this.deleteCredits += 2;
    return { ok: true, cost: cost, newCredits: this.deleteCredits, reason: '' };
  }

  // 扫荡（接口预留）：奖励按最高关卡计，货币上限 1000
  sweepLevel(): { ok: boolean; currency: number; coinType: CoinType; coinValue: number; reason: string } {
    if (this.highestLevel < 2) return { ok: false, currency: 0, coinType: CoinType.Normal, coinValue: 0, reason: '通关首关后开启' };
    const gain = Math.min(1000, this.highestLevel * 30);
    this.currency += gain;
    this.state.currency = this.currency;
    const r = this.randomRewardCoin();
    this.addCoin(r.type, r.value, 1);
    return { ok: true, currency: gain, coinType: r.type, coinValue: r.value, reason: '' };
  }
}
