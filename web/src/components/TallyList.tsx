import { FirebaseApp } from "firebase/app"
import { getAuth, User } from "firebase/auth"
import React, { useContext, useEffect, useState } from "react"
import { Link, Outlet } from "react-router-dom"
import { FirebaseContext } from "../providers/FirebaseProvider"
import { formattedDate } from "../utils"
import { TallyServiceContext } from "../providers/TallyServiceProvider"
import { Tally, TallyKind } from "../types"
import { UserContext } from "../providers/UserProvider"

const TallyInput = ({kind, value, updateValue}: {kind: TallyKind, value: number, updateValue: (newValue: number) => void}) => {
    const [fieldValue, updateFieldValue] = useState(String(value))

    // I don't think this should be here, but it doesn't update if its not here
    useEffect(() => {
        updateFieldValue(String(value))
    }, [value])

    const onChangeHandler = (event: React.ChangeEvent<HTMLInputElement>) => {
        if (event.target.value === "") {
            updateFieldValue("")
            return
        }

        const numberValue = Number(event.target.value)
        if (Number.isInteger(numberValue) && numberValue >= 0) {
            updateFieldValue(String(numberValue))
            updateValue(numberValue)
        }
    }

    const onClickHandler = () => {
        updateFieldValue(String(1 + value))
        updateValue(1 + value)
    }

    switch (kind) {
        case TallyKind.Completion:
            return <input type="checkbox" checked={value === 1} onChange={() => updateValue(1-value)} />
        case TallyKind.Amount:
            return <input value={fieldValue} onChange={onChangeHandler} />
        case TallyKind.Counter:
            return <>
                <button onClick={onClickHandler}>+</button>
                <input value={fieldValue} onChange={onChangeHandler} />
            </>
    }
}

const TallyRow = ({ tally }: { tally: Tally }) => {
  const tallyService = useContext(TallyServiceContext)
  const entries = tally.entries.entries
  const todayFormatted = formattedDate(new Date())
  const entriesIncludesToday = entries.length > 0 && entries[0].formattedDate == todayFormatted
  const todayValue = entriesIncludesToday ? entries[0].value : 0

  const updateTodayValue = (value: number) => {
      const otherEntries = entriesIncludesToday ? entries.slice(1) : entries
      const newEntries = value === 0 ? otherEntries : [{value, formattedDate: formattedDate(new Date())}, ...otherEntries]
      if (tallyService.updateTally) {
        tallyService.updateTally({ ...tally, entries: { entries: newEntries } })
      }
  }

  return <div>
    <h2>{tally.name}</h2>
    <TallyInput kind={tally.kind} value={todayValue} updateValue={updateTodayValue} />
    <p><Link to={`/tallies/${tally.id}`}>see detail</Link></p>
  </div>
}

export const TallyList = () => {
  const tallyService = useContext(TallyServiceContext)
  const firebase = useContext(FirebaseContext) as FirebaseApp
  const user = useContext(UserContext) as User
  const auth = getAuth(firebase)
  const userInfo = auth.currentUser ? <p>{user.email} <button onClick={() => auth.signOut()}>Sign out</button></p> : <p>Not logged in</p>

  return <>
      {userInfo}
      {tallyService.tallies?.map(tally => <TallyRow tally={tally} key={tally.id} />)}
      <Outlet />
  </>
}