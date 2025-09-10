import React, {useEffect, useState} from 'react';


export default function App(){
const [msg, setMsg] = useState('loading...');


useEffect(()=>{
fetch('https://react-node-backend-alb-1964838860.us-east-1.elb.amazonaws.com:5000/api/hello')
.then(r=>r.json())
.then(j=>setMsg(j.message + ' (env: '+ (j.env || 'unknown') +')'))
.catch(e=>setMsg('Error: '+e.message));
},[]);


return (
<div style={{fontFamily:'Arial, Helvetica, sans-serif', padding:20}}>
<h1>Sample React + Node on ECS</h1>
<p>{msg}</p>
<small>Frontend served from container; backend served from container.</small>
</div>
);
}
