// creating typed versions of useDispath and useSelector
// https://redux-toolkit.js.org/tutorials/typescript
    // useSelector saves you from typing (state: RootState)
    // default Dispatch type does not know about thunks

import {useDispatch, useSelector } from "react-redux";
import { TypedUseSelectorHook} from "react-redux";
import type { RootState, AppDispatch } from "./store";

export const useAppDispatch = () => useDispatch<AppDispatch>();
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector;
