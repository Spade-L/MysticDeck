(async function(config) {
  'use strict';
  const root = new URL('.', document.baseURI);
  const blobs = [];
  const pending = new Map();
  const queue = [];
  const cancelLoads = new Set();
  let failure = null;
  let clearResources = () => {};
  let active = 0, loaded = 0;
  const total = Object.values(config.records).reduce((sum, file) => sum + file.size, 0);
  const checksum = async bytes => Array.from(new Uint8Array(await crypto.subtle.digest('SHA-256', bytes)), byte => byte.toString(16).padStart(2, '0')).join('');
  const fail = error => {
    if (failure) return;
    failure = error;
    for (const job of queue.splice(0)) job.reject(error);
    for (const cancel of Array.from(cancelLoads)) cancel(error);
    clearResources();
    release();
    console.error(error);
    window.doraSetState('faulted', error.message || String(error));
  };
  const release = () => { for (const url of blobs) URL.revokeObjectURL(url); blobs.length = 0; };
  window.addEventListener('pagehide', event => { if (!event.persisted) { clearResources(); release(); } });
  function pump() {
    while (!failure && active < 4 && queue.length) {
      const {name, resolve, reject} = queue.shift();
      const record = config.records[name];
      const script = document.createElement('script');
      active++;
      let delivered = false, finished = false;
      const finish = () => {
        if (finished) return;
        finished = true;
        clearTimeout(timer);
        script.remove();
        pending.delete(name);
        cancelLoads.delete(cancel);
        active--;
        pump();
      };
      const cancel = error => { reject(error); finish(); };
      const timer = setTimeout(() => { reject(new Error('Timed out loading ' + record.script)); finish(); }, 120000);
      cancelLoads.add(cancel);
      pending.set(name, encoded => {
        if (delivered) return;
        delivered = true;
        (async () => {
          const raw = atob(encoded);
          if (raw.length !== record.size) throw new Error('HTML asset size mismatch: ' + name);
          const bytes = new Uint8Array(raw.length);
          for (let index = 0; index < raw.length; index++) bytes[index] = raw.charCodeAt(index);
          if (await checksum(bytes) !== record.sha256) throw new Error('HTML asset checksum mismatch: ' + name);
          if (failure) return;
          loaded += bytes.length;
          window.doraSetProgress(0.5 * loaded / total, 'Loading game resources…');
          resolve(bytes);
        })().catch(reject).finally(finish);
      });
      script.onload = () => { if (!delivered) { reject(new Error('Invalid HTML asset: ' + record.script)); finish(); } };
      script.onerror = () => { reject(new Error('Unable to load ' + record.script + '. Extract the entire ZIP before opening index.html.')); finish(); };
      script.src = new URL(record.script, root).href;
      document.body.appendChild(script);
    }
  }
  function read(name) {
    if (failure) return Promise.reject(failure);
    if (!Object.hasOwn(config.records, name)) return Promise.reject(new Error('Unknown HTML asset: ' + name));
    return new Promise((resolve, reject) => { queue.push({name, resolve, reject}); pump(); });
  }
  window.DoraHtmlPackage = Object.freeze({deliver: (name, encoded) => pending.get(name)?.(encoded)});
  try {
    if (!window.WebAssembly || !window.crypto?.subtle) throw new Error('Please use a modern browser with WebAssembly and Web Crypto support.');
    const names = Object.keys(config.records);
    const values = await Promise.all(names.map(read));
    const files = new Map(names.map((name, index) => [name, values[index]]));
    delete window.DoraHtmlPackage;
    let preload = files.get('dora-player-runtime.data').buffer;
    clearResources = () => {
      preload = null;
      delete Module.doraSnapshot;
      delete Module.wasmBinary;
      delete Module.getPreloadedPackage;
      files.clear();
      values.length = 0;
    };
    Module.wasmBinary = files.get('dora-player-runtime.wasm');
    Module.getPreloadedPackage = () => { const bytes = preload; preload = null; return bytes; };
    Module.doraSnapshot = {manifest: config.manifest, files: config.manifest.files.map(file => ({path: file.path, bytes: files.get(decodeURIComponent(file.url))}))};
    // file:// pages share an opaque origin: isolate saves by package directory.
    Module.doraStorageId = 'html-' + await checksum(new TextEncoder().encode(root.href));
    const audio = new Map();
    for (const [name, type] of [['dora-audio-mixer.wasm', 'application/wasm'], ['audio-worklet.js', 'text/javascript']]) {
      // A worklet module fetched from blob:null is rejected by Chromium on file://.
      // A data URL can be imported by the worklet without an origin or disk fetch.
      if (name === 'audio-worklet.js') {
        let source = '';
        for (const byte of files.get(name)) source += String.fromCharCode(byte);
        audio.set(name, 'data:text/javascript;base64,' + btoa(source));
        continue;
      }
      const url = URL.createObjectURL(new Blob([files.get(name)], {type}));
      audio.set(name, url);
      blobs.push(url);
    }
    Module.locateFile = (name, prefix = '') => audio.get(name) || new URL(name, prefix || root).href;
    const initialized = Module.onRuntimeInitialized;
    Module.onRuntimeInitialized = function() {
      clearResources();
      initialized?.();
    };
    const aborted = Module.onAbort;
    Module.onAbort = function(reason) {
      fail(new Error(String(reason || 'Runtime aborted')));
      aborted?.(reason);
    };
    const script = document.createElement('script');
    script.src = new URL('dora-player-runtime.js', root).href;
    script.onerror = () => fail(new Error('Unable to load the engine. Extract the entire ZIP before opening index.html.'));
    document.body.appendChild(script);
  } catch (error) { fail(error); }
})({"manifest":{"format":"dora-web-game","version":1,"engineVersion":"1.9.3","profile":"dora-preset","entry":"init.lua","files":[{"path":"Audio/bgm.ogg","url":"assets/f55daba9c9a25cd0558d18b963ae1313eb044bc2e0b5696d011c139637d4434a/Audio/bgm.ogg","size":693988,"sha256":"f55daba9c9a25cd0558d18b963ae1313eb044bc2e0b5696d011c139637d4434a","startup":true},{"path":"Audio/card_paper.wav","url":"assets/b5418b8e813fa7bc18ea98045fab2af89bfae502527c1ec02c763c764042341e/Audio/card_paper.wav","size":176444,"sha256":"b5418b8e813fa7bc18ea98045fab2af89bfae502527c1ec02c763c764042341e","startup":true},{"path":"Audio/coin.wav","url":"assets/f6e401bce8050182a7b92006f1cb4474180d1fb449631d20c608216ba5aeadcd/Audio/coin.wav","size":176444,"sha256":"f6e401bce8050182a7b92006f1cb4474180d1fb449631d20c608216ba5aeadcd","startup":true},{"path":"Music/Bgm.lua","url":"assets/c311013d0cc2bdc7a6d71076c849f88f3c71acd46879aaaadb549ef1c5faab46/Music/Bgm.lua","size":2441,"sha256":"c311013d0cc2bdc7a6d71076c849f88f3c71acd46879aaaadb549ef1c5faab46","startup":true},{"path":"Music/Bgm.ts","url":"assets/f60a0f4d75ea2a4947070743cc4e6018686fa1507d9b82a829d4275dbff54fa4/Music/Bgm.ts","size":2854,"sha256":"f60a0f4d75ea2a4947070743cc4e6018686fa1507d9b82a829d4275dbff54fa4","startup":true},{"path":"Music/CardSfx.lua","url":"assets/7d175cfbbc082365eef5b63aa2ec2703686441fa2e01d8079922f76c0df363c3/Music/CardSfx.lua","size":485,"sha256":"7d175cfbbc082365eef5b63aa2ec2703686441fa2e01d8079922f76c0df363c3","startup":true},{"path":"Music/CardSfx.ts","url":"assets/18cad02691cb2d21a5ba8f1a68af89f167e52c565c995862a0770e45549ddb90/Music/CardSfx.ts","size":663,"sha256":"18cad02691cb2d21a5ba8f1a68af89f167e52c565c995862a0770e45549ddb90","startup":true},{"path":"Music/CoinSfx.lua","url":"assets/aff5c04b21263c7119eea35716c25471a981f64a6ce040097fecee274beac29f/Music/CoinSfx.lua","size":474,"sha256":"aff5c04b21263c7119eea35716c25471a981f64a6ce040097fecee274beac29f","startup":true},{"path":"Music/CoinSfx.ts","url":"assets/1ef2a0f4235c810e457aa35c7b82eef7e92fc2fe33f3ff594ab6a634dac2a276/Music/CoinSfx.ts","size":636,"sha256":"1ef2a0f4235c810e457aa35c7b82eef7e92fc2fe33f3ff594ab6a634dac2a276","startup":true},{"path":"dora-package.json","url":"assets/67490498cd6f7728312177d4602873f77fae0e56364cbe72acf49c9191ec482c/dora-package.json","size":95,"sha256":"67490498cd6f7728312177d4602873f77fae0e56364cbe72acf49c9191ec482c","startup":true},{"path":"game/GameDataManager.lua","url":"assets/190697a78e21bd0f6e8f33277b7f5635dbc6424b9e042175ffad4a7052ded087/game/GameDataManager.lua","size":24825,"sha256":"190697a78e21bd0f6e8f33277b7f5635dbc6424b9e042175ffad4a7052ded087","startup":true},{"path":"game/GameDataManager.ts","url":"assets/724d4e48f87ac4d26dc27c44e0370db0527cb6d9318a95bcb3a798a90f14a6ee/game/GameDataManager.ts","size":20594,"sha256":"724d4e48f87ac4d26dc27c44e0370db0527cb6d9318a95bcb3a798a90f14a6ee","startup":true},{"path":"game/GameUI.lua","url":"assets/253cf8d0b1da5bcaba35b72e51cdc73f814d820ea7fcbb319738a4f2e3e4bd5d/game/GameUI.lua","size":57682,"sha256":"253cf8d0b1da5bcaba35b72e51cdc73f814d820ea7fcbb319738a4f2e3e4bd5d","startup":true},{"path":"game/GameUI.ts","url":"assets/2d34364008d506649a270fb42758ff941fc7470f37f9597fe8c1f118f8d545c9/game/GameUI.ts","size":44624,"sha256":"2d34364008d506649a270fb42758ff941fc7470f37f9597fe8c1f118f8d545c9","startup":true},{"path":"game/SaveData.lua","url":"assets/6b5439337a9f205a7459c0a8baa3b96433d86302e95e45518bbc3d95e0f1ed0e/game/SaveData.lua","size":2004,"sha256":"6b5439337a9f205a7459c0a8baa3b96433d86302e95e45518bbc3d95e0f1ed0e","startup":true},{"path":"game/SaveData.ts","url":"assets/10851a6d2b9df3f77674db9af41c12d680185055e23746ff5302843c5c5de96d/game/SaveData.ts","size":1129,"sha256":"10851a6d2b9df3f77674db9af41c12d680185055e23746ff5302843c5c5de96d","startup":true},{"path":"game/types.lua","url":"assets/95eff1df29fc9c735020f33ba8b0ab41517e318ae3be14a287eaf93b1b28e4f5/game/types.lua","size":2313,"sha256":"95eff1df29fc9c735020f33ba8b0ab41517e318ae3be14a287eaf93b1b28e4f5","startup":true},{"path":"game/types.ts","url":"assets/240991dad2b1431d56c1c602795391ab0a4ebab2e17d8c3621d3b6415e2e717e/game/types.ts","size":4031,"sha256":"240991dad2b1431d56c1c602795391ab0a4ebab2e17d8c3621d3b6415e2e717e","startup":true},{"path":"init.lua","url":"assets/c442244f9b883c62df8c3f53d3620a9d81faa5f09564f135a7b6b347861120ab/init.lua","size":596,"sha256":"c442244f9b883c62df8c3f53d3620a9d81faa5f09564f135a7b6b347861120ab","startup":true},{"path":"init.ts","url":"assets/359245543b732af9224b70acaa4ac7b68b81c46b1a1d436417d82b4ad0fe4adf/init.ts","size":416,"sha256":"359245543b732af9224b70acaa4ac7b68b81c46b1a1d436417d82b4ad0fe4adf","startup":true}]},"records":{"dora-player-runtime.wasm":{"script":"html-assets/0.js","size":12914382,"sha256":"c1b5ad8f7761ddee5a9e98638dc7768becaa16cabb4f7d5b518e35a48d968c09"},"dora-player-runtime.data":{"script":"html-assets/1.js","size":16902659,"sha256":"fe50cba2d69b78d41a06cc5a90970f34e64c02e4c68d04920b6066b918292d17"},"dora-audio-mixer.wasm":{"script":"html-assets/2.js","size":257583,"sha256":"77bc80abff5b7da9d8b70e82f0204542c6461616cb4a35f22ed8263e60d92329"},"audio-worklet.js":{"script":"html-assets/3.js","size":4811,"sha256":"0a69374be7060caf6651b1335b418df062345d4666d36f8d4638b06b2a97c76b"},"assets/f55daba9c9a25cd0558d18b963ae1313eb044bc2e0b5696d011c139637d4434a/Audio/bgm.ogg":{"script":"html-assets/4.js","size":693988,"sha256":"f55daba9c9a25cd0558d18b963ae1313eb044bc2e0b5696d011c139637d4434a"},"assets/b5418b8e813fa7bc18ea98045fab2af89bfae502527c1ec02c763c764042341e/Audio/card_paper.wav":{"script":"html-assets/5.js","size":176444,"sha256":"b5418b8e813fa7bc18ea98045fab2af89bfae502527c1ec02c763c764042341e"},"assets/f6e401bce8050182a7b92006f1cb4474180d1fb449631d20c608216ba5aeadcd/Audio/coin.wav":{"script":"html-assets/6.js","size":176444,"sha256":"f6e401bce8050182a7b92006f1cb4474180d1fb449631d20c608216ba5aeadcd"},"assets/c311013d0cc2bdc7a6d71076c849f88f3c71acd46879aaaadb549ef1c5faab46/Music/Bgm.lua":{"script":"html-assets/7.js","size":2441,"sha256":"c311013d0cc2bdc7a6d71076c849f88f3c71acd46879aaaadb549ef1c5faab46"},"assets/f60a0f4d75ea2a4947070743cc4e6018686fa1507d9b82a829d4275dbff54fa4/Music/Bgm.ts":{"script":"html-assets/8.js","size":2854,"sha256":"f60a0f4d75ea2a4947070743cc4e6018686fa1507d9b82a829d4275dbff54fa4"},"assets/7d175cfbbc082365eef5b63aa2ec2703686441fa2e01d8079922f76c0df363c3/Music/CardSfx.lua":{"script":"html-assets/9.js","size":485,"sha256":"7d175cfbbc082365eef5b63aa2ec2703686441fa2e01d8079922f76c0df363c3"},"assets/18cad02691cb2d21a5ba8f1a68af89f167e52c565c995862a0770e45549ddb90/Music/CardSfx.ts":{"script":"html-assets/10.js","size":663,"sha256":"18cad02691cb2d21a5ba8f1a68af89f167e52c565c995862a0770e45549ddb90"},"assets/aff5c04b21263c7119eea35716c25471a981f64a6ce040097fecee274beac29f/Music/CoinSfx.lua":{"script":"html-assets/11.js","size":474,"sha256":"aff5c04b21263c7119eea35716c25471a981f64a6ce040097fecee274beac29f"},"assets/1ef2a0f4235c810e457aa35c7b82eef7e92fc2fe33f3ff594ab6a634dac2a276/Music/CoinSfx.ts":{"script":"html-assets/12.js","size":636,"sha256":"1ef2a0f4235c810e457aa35c7b82eef7e92fc2fe33f3ff594ab6a634dac2a276"},"assets/67490498cd6f7728312177d4602873f77fae0e56364cbe72acf49c9191ec482c/dora-package.json":{"script":"html-assets/13.js","size":95,"sha256":"67490498cd6f7728312177d4602873f77fae0e56364cbe72acf49c9191ec482c"},"assets/190697a78e21bd0f6e8f33277b7f5635dbc6424b9e042175ffad4a7052ded087/game/GameDataManager.lua":{"script":"html-assets/14.js","size":24825,"sha256":"190697a78e21bd0f6e8f33277b7f5635dbc6424b9e042175ffad4a7052ded087"},"assets/724d4e48f87ac4d26dc27c44e0370db0527cb6d9318a95bcb3a798a90f14a6ee/game/GameDataManager.ts":{"script":"html-assets/15.js","size":20594,"sha256":"724d4e48f87ac4d26dc27c44e0370db0527cb6d9318a95bcb3a798a90f14a6ee"},"assets/253cf8d0b1da5bcaba35b72e51cdc73f814d820ea7fcbb319738a4f2e3e4bd5d/game/GameUI.lua":{"script":"html-assets/16.js","size":57682,"sha256":"253cf8d0b1da5bcaba35b72e51cdc73f814d820ea7fcbb319738a4f2e3e4bd5d"},"assets/2d34364008d506649a270fb42758ff941fc7470f37f9597fe8c1f118f8d545c9/game/GameUI.ts":{"script":"html-assets/17.js","size":44624,"sha256":"2d34364008d506649a270fb42758ff941fc7470f37f9597fe8c1f118f8d545c9"},"assets/6b5439337a9f205a7459c0a8baa3b96433d86302e95e45518bbc3d95e0f1ed0e/game/SaveData.lua":{"script":"html-assets/18.js","size":2004,"sha256":"6b5439337a9f205a7459c0a8baa3b96433d86302e95e45518bbc3d95e0f1ed0e"},"assets/10851a6d2b9df3f77674db9af41c12d680185055e23746ff5302843c5c5de96d/game/SaveData.ts":{"script":"html-assets/19.js","size":1129,"sha256":"10851a6d2b9df3f77674db9af41c12d680185055e23746ff5302843c5c5de96d"},"assets/95eff1df29fc9c735020f33ba8b0ab41517e318ae3be14a287eaf93b1b28e4f5/game/types.lua":{"script":"html-assets/20.js","size":2313,"sha256":"95eff1df29fc9c735020f33ba8b0ab41517e318ae3be14a287eaf93b1b28e4f5"},"assets/240991dad2b1431d56c1c602795391ab0a4ebab2e17d8c3621d3b6415e2e717e/game/types.ts":{"script":"html-assets/21.js","size":4031,"sha256":"240991dad2b1431d56c1c602795391ab0a4ebab2e17d8c3621d3b6415e2e717e"},"assets/c442244f9b883c62df8c3f53d3620a9d81faa5f09564f135a7b6b347861120ab/init.lua":{"script":"html-assets/22.js","size":596,"sha256":"c442244f9b883c62df8c3f53d3620a9d81faa5f09564f135a7b6b347861120ab"},"assets/359245543b732af9224b70acaa4ac7b68b81c46b1a1d436417d82b4ad0fe4adf/init.ts":{"script":"html-assets/23.js","size":416,"sha256":"359245543b732af9224b70acaa4ac7b68b81c46b1a1d436417d82b4ad0fe4adf"}}});
