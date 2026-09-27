// 卡牌确认消除音效：噪声音色近似纸张的短促“沙”声（音高偏低、力度柔和，避免尖锐）
import type { MusicDefinition } from "Agent/Gen/Music";

export const definition: MusicDefinition = {
  output: "Audio/card_paper.wav",
  synth: {},
  seed: 11,
  score: {
    bpm: 120,
    beatsPerBar: 2,
    bars: 1,
    tracks: [
      {
        instrument: "noise",
        role: "melody",
        notes: [
          { pitch: "C4", start: 0, duration: 0.14, velocity: 0.7 },
          { pitch: "G4", start: 0.16, duration: 0.22, velocity: 0.5 },
        ],
      },
    ],
  },
  audio: { volume: 0.35, stereo: true, reverb: 0.1 },
};
