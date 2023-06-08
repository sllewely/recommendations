import './globals.css'
import { Providers } from '@/redux/provider'
import { Inter } from 'next/font/google'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'Recommendations',
  description: 'Friend Recommendations',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang='en'>
      <body>
        <Providers>
          <nav>
            <h1 className='text-3xl'>Recommendations</h1>
          </nav>
          {children}
        </Providers>
      </body>
    </html>
  );
}
