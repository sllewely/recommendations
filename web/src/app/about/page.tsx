"use client"
import Link from "next/link";
import styles from './styles.module.css'

import { decrement, increment, reset } from "@/redux/features/counterSlice";
import { useAppDispatch, useAppSelector } from "@/redux/hooks";


export default function About() {
    const count = useAppSelector((state) => state.counterReducer.value);
    const dispatch = useAppDispatch();
  return (
    <>
      <div>About</div>
      <main style={{ maxWidth: 1200, marginInline: "auto", padding: 20 }}>
        <div style={{ marginBottom: "4rem", textAlign: "center" }}>
          <h4 style={{ marginBottom: 16 }}>{count}</h4>
          <button onClick={() => dispatch(increment())}>increment</button>
          <button
            onClick={() => dispatch(decrement())}
            style={{ marginInline: 16 }}
          >
            decrement
          </button>
          <button onClick={() => dispatch(reset())}>reset</button>
        </div>
      </main>
      <Link href='/home'>Link</Link>
    </>
  );
}
