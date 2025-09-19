'use client'
import { useForm } from 'react-hook-form';
import { addGroup } from './actions';

export default function GroupForm() {
  const { register, reset, handleSubmit } = useForm();

  return (
    <form onSubmit={handleSubmit(async(data) => {
      await addGroup(data.name);
      reset();
    })} className="m-2">
      <label htmlFor="name">Group Name: </label>
      <input className="bg-gray-200 mx-2 outline outline-2" type="text" id="name" {...register('name', { required: true })}/>
      <input className="bg-gray-200 outline outline-2 px-1" type="submit" value="Add Group"/>
    </form>
  )
}