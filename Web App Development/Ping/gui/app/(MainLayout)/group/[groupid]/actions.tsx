'use server'
import { revalidatePath } from 'next/cache';
import { cookies } from 'next/headers';

export const fetchDevices = async (groupId : number) => {
  const res = await fetch('http://server:8000/api/v1/get-devices', {
    method: "POST",
    cache: "no-store",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ groupId: groupId })
    })
  const data = await res.json();
  return data.devices;
};

export const addDevice = async (name: string, ip: string, groupId: number) => {
  const res = await fetch('http://server:8000/api/v1/add-device', {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      name: name,
      ip: ip,
      groupId: groupId
    })
  });

  if (!res.ok) {
    throw new Error('Failed to fetch data');
  }

  revalidatePath('/');
}

export const addDevices = async (name: string, intStart: number, intEnd: number, groupId: number) => {
  const res = await fetch('http://server:8000/api/v1/add-devices', {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      name: name,
      intStart: intStart,
      intEnd: intEnd,
      groupId: groupId
    })
  });

  if (!res.ok) {
    throw new Error('Failed to fetch data');
  }

  revalidatePath('/');
}

export const setIntervalCookie = async (intervalTime: number) => {
  //console.log("setIntervalCookie: " + intervalTime);
  cookies().set('intervalTime', "" + intervalTime);

  revalidatePath('/');
}

export const getIntervalCookie = async () => {
  //console.log(cookies().get('intervalTime'));
  return cookies().get('intervalTime') ? Number(cookies().get('intervalTime')?.value) : 1000;
}