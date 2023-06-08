import Link from "next/link"
import TestComponent from "@/components/TestComponent";

export default function Home() {
    return (
      <>
        <div>Home</div>
        <TestComponent/>
        <Link href='/about'>About</Link>
      </>
    );
}