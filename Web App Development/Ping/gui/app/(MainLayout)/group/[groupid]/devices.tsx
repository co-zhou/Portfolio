'use client'
import { useState, useEffect } from "react";
import { fetchDevices } from './actions';

export default function Devices({ params } : { params: { groupid: number, intervalTime: any } }) {
  const [devices, setDevices] = useState([]);

  useEffect(() => {
    let intervalId = 0;

    //console.log("devices.tsx " + params.intervalTime);

    fetchDevices(params.groupid)
    .then(devices => setDevices(devices));

    if(!intervalId) {
      intervalId = window.setInterval(() => {
        fetchDevices(params.groupid)
        .then(devices => setDevices(devices));
        //console.log(intervalId);
      }, params.intervalTime);
    }

    return () => {
      //console.log("return clear interval: " + intervalId);
      //console.log(intervalId);
      window.clearInterval(intervalId);
    };
    
  }, [params.intervalTime]);

  return(
    <div className="flex flex-row flex-wrap gap-2">
      {devices?.map((device: any) => (
        <div key={device.id} className={"text-center p-1 " + (device.ping >= 0 ? "bg-green-500": "bg-red-500")}>
          <p>{device.name}</p>
          <p>{device.ip}</p>
          <p>Ping: {device.ping >= 0 ? device.ping + 'ms': 'Timed out'}</p>
          <p>Uptime: {device.uptime}ms</p>
        </div>
      ))}
    </div>
  );
}