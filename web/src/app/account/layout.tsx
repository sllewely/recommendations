import styles from "./styles.module.css";

export default function AccountLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div>
      {/* <main className={styles.main}>{children}</main> */}
      {children}
    </div>
  );
}
