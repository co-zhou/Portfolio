import Link from 'next/link';

const getGroups = async () => {
  const res = await fetch('http://server:8000/api/v1/get-groups', { cache: 'no-store' });
  const data = await res.json();
  return data.groups;

  //return [{id:1, name:'dank'}];
};

export default async function MainLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const groups = await getGroups();

  return (
    <div className="flex gap-2">
      <div className="flex-none m-2">
        <nav key="0" className="flex flex-col p-2 gap-2 bg-blue-200">
          <Link href='/' className= "p-1 text-center bg-gray-200">Home</Link>
        </nav>
        {groups?.map((group: any) => (
          <nav key={group.id} className="flex flex-col p-2 gap-2 bg-blue-200">
            <Link href={'/group/' + group.id} className= "p-1 text-center bg-gray-200">{group.name}</Link>
          </nav>
        ))}
      </div>
      <div>
        {children}
      </div>
    </div>
  )
}