import { FirebaseApp } from "firebase/app"
import { User } from "firebase/auth"
import { addDoc, collection, deleteDoc, doc, getFirestore, onSnapshot, orderBy, query, setDoc, where } from "firebase/firestore"
import React, { useState, useEffect, useContext } from "react"
import { FirebaseContext } from "./FirebaseProvider"
import { EntryList, Tally, TallyKind, TallyService } from "../types"
import { UserContext } from "./UserProvider"
import { formattedDate } from "../utils"

export const TallyServiceContext = React.createContext<TallyService>({} as TallyService)

const normalizeEntryList = (entryList: EntryList, kind: TallyKind): EntryList => {
  const currentDate = formattedDate(new Date())
  const seen = new Map()
  const entries = entryList.entries.filter(entry => {
    if (seen.get(entry.formattedDate) || entry.formattedDate > currentDate) {
      return false
    }
    seen.set(entry.formattedDate, true)

    if (entry.value <= 0 || !Number.isInteger(entry.value)) {
      return false
    }

    return true
  }).map(entry => {
    let value = entry.value
    if (kind === TallyKind.Completion) {
      value = value === 0 ? 0 : 1
    }
    return { formattedDate: entry.formattedDate, value }
  })
  .sort((a, b) => [-1, 0, 1][Number(a.formattedDate < b.formattedDate)])

  return { entries }
}

const normalizeTally = (tally: Tally): Omit<Tally, 'id'> => {
  return {
    kind: tally.kind,
    name: tally.name,
    entries: normalizeEntryList(tally.entries, tally.kind),
    listPriority: tally.listPriority,
    userId: tally.userId
  }
}

export const TallyServiceProvider: React.FC  = ({ children }) => {
  const firebase = useContext(FirebaseContext) as FirebaseApp
  const user = useContext(UserContext) as User
  const [tallies, setTallies] = useState<Tally[]>([])

  const firestore = getFirestore(firebase)
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
  }, [firebase, user])

  const addTally = (kind: TallyKind, name: string) => {
    addDoc(talliesRef, {kind, name, entries: {entries: []}, listPriority: tallies.length, userId: user.uid})
  }

  const updateTally = (tally: Tally) => {
    if ('id' in tally) {
      setDoc(doc(talliesRef, tally.id), normalizeTally(tally))
      .catch(console.log)
    }
  }

  const removeTally = (tally: Tally) => {
    if ('id' in tally) {
      deleteDoc(doc(talliesRef, tally.id))
    }
  }

  return (
    <TallyServiceContext.Provider value={{tallies, addTally, updateTally, removeTally}}>
      {children}
    </TallyServiceContext.Provider>
  )
}