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
