// 《灵术牌》数据层 —— 枚举与数据结构定义

// 硬币类型枚举
export enum CoinType {
  Normal = 'normal',      // 普通硬币：数字用于加减
  Multiply = 'multiply',  // 乘法硬币：数字用于乘除
  Freeze = 'freeze',      // 冰冻硬币：冻结卡牌倒计时一回合
  Discount = 'discount',  // 折扣硬币：按百分比降低卡牌目标数字
  Copy = 'copy',          // 复制硬币：消除卡牌时复制目标数字
  Wild = 'wild',          // 万能硬币：无视条件直接消除卡牌
  Growth = 'growth',      // 增长硬币：放置在场上后每回合数值翻倍
  Heal = 'heal',          // 回复硬币：消除卡牌时回复血量
  Disturb = 'disturb',    // 干扰硬币：回合结束未使用则消失
}

// 硬币类型在 UI 中的分组展示顺序
export const COIN_TYPE_ORDER: CoinType[] = [
  CoinType.Normal,
  CoinType.Multiply,
  CoinType.Freeze,
  CoinType.Discount,
  CoinType.Copy,
  CoinType.Wild,
  CoinType.Growth,
  CoinType.Heal,
  CoinType.Disturb,
];

// 获取硬币类型中文名
export function coinTypeName(type: CoinType): string {
  switch (type) {
    case CoinType.Normal: return '普通';
    case CoinType.Multiply: return '乘法';
    case CoinType.Freeze: return '冰冻';
    case CoinType.Discount: return '折扣';
    case CoinType.Copy: return '复制';
    case CoinType.Wild: return '万能';
    case CoinType.Growth: return '增长';
    case CoinType.Heal: return '回复';
    case CoinType.Disturb: return '干扰';
    default: return '未知';
  }
}

// 放置在卡牌上的算式硬币（参与加减乘除运算）
export interface PlacedCoin {
  type: CoinType; // 硬币类型
  value: number;  // 数值
  op: string;     // 运算符：'add' 加 / 'sub' 减 / 'mul' 乘 / 'div' 除
}

// 背包中的硬币堆叠（同类型 + 同数值合并显示）
export interface CoinStack {
  type: CoinType; // 硬币类型
  value: number;  // 数值（折扣硬币为百分比；回复硬币为回复量）
  count: number;  // 数量
}

// 场上卡牌
export interface Card {
  id: number;            // 唯一编号
  target: number;        // 当前目标数字（受折扣影响）
  originalTarget: number;// 初始目标数字
  countdown: number;     // 倒计时
  frozen: boolean;       // 是否被冰冻（本回合不扣减倒计时）
  healAmount: number;    // 放置回复硬币后的回复量（0 表示未放置）
  copyArmed: boolean;    // 是否放置了复制硬币
  coins: PlacedCoin[];   // 已放置的算式硬币
  eliminated: boolean;   // 是否已消除
  special: boolean;      // 是否为 BOSS 特殊卡牌（预留）
  specialType: string;   // 特殊卡牌类型（预留，如 'shield'/'curse'）
}

// 整体游戏状态
export interface GameState {
  hp: number;             // 当前血量
  maxHp: number;          // 血量上限
  level: number;          // 当前关卡
  highestLevel: number;   // 历史最高关卡
  turn: number;           // 当前回合数
  targetCount: number;    // 本关需消除的卡牌数
  eliminatedCount: number;// 本关已消除的卡牌数
  currency: number;       // 货币
  cards: Card[];          // 场上卡牌
  inventory: CoinStack[]; // 硬币背包
  nextCardId: number;     // 卡牌编号自增
  status: string;         // 'playing' | 'won' | 'lost' | 'complete'
}

// 确定消除的结果
export interface ConfirmResult {
  ok: boolean;         // 是否成功消除
  reason: string;      // 失败原因：'none' | 'no_coin' | 'mismatch' | 'eliminated'
  total: number;       // 算式当前结果
  target: number;      // 卡牌目标数字
  healGained: number;  // 本次回复的血量
  copiedValue: number; // 本次复制的数值（0 表示无）
}

// 回合结算结果
export interface TurnResult {
  hpLost: number;       // 本回合扣血
  expiredCount: number; // 倒计时归零的卡牌数
  won: boolean;         // 是否达成关卡胜利
  lost: boolean;        // 是否游戏失败
}
