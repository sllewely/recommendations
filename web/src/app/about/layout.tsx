import styles from './styles.module.css'

export default function AboutLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <>
      <nav>ABOUT Nav Bar!!</nav>
      {/* <main className={styles.main}>{children}</main> */}
      <main>{children}</main>
    </>
  );
}
