const express = require('express');
const mariadb = require('mariadb');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

const pool = mariadb.createPool({
  host: 'db',
  user: 'root', 
  password: 'password',
  database: 'ping_db'
});

const queryDB = async (queryStr, args) => {
  let conn;
  let query;

  //console.log(queryStr)
  //console.log("args: " + args)

  try {
    conn = await pool.getConnection();
    query = await args ? conn.query(queryStr, args) : conn.query(queryStr);
  } catch (err) {
    throw err;
    return err;
  } finally {
    if (conn) {
      conn.end();
    }
    return query;
  }
}

app.get('/api/v1/get-groups', async (req, res) => {
  /*  
  req.body: {
    groupId: int
  }
  */

  console.log('get groups')

  const groups = await queryDB("SELECT * FROM groups");
  res.send({ groups: groups });
})

app.post('/api/v1/get-devices', async (req, res) => {
  /*  
  req.body: {
    groupId: groupid
  }
  */

  console.log('get devices')

  const devices = req.body.groupId
  ? await queryDB("SELECT * FROM devices WHERE group_id=?", req.body.groupId)
  : null;
  /*
  const response = await fetch('http://ping:5000/api/v1/change-group-id', {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      groupId: req.body.groupId
    })
  });
  
  if (!response.ok) {
    throw new Error('Failed to fetch data');
  }

  const data = await response.json();
  */
  devices.map((device) => {
    device.uptime = device.recent_time - device.start_time;
    delete device.start_time;
    delete device.recent_time;
  })

  res.send({ devices: devices });
})

app.post('/api/v1/add-group', async (req, res) => {
  /*  
  req.body: {
    name: string
  }
  */

  const groups = await queryDB("INSERT INTO groups(name) VALUES (?)", req.body.name);
  res.send( { message:"Group Added"} );
})

app.post('/api/v1/add-device', async (req, res) => {
  /*  
  req.body: {
    name: string,
    ip: string,
    groupId: int
  }
  */

  const groups = await queryDB("INSERT INTO devices(name, ip, group_id) VALUES (?, ?, ?)",
    [req.body.name, req.body.ip, req.body.groupId]
  );
  res.send( { message:"Device Added"} );
})

app.post('/api/v1/add-devices', async (req, res) => {
  /*  
  req.body: {
    name: string,
    intStart: int,
    intEnd: int,
    groupId: int
  }
  */

  let devices = [];

  for (let i = req.body.intStart; i <= req.body.intEnd; i++){
	  devices.push([req.body.name, i.toString(16).padStart(8, '0').match(/.{2}/g).map((str) => parseInt(str, 16)).join('.'), req.body.groupId])
  }

  console.log(devices);

  try {
    conn = await pool.getConnection();
    query = conn.batch("INSERT INTO devices(name, ip, group_id) VALUES (?, ?, ?)", devices);
  } catch (err) {
    throw err;
    return err;
  } finally {
    if (conn) {
      conn.end();
    }
  }

  res.send( { message:"Device Added" } );
})

app.listen(8000, () => {
  console.log(`Server is running on port 8000.`);
});