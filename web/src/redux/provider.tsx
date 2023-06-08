"use client";
// use client flag indicates provider component should live on the client side 
// https://nextjs.org/docs/getting-started/react-essentials#the-use-client-directive

import {store} from "./store";
import { Provider } from "react-redux";

export function Providers({children}: {children: React.ReactNode}) {
    return <Provider store={store}>{children}</Provider>
}
