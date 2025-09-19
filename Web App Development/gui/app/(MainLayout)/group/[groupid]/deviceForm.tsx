'use client'
import { useForm } from 'react-hook-form';
import { addDevice, addDevices } from './actions';

export default function DeviceForm({ params }: { params: { groupid: number } }){
  const { register: registerType, watch } = useForm();
  const { register, reset, resetField, handleSubmit } = useForm();
  
  const watchType = watch("type", "URL");

  return (
    <div>
      <form className="m-2">
        <label htmlFor="type">Input Type: </label>
        <select className="bg-gray-200 outline outline-2" id="type" {...registerType('type', {
          onChange: () => {
            console.log(watchType);
            if(watchType == "URL") {
              resetField("url");
            } else {
              resetField("start");
              resetField("end");
            }
          }
        })}>
          <option value="URL">URL</option>
          <option value="IP Range">IP Range</option>
        </select>
      </form>
      
      <form onSubmit={handleSubmit(async(data) => {
        if (watchType == "URL") {
          await addDevice(data.name, data.url, params.groupid);
          reset();
        } else {
          const partsStart = data.start.split('.').map((str: string) => parseInt(str));
          const partsEnd = data.end.split('.').map((str: string) => parseInt(str));
          
          const intStart = (partsStart[0] << 24) +
                          (partsStart[1] << 16) +
                          (partsStart[2] << 8) +
                            partsStart[3];
          const intEnd = (partsEnd[0] << 24) +
                        (partsEnd[1] << 16) +
                        (partsEnd[2] << 8) +
                          partsEnd[3];
        
          if(intStart > intEnd) {
            alert("Incorrect IP Range");
          } else {
            await addDevices(data.name, intStart, intEnd, params.groupid);
            reset();
          }
        }
      })} className="m-2">
        <label htmlFor="name">Device Name: </label>
        <input className="bg-gray-200 outline outline-2" type="text" id="name" {...register('name', { required: true })}/>
        {watchType == "URL" ?
        ( <div>
            <label htmlFor="url">URL: </label>
            <input className="bg-gray-200 m-2 outline outline-2" type="text" id="url" {...register('url', { required: true })}/>
          </div>
        ):( <div>
            <label htmlFor="start">IP Start: </label>
            <input className="bg-gray-200 m-2 outline outline-2" type="text" id="start" {...register('start', {
              required: true,
              pattern: /^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$/
            })}/>
            <label htmlFor="end">IP End: </label>
            <input className="bg-gray-200 my-2 outline outline-2" type="text" id="end" {...register('end', {
              required: true,
              pattern: /^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$/
            })}/>
          </div>
          )
        }
        <input className="bg-gray-200 outline outline-2 px-1" type="submit" value={watchType == "URL" ? "Add Device" : "Add Devices"}/>
      </form>
    </div>
  )
}