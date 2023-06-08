import Link from "next/link"
import styles from "../styles.module.css"

export default function SignUp() {
  return (
    <div className='w-96 mt-4 mx-auto border-solid-md border-2 rounded border-sky-500 p-4 bg-white'>
      <div className='text-2xl'>Sign Up</div>
      {/* <div className={styles.main}>About</div> */}
      <form>
        <div className='my-3'>
          <label className='text-l'>Username</label>
          <br />
          <input
            className='border-solid border-2 rounded border-gray w-full p-2'
            name='firstName'
            type='text'
          ></input>
        </div>

        <div className='my-3'>
          <label className='text-l'> Email</label>
          <br />
          <input
            className='border-solid border-2 rounded border-gray w-full p-2'
            name='email'
            type='text'
          ></input>
        </div>

        <div className='my-3'>
          <label className='text-l'> Password</label>
          <br />
          <input
            className='border-solid border-2 rounded border-gray w-full p-2'
            name='password'
            type='password'
          ></input>
        </div>
        <button className='border-solid border-2 rounded bg-blue-600 hover:bg-blue-700 w-full text-white p-2 my-4'>
          Sign Up
        </button>
      </form>
      <div className='text-center'>
        Have an Account?
        <Link href='/account/login'>
          <span className='text-blue-500 hover:text-blue-700'> Login </span>
        </Link>
      </div>
    </div>
  );
}
