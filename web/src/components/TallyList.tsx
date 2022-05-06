import { FirebaseApp } from "firebase/app"
import { getAuth, User } from "firebase/auth"
import { useContext } from "react"
import { Link as RouterLink, Outlet } from "react-router-dom"
import { FirebaseContext } from "../providers/FirebaseProvider"
import { formattedDate } from "../utils"
import { TallyServiceContext } from "../providers/TallyServiceProvider"
import { Tally, TallyKind } from "../types"
import { UserContext } from "../providers/UserProvider"
import { Box, Button, Checkbox, Container, Flex, Heading, HStack, Link, NumberInput, NumberInputField, Spacer, Stack, VStack } from "@chakra-ui/react"

const TallyInput = ({kind, value, updateValue}: {kind: TallyKind, value: number, updateValue: (newValue: number) => void}) => {
    switch (kind) {
        case TallyKind.Completion:
            return <Checkbox size='lg' isChecked={value === 1} onChange={e => updateValue(Number(e.target.checked))} />
        case TallyKind.Amount:
            return (
                <NumberInput value={value} onChange={(_, newValue) => updateValue(newValue)}>
                    <NumberInputField />
                </NumberInput>
            )
        case TallyKind.Counter:
            return <HStack>
                <Button onClick={() => updateValue(1 + value)}>+</Button>
                <NumberInput value={value} onChange={(_, newValue) => updateValue(newValue)}>
                    <NumberInputField />
                </NumberInput>
            </HStack>
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

  return <Flex w='sm' h='7rem' p='2' bg='white' borderRadius='lg' direction='column'>
      <Heading size='md'>{tally.name}</Heading>
      <Spacer />
      <TallyInput kind={tally.kind} value={todayValue} updateValue={updateTodayValue} />
      <Spacer />
      <Box>
          <Link as={RouterLink} to={`/tallies/${tally.id}`}>See detail</Link>
      </Box>
  </Flex>
}

export const TallyList = () => {
  const tallyService = useContext(TallyServiceContext)

  return (
      <VStack>
          {tallyService.tallies?.map(tally => <TallyRow tally={tally} key={tally.id} />)}
      </VStack>
  )
}