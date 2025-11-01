let darkMode = false;
document.getElementById('themeToggle').addEventListener('click', () => {
  darkMode = !darkMode;
  document.body.classList.toggle('dark', darkMode);
});

let mode1 = document.getElementById('mode1');
let mode2 = document.getElementById('mode2');
document.getElementById('modeSwitch').addEventListener('click', () => {
  const showingMode1 = mode1.style.display !== 'none';
  mode1.style.display = showingMode1 ? 'none' : 'block';
  mode2.style.display = showingMode1 ? 'block' : 'none';
});

const ctx = document.getElementById('chart').getContext('2d');
let chart = new Chart(ctx, {
  type: 'line',
  data: {
    labels: [],
    datasets: [{
      label: '勝率 (%)',
      data: [],
      borderColor: '#3a6ff8',
      tension: 0.2,
      fill: false
    }]
  },
  options: {
    responsive: true,
    scales: { y: { beginAtZero: true, max: 100 } }
  }
});
function updateChart(labels, data) {
  chart.data.labels = labels;
  chart.data.datasets[0].data = data;
  chart.update();
}

// 模式1：目標勝率
document.getElementById('calcTarget').addEventListener('click', () => {
  let total = parseFloat(document.getElementById('totalGames').value);
  let currentRate = parseFloat(document.getElementById('currentWinRate').value);
  let targetRate = parseFloat(document.getElementById('targetWinRate').value);
  if (isNaN(total) || isNaN(currentRate) || isNaN(targetRate)) {
    document.getElementById('result1').innerText = "請輸入完整數據";
    return;
  }
  let currentWins = total * currentRate / 100;
  let x = Math.ceil((targetRate * total - 100 * currentWins) / (100 - targetRate));
  if (x < 0) x = 0;
  document.getElementById('result1').innerText = `你需要連勝 ${x} 場才能達到 ${targetRate}% 勝率。`;
  let labels = Array.from({length: x+1}, (_, i) => total + i);
  let data = labels.map(i => 100*(currentWins + (i - total))/i);
  updateChart(labels, data);
});

// 模式2：模擬未來對局
document.getElementById('calcSim').addEventListener('click', () => {
  let n = parseFloat(document.getElementById('n').value);
  let a = parseFloat(document.getElementById('a').value);
  let b = parseFloat(document.getElementById('b').value);
  let currentRate = parseFloat(document.getElementById('currentRate2').value);
  let total = parseFloat(document.getElementById('totalGames2').value);
  if (isNaN(currentRate) || isNaN(total)) {
    document.getElementById('result2').innerText = "請輸入完整數據";
    return;
  }
  if (!isNaN(n) && !isNaN(a) && isNaN(b)) b = n - a;
  else if (!isNaN(n) && !isNaN(b) && isNaN(a)) a = n - b;
  else if (isNaN(n) && !isNaN(a) && !isNaN(b)) n = a + b;
  if (a < 0 || b < 0 || n < 0) {
    document.getElementById('result2').innerText = "輸入錯誤";
    return;
  }
  let currentWins = total * currentRate / 100;
  let newRate = 100 * (currentWins + a) / (total + n);
  document.getElementById('result2').innerText = `模擬結果：${total+n} 場後的勝率為 ${newRate.toFixed(2)}%`;
  let labels = Array.from({length: n+1}, (_, i) => total + i);
  let data = labels.map(i => 100*(currentWins + Math.min(i-total, a))/i);
  updateChart(labels, data);
});
