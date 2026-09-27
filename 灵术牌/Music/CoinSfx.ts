// 硬币放置音效（引擎内置合成器生成的替代音，可从 freesound 替换 Audio/coin.wav）
import type { MusicDefinition } from "Agent/Gen/Music";

export const definition: MusicDefinition = {
  output: "Audio/coin.wav",
  synth: {},
  seed: 7,
  score: {
    bpm: 120,
    beatsPerBar: 2,
    bars: 1,
    tracks: [
      {
        instrument: "bell",
        role: "melody",
        notes: [
          { pitch: "B5", start: 0, duration: 0.2, velocity: 1 },
          { pitch: "E6", start: 0.25, duration: 0.6, velocity: 0.9 },
        ],
      },
    ],
  },
  audio: { volume: 0.42, stereo: true, reverb: 0.08 },
};
