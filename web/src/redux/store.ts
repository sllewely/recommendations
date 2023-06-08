import { configureStore } from "@reduxjs/toolkit";

// configureStore used to create new instance of Redux store
export const store = configureStore({
  reducer: {}});

//extracting RootState and Dispath types from store
export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
