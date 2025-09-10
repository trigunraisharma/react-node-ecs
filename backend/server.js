const express = require('express');
const app = express();
const port = process.env.PORT || 5000;


app.get('/api/hello', (req, res) => {
res.json({ message: 'Hello from backend! ' + new Date().toISOString() });
});


app.get('/health', (req, res) => res.send('OK'));


app.listen(port, ()=>console.log('Server listening on', port));
