'use client'
import { useForm } from 'react-hook-form';

export default function IntervalForm({ params } : { params: { submitIntervalForm: Function } }) {
  const { register, reset, handleSubmit } = useForm();

  return (
    <form onSubmit={handleSubmit(async(data) => {
      params.submitIntervalForm(data.intervaltime);
      reset();
    })} className="m-2">
      <label htmlFor="intervaltime">Interval Time (min 500ms): </label>
      <input className="bg-gray-200 mx-2 outline outline-2" type="number" id="intervaltime" {...register('intervaltime', { min: 500, required: true })}/>
      <input className="bg-gray-200 outline outline-2 px-1" type="submit" value="Change Interval"/>
    </form>
  )
}