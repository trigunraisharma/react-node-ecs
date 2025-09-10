const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 5000;


app.use(cors());
app.get('/api/hello', (req,res)=>{
res.json({message: 'Hello from backend!', env: process.env.NODE_ENV || 'dev'});
});


app.listen(PORT, ()=>console.log(`Backend listening on ${PORT}`));
