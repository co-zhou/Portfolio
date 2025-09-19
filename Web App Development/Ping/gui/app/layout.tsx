import './globals.css'
import { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'Ping',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>
		    <h1 className="text-2xl font-bold my-5">Ping</h1>
	      {children}
	    </body>
    </html>
  )
}