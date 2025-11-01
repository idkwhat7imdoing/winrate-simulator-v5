
#!/bin/zsh
cd ~/Downloads/winrate_simulator_v5

# 建立 index.html
cat > index.html <<'HTML'
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>勝率模擬器 v5</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <header style="display:flex;gap:12px;justify-content:center;margin-top:16px;">
    <button id="toggle-mode">🔄 切換模式</button>
    <button id="toggle-theme">🌗 切換主題</button>
  </header>

  <main style="display:flex;justify-content:center;padding:20px;">
    <section id="target-mode" style="max-width:720px;width:100%;">
      <div class="container card">
        <h1>🏆 勝率模擬器 v5</h1>
        <h2>🎯 目標勝率模式</h2>
        <div>
          <label>總場數：</label>
          <input id="total" type="number" placeholder="總場數">
        </div>
        <div>
          <label>目前勝率 (%)：</label>
          <input id="current" type="number" placeholder="%">
        </div>
        <div>
          <label>目標勝率 (%)：</label>
          <input id="goal" type="number" placeholder="%">
        </div>
        <div style="margin-top:12px;">
          <button id="calc-streak">計算需要連勝場數</button>
        </div>
      </div>
    </section>

    <section id="simulate-mode" style="display:none;max-width:720px;width:100%;">
      <div class="container card">
        <h2>📊 模擬未來對局模式</h2>
        <div>
          <label>接下來打幾局 (n)：</label>
          <input id="n" type="number" placeholder="n">
        </div>
        <div>
          <label>預計贏幾局 (a)：</label>
          <input id="win" type="number" placeholder="a">
        </div>
        <div>
          <label>預計輸幾局 (b)：</label>
          <input id="lose" type="number" placeholder="b">
        </div>
        <div style="margin-top:8px;">
          <label>目前勝率 (%)：</label>
          <input id="current2" type="number" placeholder="%">
        </div>
        <div>
          <label>總場數：</label>
          <input id="total2" type="number" placeholder="總場數">
        </div>
        <div style="margin-top:12px;">
          <button id="simulate">模擬新勝率</button>
        </div>
      </div>
    </section>
  </main>

  <div style="display:flex;justify-content:center;">
    <div class="container card" style="max-width:720px;">
      <div class="result" id="resultArea" style="min-height:36px;text-align:center;"></div>
    </div>
  </div>

  <footer style="text-align:center;padding:20px;color:var(--text);">© 2025 勝率模擬器 v5</footer>

  <script src="script.js"></script>
</body>
</html>
HTML

# 建立 style.css
cat > style.css <<'CSS'
/* ===== 全域設定 ===== */
*{margin:0;padding:0;box-sizing:border-box;font-family:"Inter","Noto Sans TC",sans-serif;transition:all .25s ease}
:root{
  --bg:#ffffff;
  --text:#222;
  --card:rgba(255,255,255,.85);
  --accent:#0072ff;
  --accent2:#00c6ff;
  --shadow:rgba(0,0,0,.08);
}
.dark{
  --bg:radial-gradient(circle at top,#0f0f12,#000);
  --text:#f1f1f1;
  --card:rgba(255,255,255,0.04);
  --accent:#00c6ff;
  --accent2:#0072ff;
  --shadow:rgba(0,0,0,.6);
}
body{background:var(--bg);color:var(--text);min-height:100vh;padding:28px;display:flex;flex-direction:column;align-items:center}
.container{background:var(--card);border-radius:14px;padding:18px;width:100%;max-width:480px;margin:12px;box-shadow:0 10px 30px var(--shadow)}
h1{font-size:1.6rem;margin-bottom:10px; background:linear-gradient(90deg,var(--accent),var(--accent2));-webkit-background-clip:text;-webkit-text-fill-color:transparent}
input[type="number"]{width:110px;padding:8px;border-radius:8px;border:1px solid rgba(255,255,255,0.06);background:transparent;color:inherit;margin:6px 6px;text-align:center}
input[type="number"]:focus{outline:none;box-shadow:0 0 8px rgba(0,198,255,0.12);transform:scale(1.02)}
button{position:relative;overflow:hidden;background:linear-gradient(135deg,var(--accent),var(--accent2));color:#fff;border:0;padding:10px 16px;border-radius:10px;cursor:pointer;margin:6px}
button::before{content:"";position:absolute;top:-50%;left:-50%;width:200%;height:200%;background:linear-gradient(120deg,transparent,rgba(255,255,255,0.28),transparent);transform:rotate(45deg);transition:all .6s ease;opacity:0;z-index:0}
button:hover::before{left:120%;opacity:1}
button:hover{transform:translateY(-3px);box-shadow:0 0 18px rgba(0,198,255,0.16)}
.result{margin-top:12px;font-size:1.05rem;color:var(--accent2);font-weight:600;text-align:center;padding:12px}
.header-buttons{display:flex;gap:12px;justify-content:center;margin-bottom:18px}
@keyframes fadeIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
@media (max-width:600px){body{padding:16px}.container{padding:12px;max-width:100%}input[type="number"]{width:80px}button{padding:8px 12px;font-size:.95rem}}
CSS

# 建立 script.js
cat > script.js <<'JS'
const btnToggleMode = document.getElementById('toggle-mode');
const btnToggleTheme = document.getElementById('toggle-theme');
const targetMode = document.getElementById('target-mode');
const simulateMode = document.getElementById('simulate-mode');
const resultArea = document.getElementById('resultArea');
let currentMode='target';

function showMode(mode){currentMode=mode;targetMode.style.display=mode==='target'?'block':'none';simulateMode.style.display=mode==='simulate'?'block':'none';}
showMode('target');

function applyTheme(theme){if(theme==='dark')document.body.classList.add('dark');else document.body.classList.remove('dark');localStorage.setItem('theme',theme);}
function initTheme(){const saved=localStorage.getItem('theme');if(saved){applyTheme(saved);}else{const prefers=window.matchMedia('(prefers-color-scheme: dark)').matches;applyTheme(prefers?'dark':'light');}}
initTheme();
btnToggleTheme.addEventListener('click',()=>{const dark=document.body.classList.contains('dark');applyTheme(dark?'light':'dark');});

btnToggleMode.addEventListener('click',()=>{if(currentMode==='target'){document.getElementById('total2').value=document.getElementById('total').value;document.getElementById('current2').value=document.getElementById('current').value;showMode('simulate');}else{showMode('target');}});

document.getElementById('calc-streak').addEventListener('click',()=>{const total=+document.getElementById('total').value;const cur=+document.getElementById('current').value;const goal=+document.getElementById('goal').value;if(!total||isNaN(cur)||isNaN(goal)){alert('請輸入完整數據');return;}const wins=total*(cur/100);let s=0;let rate=cur;while(rate<goal&&s<100000){s++;rate=((wins+s)/(total+s))*100;}resultArea.textContent=`你需要連勝 ${s} 場才能達到 ${goal}% 勝率。`;});
document.getElementById('simulate').addEventListener('click',()=>{const n=+document.getElementById('n').value;const win=+document.getElementById('win').value;const lose=+document.getElementById('lose').value;const total=+document.getElementById('total2').value;const cur=+document.getElementById('current2').value;if(isNaN(n)||isNaN(win)||isNaN(lose)||isNaN(total)||isNaN(cur)){alert('請完整輸入模擬欄位');return;}if(win+lose!==n){alert('a+b 必須等於 n');return;}const cw=total*(cur/100);const nt=total+n;const nw=cw+win;const nr=((nw/nt)*100).toFixed(2);resultArea.textContent=`模擬結果：${nt} 場後的勝率為 ${nr}%`;});
JS
