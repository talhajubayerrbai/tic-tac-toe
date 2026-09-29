'use strict';
const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.static(path.join(__dirname, 'public')));

app.get('/health', (_req, res) => res.send('ok'));

app.listen(PORT, () => {
  console.log(`tic-tac-toe listening on port ${PORT}`);
});

module.exports = app;
