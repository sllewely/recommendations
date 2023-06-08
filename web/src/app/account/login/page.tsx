"use client";
import Link from "next/link";
import { useForm } from "react-hook-form";
import styles from "../styles.module.css";

export default function Login() {
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm();
  const onSubmit = (data) => {
    console.log(data);
  };
  return (
    <div className='w-96 mt-4 mx-auto border-solid-md border-2 rounded border-sky-500 p-4 bg-white'>
      <div className='text-2xl'>Login</div>
      <form onSubmit={handleSubmit(onSubmit)}>
        <div className='my-3'>
          <label className='text-l'> Email</label>
          <br />
          <input
            className='border-solid border-2 rounded border-gray w-full p-2'
            // type='text'
            // name='email'
            {...register("email", { required: true })}
          />
          {errors?.email?.type === "required" && <p>This field is required</p>}
        </div>

        <div className='my-3'>
          <label className='text-l'> Password</label>
          <br />
          <input
            className='border-solid border-2 rounded border-gray w-full p-2'
            type='password'
            {...register("password", { required: true, minLength: 3 })}
            // keeping pw length short but will change later
          />
          {errors?.password?.type === "required" && (
            <p>This field is required</p>
          )}
          {errors?.password?.type === "minLength" && (
            <p>Password must be at least 3 characters long</p>
          )}
        </div>
        <input
          type='submit'
          className='border-solid border-2 rounded bg-blue-600 hover:bg-blue-700 w-full text-white p-2 my-4'
        ></input>
      </form>
      <div className='text-center'>
        New User?
        <Link href='/account/signup'>
          <span className='text-blue-500 hover:text-blue-700'> Sign Up </span>
        </Link>
      </div>
    </div>
  );
}
