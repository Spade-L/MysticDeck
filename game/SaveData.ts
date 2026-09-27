// 存档：最高关卡与音量设置（用简单的 key=value 文本，避免依赖 JSON）
import { Content, Path } from 'Dora';

export class SaveFile {
  highestLevel = 1;
  bgmVolume = 0.5;
  sfxVolume = 0.8;

  private path: string;

  constructor() {
    this.path = Path(Content.writablePath, 'lingshu_save.txt');
    this.load();
  }

  load(): void {
    const text = Content.load(this.path);
    if (text === undefined || text === '') return;
    const lines = text.split('\n');
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      const eq = line.indexOf('=');
      if (eq <= 0) continue;
      const key = line.substring(0, eq);
      const num = Number(line.substring(eq + 1));
      if (key === 'highestLevel') this.highestLevel = Math.floor(num);
      else if (key === 'bgmVolume') this.bgmVolume = num;
      else if (key === 'sfxVolume') this.sfxVolume = num;
    }
  }

  save(): void {
    const text = 'highestLevel=' + this.highestLevel + '\n'
      + 'bgmVolume=' + this.bgmVolume + '\n'
      + 'sfxVolume=' + this.sfxVolume + '\n';
    Content.save(this.path, text);
  }
}
