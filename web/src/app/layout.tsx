import './globals.css'
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
        <nav>
          <h1 className="text-3xl">Recommendations</h1>
        </nav>
        {children}
      </body>
    </html>
  );
}
