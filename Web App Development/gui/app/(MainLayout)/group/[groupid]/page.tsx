'use client'
import React, { useState } from 'react';
import { getIntervalCookie, setIntervalCookie } from './actions'
import Devices from './devices';
import DeviceForm from './deviceForm';
import IntervalForm from './intervalForm';
import GroupForm from '../../groupForm'

export default function Page({ params }: { params: { groupid: number } }) {
  const forms = [<GroupForm key="0"/>,
                 <DeviceForm key="1" params={ { groupid: params.groupid } }/>,
                 <IntervalForm key="2" params={ { submitIntervalForm: async (intervalTime: any) => {
                    setIntervalCookie(intervalTime);
                    setIntervalTime(await getIntervalCookie())
                  } } }/>];
  const [formIndex, setFormIndex] = useState(-1);
  const [intervalTime, setIntervalTime] = useState(1000);

  return (
    <div>
      {(formIndex == -1 || formIndex == 0) && <div><button className="bg-gray-200 outline outline-2 px-1" onClick={()=> {
        if (formIndex != 0) {
          setFormIndex(0);
        } else {
          setFormIndex(-1);
        }
      }}>{formIndex == 0 ? "Hide Group Form" : "Add Group"}</button><br/></div>}
      {(formIndex == -1 || formIndex == 1) && <div><button className="bg-gray-200 outline outline-2 px-1 my-2" onClick={()=> {
        if (formIndex != 1) {
          setFormIndex(1);
        } else {
          setFormIndex(-1);
        }
      }}>{formIndex == 1 ? "Hide Device Form" : "Add Devices"}</button><br/></div>}
      {(formIndex == -1 || formIndex == 2) && <div><button className="bg-gray-200 outline outline-2 px-1" onClick={()=> {
        if (formIndex != 2) {
          setFormIndex(2);
        } else {
          setFormIndex(-1);
        }
      }}>{formIndex == 2 ? "Hide Interval Form" : "Change Interval Time"}</button></div>}
      {formIndex >= 0 && forms[formIndex]}
      <h2 className="text-l font-bold my-2">Interval Time: {intervalTime}ms</h2>
      <Devices params={ { groupid: params.groupid, intervalTime: intervalTime} }/>    
    </div>
  );
}