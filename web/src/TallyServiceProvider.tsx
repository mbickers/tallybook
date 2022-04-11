import { User } from "firebase/auth"
import { collection, doc, Firestore, onSnapshot, orderBy, query, setDoc, where } from "firebase/firestore"
import React, { useState, useEffect } from "react"
import { EntryList, Tally, TallyKind, TallyService } from "./types"

export const TallyServiceContext = React.createContext<TallyService>({})

const normalizeEntryList = (entryList: EntryList, kind: TallyKind): EntryList => {
  const seen = new Map()
  const entries = entryList.entries.filter(entry => {
    if (seen.get(entry.formattedDate)) {
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

export const TallyServiceProvider  = ({ children, firestore, user }: { children?: React.ReactNode, firestore: Firestore, user: User | null }) => {
  const [tallies, setTallies] = useState<Tally[]>([])
  const talliesRef = collection(firestore, "tallies")

  useEffect(() => {
    if (user) {
      const talliesQuery = query(talliesRef, where("userId", "==", user.uid), orderBy("listPriority"))
      console.log("Subscribing")
      const unsubscribe = onSnapshot(talliesQuery, snapshot => {
        console.log("Update")
        const tallies = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as Tally))
        setTallies(tallies)
      })
      return unsubscribe
    }
  }, [user])

  const updateTally = (tally: Tally) => {
    if ('id' in tally) {
      setDoc(doc(talliesRef, tally.id), normalizeTally(tally))
      .catch(console.log)
    }
  }

  return (
    <TallyServiceContext.Provider value={{tallies, updateTally}}>
      {children}
    </TallyServiceContext.Provider>
  )
}