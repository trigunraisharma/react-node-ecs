import React, { useEffect, useState } from 'react';

export default function App() {
  const [msg, setMsg] = useState('loading...');

  useEffect(() => {
    // Correct template literal with HTTPS ALB URL from env
    fetch(`${process.env.REACT_APP_API_URL}/hello`)
      .then(res => res.json())
      .then(j => setMsg(j.message + ' (env: ' + (j.env || 'unknown') + ')'))
      .catch(e => setMsg('Error: ' + e.message));
  }, []);

  return (
    <div style={{ fontFamily: 'Arial, Helvetica, sans-serif', padding: 20 }}>
      <h1>Sample React + Node on ECS</h1>
      <p>{msg}</p>
      <small>Frontend served from CloudFront; backend served from ECS container via ALB. CI/CD Test Successfull</small>
    </div>
  );
}

