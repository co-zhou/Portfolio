'use client'
import React, { useState } from 'react';
import GroupForm from './groupForm'

export default function Page(){
  const [showGroupForm, setShowGroupForm] = useState(false);

  return (
    <div>
      <h1 className="text-2xl font-bold my-5">Home</h1>
      <button className="bg-gray-200 outline outline-2 px-1" id="group-form-toggle" onClick={()=> {
        setShowGroupForm(!showGroupForm);
      }}>{showGroupForm ? "Hide Group Form" : "Add Group"}</button>
      {showGroupForm && <GroupForm/>}
    </div>
  );
}