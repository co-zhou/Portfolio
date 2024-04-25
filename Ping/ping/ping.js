const express = require('express');
const cors = require('cors');
const app = express();
const mariadb = require('mariadb');
const ping = require('ping');

app.use(cors());
app.use(express.json());

const pool = mariadb.createPool({
  host: 'db',
  user: 'root', 
  password: 'password',
  database: 'ping_db'
});

let intervalId = {};
//let groupId = 0;
let intervalTime = 1000;

const timer = async () => {
  let conn;
  try {
    conn = await pool.getConnection();
    console.log('ping server on');
    //if(!Object.keys(intervalId).length) {
      intervalId = setInterval(async () => {
        console.log("ping");
        const devices = await conn.query("SELECT * FROM devices");
        devices.forEach(async device => {
          const time = (await ping.promise.probe(device.ip)).time;
          if (isNaN(time)) {
            const query = conn.query("UPDATE devices SET ping=?, start_time=? WHERE id=?", [
              -1,
              new Date().toISOString().slice(0, 23).replace('T', ' '),
              device.id
            ]);
          }
          const query = conn.query("UPDATE devices SET ping=? WHERE id=?", [
            time,
            device.id
          ]);
        });
      }, intervalTime);
    //}
  } catch (err) {
    throw err;
  } finally {
    if (conn) {
      conn.end();
    }
  }
};

timer();

/*
app.post('/api/v1/change-group-id', async (req, res) => {
  
  req.body: {
    groupId: int
  }
  

  groupId = req.body.groupId;
  res.send({ message: "groupId changed" });
})
*/

app.post('/api/v1/change-interval-time', async (req, res) => {
  /*
  req.body: {
    intervalTime: int
  }
  */

  clearInterval(intervalId);
  intervalTime = req.body.intervalTime;
  timer();

  res.send({ message: "intervalTime changed" });
})

app.listen(5000, () => {
  console.log(`Ping is running on port 5000.`);
});