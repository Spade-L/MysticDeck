// 背景音乐：空灵 / 阴森的黑暗奇幻氛围
// 连绵无空隙的氛围垫音（pad）+ 极轻的高音泛音（sine）
// 无打击乐、无孤立短音，适合长时间循环
import type { MusicDefinition } from "Agent/Gen/Music";

export const definition: MusicDefinition = {
  output: "Audio/bgm.ogg",
  synth: {},
  seed: 41,
  score: {
    bpm: 50,
    beatsPerBar: 4,
    bars: 12,
    tracks: [
      {
        // 氛围垫音：连绵和弦（A 自然小调，首尾相接无空隙）
        instrument: "pad",
        role: "harmony",
        volume: 0.5,
        notes: [
          { pitch: "A2", start: 0, duration: 8, velocity: 0.3 },
          { pitch: "A3", start: 0, duration: 8, velocity: 0.24 },
          { pitch: "C4", start: 0, duration: 8, velocity: 0.26 },
          { pitch: "E4", start: 0, duration: 8, velocity: 0.26 },
          { pitch: "F2", start: 8, duration: 8, velocity: 0.3 },
          { pitch: "F3", start: 8, duration: 8, velocity: 0.24 },
          { pitch: "A3", start: 8, duration: 8, velocity: 0.26 },
          { pitch: "C4", start: 8, duration: 8, velocity: 0.26 },
          { pitch: "D2", start: 16, duration: 8, velocity: 0.3 },
          { pitch: "D3", start: 16, duration: 8, velocity: 0.24 },
          { pitch: "F3", start: 16, duration: 8, velocity: 0.26 },
          { pitch: "A3", start: 16, duration: 8, velocity: 0.26 },
          { pitch: "E2", start: 24, duration: 8, velocity: 0.3 },
          { pitch: "E3", start: 24, duration: 8, velocity: 0.24 },
          { pitch: "G3", start: 24, duration: 8, velocity: 0.26 },
          { pitch: "B3", start: 24, duration: 8, velocity: 0.26 },
          { pitch: "A2", start: 32, duration: 8, velocity: 0.3 },
          { pitch: "A3", start: 32, duration: 8, velocity: 0.24 },
          { pitch: "C4", start: 32, duration: 8, velocity: 0.26 },
          { pitch: "E4", start: 32, duration: 8, velocity: 0.26 },
          { pitch: "G2", start: 40, duration: 8, velocity: 0.3 },
          { pitch: "G3", start: 40, duration: 8, velocity: 0.24 },
          { pitch: "B3", start: 40, duration: 8, velocity: 0.26 },
          { pitch: "D4", start: 40, duration: 8, velocity: 0.26 },
        ],
      },
      {
        // 高音泛音：极轻、连绵（空灵感）
        instrument: "sine",
        role: "melody",
        volume: 0.26,
        notes: [
          { pitch: "E5", start: 0, duration: 8, velocity: 0.2 },
          { pitch: "C5", start: 8, duration: 8, velocity: 0.18 },
          { pitch: "A4", start: 16, duration: 8, velocity: 0.2 },
          { pitch: "B4", start: 24, duration: 8, velocity: 0.18 },
          { pitch: "E5", start: 32, duration: 8, velocity: 0.2 },
          { pitch: "D5", start: 40, duration: 8, velocity: 0.18 },
        ],
      },
    ],
  },
  audio: { volume: 0.264, stereo: true, reverb: 0.55 },
};
