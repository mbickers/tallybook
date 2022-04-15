import { FirebaseApp } from "firebase/app"
import { getAuth, User } from "firebase/auth"
import { useContext } from "react"
import { Link as RouterLink, Outlet } from "react-router-dom"
import { FirebaseContext } from "../providers/FirebaseProvider"
import { formattedDate } from "../utils"
import { TallyServiceContext } from "../providers/TallyServiceProvider"
import { Tally, TallyKind } from "../types"
import { UserContext } from "../providers/UserProvider"
import { Button, Checkbox, Heading, Link, NumberInput, NumberInputField, Stack } from "@chakra-ui/react"

const TallyInput = ({kind, value, updateValue}: {kind: TallyKind, value: number, updateValue: (newValue: number) => void}) => {
    switch (kind) {
        case TallyKind.Completion:
            return <Checkbox isChecked={value === 1} onChange={e => updateValue(Number(e.target.checked))} />
        case TallyKind.Amount:
            return (
                <NumberInput value={value} onChange={(_, newValue) => updateValue(newValue)}>
                    <NumberInputField />
                </NumberInput>
            )
        case TallyKind.Counter:
            return <Stack direction='row'>
                <Button onClick={() => updateValue(1 + value)}>+</Button>
                <NumberInput value={value} onChange={(_, newValue) => updateValue(newValue)}>
                    <NumberInputField />
                </NumberInput>
            </Stack>
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
    <Heading as='h2' size='md'>{tally.name}</Heading>
    <TallyInput kind={tally.kind} value={todayValue} updateValue={updateTodayValue} />
    <Link as={RouterLink} to={`/tallies/${tally.id}`}>see detail</Link>
  </div>
}

export const TallyList = () => {
  const tallyService = useContext(TallyServiceContext)
  const firebase = useContext(FirebaseContext) as FirebaseApp
  const user = useContext(UserContext) as User
  const auth = getAuth(firebase)
  const userInfo = auth.currentUser ? <p>{user.email} <button onClick={() => auth.signOut()}>Sign out</button></p> : <p>Not logged in</p>

  return <>
      <Heading>Tallies</Heading>
      {userInfo}
      {tallyService.tallies?.map(tally => <TallyRow tally={tally} key={tally.id} />)}
      <Outlet />
  </>
}