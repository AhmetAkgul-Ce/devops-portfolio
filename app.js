const express = require('express');
const path = require('path');
const app = express();
const PORT = 80;

const startTime = Date.now();

// Ana sayfa: index.html dosyasını göster
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Health endpoint: JSON veya HTML döndür
app.get('/health', (req, res) => {
  const uptime = Math.floor((Date.now() - startTime) / 1000);
  
  // JSON isteyenlere (API/Curl)
  if (req.headers.accept && req.headers.accept.includes('application/json')) {
    return res.json({
      status: 'OK',
      timestamp: new Date().toISOString(),
      uptime: uptime,
      nodeVersion: process.version
    });
  }
  
  // Tarayıcıdan gelenlere basit HTML
  res.send('<h1 style="font-family:sans-serif;text-align:center;margin-top:50px;color:#22c55e">✅ Sistem Sağlığı: OK</h1><p style="text-align:center;color:#999">Uptime: ' + uptime + ' sn</p>');
});

// Sunucuyu başlat
app.listen(PORT, () => {
  console.log('Server running on port ' + PORT);
});