"use server"
import { revalidatePath } from 'next/cache';

export async function addGroup(name: string) {
  const res = await fetch('http://server:8000/api/v1/add-group', {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ name: name })
  });

  if (!res.ok) {
    throw new Error('Failed to fetch data');
  }

  revalidatePath('/');
};