const express = require('express');
const cors = require('cors');

const app = express();

// Allow CloudFront frontend to call backend
app.use(cors({
  origin: 'https://d2zomtcl1r0uzw.cloudfront.net', // CloudFront URL
  credentials: true
}));

app.get('/api/hello', (req, res) => {
  res.json({ 
	  message: "Hello from backend! CI/CD test successful, env: 'prod'" });
});

app.listen(5000, () => console.log('Backend running on port 5000'));

