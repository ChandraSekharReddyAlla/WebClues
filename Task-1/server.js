
const express = require('express');

const app = express();
const port = 3000;
const host = '0.0.0.0';

app.get('/', (req, res) => {
  res.send('Hello World');
});

app.listen(port, host () => {
  console.log(`Server Running at http://${host}:${port}`);
});
