import React, {useState, createContext} from "react";


// where the data handling happens
export const ClientDataContext = createContext();

export const ClientDataProvider = () =>{
    
    const [clientPickData, setClientPickData] = useState("")
    const [clientDropData, setClientDropData] = useState("")

    return(
        <ClientDataContext.Provider value={[clientPickData, setClientPickData]}>
            {props.children}
        </ClientDataContext.Provider>
    )
}
