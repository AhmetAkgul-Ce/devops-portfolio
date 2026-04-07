const express = require('express');
const app = express();
const PORT = 80;

app.get('/', (req, res) => {
  res.send('🚀 DevOps Portfolio - Lite Mode Aktif!');
});

app.get('/health', (req, res) => {
  res.json({ status: 'OK', time: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(\✅ Server running on port \\);
});
