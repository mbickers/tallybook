import { User } from "firebase/auth"
import { addDoc, collection, doc, Firestore, onSnapshot, orderBy, query, setDoc, where } from "firebase/firestore"
import React, { useState, useEffect } from "react"
import { Tally, TallyService } from "./types"

export const TallyServiceContext = React.createContext<TallyService>({})

export const TallyServiceProvider  = ({ children, firestore, user }: { children?: React.ReactNode, firestore: Firestore, user: User }) => {
  const [tallies, setTallies] = useState<Tally[]>([])
  const talliesRef = collection(firestore, "tallies")

  useEffect(() => {
    const talliesQuery = query(talliesRef, where("userId", "==", user.uid), orderBy("listPriority"))
    console.log("Subscribing")
    const unsubscribe = onSnapshot(talliesQuery, snapshot => {
      console.log("Update")
      const tallies = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as Tally))
      setTallies(tallies)
    })
    return unsubscribe
  }, [user])

  const updateTally = (tally: Tally) => {
    if ('id' in tally) {
      setDoc(doc(talliesRef, tally.id), tally)
    }
  }

  return (
    <TallyServiceContext.Provider value={{tallies, updateTally}}>
      {children}
    </TallyServiceContext.Provider>
  )
}