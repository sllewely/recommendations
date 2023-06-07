// import "./globals.css";
// import { Inter } from "next/font/google";

// const inter = Inter({ subsets: ["latin"] });

export const metadata = {
  title: "about layout test",
  description: "woww",
};

export default function AboutLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <>
    <nav>About Nav Bar</nav>
    <main>
        {children}
    </main>
    </>
  );
}
