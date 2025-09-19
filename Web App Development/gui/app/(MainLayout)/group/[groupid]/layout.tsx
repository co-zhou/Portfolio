import { redirect } from 'next/navigation'

const getGroupName = async (groupId: number) => {
  const res = await fetch('http://server:8000/api/v1/get-groups', { cache: 'no-store' });
  const data = await res.json();
  const group = data.groups.find((group: any) => group.id == groupId);
  if(!group) {
    redirect('/');
  }
  return group.name;

  //return [{id:1, name:'dank'}];
};

export default async function Layout({
  children,
  params
}: {
  children: React.ReactNode,
  params: { groupid: number }
}) {
  const groupName = await getGroupName(params.groupid);
  return (
    <div>
      <h1 className="text-2xl font-bold my-5">{groupName}</h1>
      {children}
    </div>
  )
}