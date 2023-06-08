import Link from "next/link";
import styles from './styles.module.css'

export default function About() {
  return (
    <>
      <div>About</div>
      {/* <div className={styles.main}>About</div> */}
      <Link href='/home'>Link</Link>
    </>
  );
}
