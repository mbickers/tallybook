import { User } from "firebase/auth"
import { collection, Firestore, onSnapshot, orderBy, query, where } from "firebase/firestore"
import React, { useState, useEffect } from "react"
import { Tally, TallyService } from "./types"

export const TallyServiceContext = React.createContext<TallyService>({})

export const TallyServiceProvider  = ({ children, firestore, user }: { children?: React.ReactNode, firestore: Firestore, user: User }) => {
  const [tallies, setTallies] = useState<Tally[]>([])

  useEffect(() => {
    const talliesRef = collection(firestore, "tallies")
    const talliesQuery = query(talliesRef, where("userId", "==", user.uid), orderBy("listPriority"))
    const unsubscribe = onSnapshot(talliesQuery, snapshot => {
      console.log("In query")
      const tallies = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as Tally))
      setTallies(tallies)
    })
    return unsubscribe
  }, [user])

  return (
    <TallyServiceContext.Provider value={{tallies}}>
      {children}
    </TallyServiceContext.Provider>
  )
}