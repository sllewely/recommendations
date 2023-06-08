import { configureStore } from "@reduxjs/toolkit"
import counterReducer from './features/counterSlice'
import authReducer from './features/auth/authSlice'


// configureStore used to create new instance of Redux store
export const store = configureStore({
  reducer: {
    counterReducer,
    authReducer
  }
});

//extracting RootState and Dispath types from store
export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
