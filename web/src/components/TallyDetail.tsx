import { AddIcon, DeleteIcon, EditIcon } from "@chakra-ui/icons"
import { Button, Heading, HStack, IconButton, Spacer, Table, TableContainer, Tbody, Td, Th, Thead, Tr, useDisclosure, VStack } from "@chakra-ui/react"
import { useContext } from "react"
import { Navigate, useParams } from "react-router-dom"
import { TallyServiceContext } from "../providers/TallyServiceProvider"
import { Tally, TallyEntry } from "../types"
import { formattedDate } from "../utils"
import { EditEntryModal } from "./EditEntryModal"
import { EditTallyModal } from "./EditTallyModal"

const EditTallyButton = ({tally}: {tally: Tally}) => {
    const tallyService = useContext(TallyServiceContext)
    const { isOpen, onOpen, onClose } = useDisclosure()
    return <>
        <Button isFullWidth leftIcon={<EditIcon />} onClick={onOpen} >Edit Tally</Button>
        <EditTallyModal
            mode='Edit'
            initialValues={tally}
            isOpen={isOpen}
            onConfirm={(name, kind) => {
                const updatedTally = {...tally, name, kind}
                tallyService.updateTally(updatedTally)
            }}
            onClose={onClose}
        />
    </>
}

const AddEntryButton = ({tally}: {tally: Tally}) => {
    const tallyService = useContext(TallyServiceContext)
    const { isOpen, onOpen, onClose } = useDisclosure()
    return <>
        <Button isFullWidth leftIcon={<AddIcon />} onClick={onOpen} >Add Entry</Button>
        <EditEntryModal
            mode='Add'
            initialValues={{formattedDate: formattedDate(new Date()), value: 0}}
            isOpen={isOpen}
            onConfirm={(newEntry) => {
                const updatedEntryList = [newEntry].concat(tally.entries.entries)
                const updatedTally = {...tally, entries: {entries: updatedEntryList}}
                tallyService.updateTally(updatedTally)
            }}
            onClose={onClose}
        />
    </>
}

const EntryRow = ({ entry, tally }: {entry: TallyEntry, tally: Tally}) => {
    const tallyService = useContext(TallyServiceContext)
    const { isOpen, onOpen, onClose } = useDisclosure()

    return (
        <Tr>
            <Td>{entry.formattedDate}</Td>
            <Td isNumeric>{entry.value}</Td>
            <Td>
                <HStack>
                    <Spacer />
                    <Button size='xs' onClick={onOpen} >Edit</Button>
                    <IconButton size='xs' colorScheme='red' aria-label='delete entry' icon={<DeleteIcon />} 
                        onClick={() => {
                            const deletedDate = entry.formattedDate
                            const updatedEntryList = tally.entries.entries.filter(entry => entry.formattedDate != deletedDate)
                            const updatedTally = { ...tally, entries: {entries: updatedEntryList}}
                            tallyService.updateTally(updatedTally)
                        }} />
                    <EditEntryModal
                        mode='Edit'
                        initialValues={entry}
                        isOpen={isOpen}
                        onConfirm={(newEntry) => {
                            const replacedDate = entry.formattedDate
                            const filteredEntryList = tally.entries.entries.filter(entry => entry.formattedDate != replacedDate)
                            const updatedEntryList = [newEntry].concat(filteredEntryList)
                            const updatedTally = { ...tally, entries: { entries: updatedEntryList } }
                            tallyService.updateTally(updatedTally)
                        }}
                        onClose={onClose}
                    />
                </HStack>
            </Td>
        </Tr>
    )
}

export const TallyDetail = () => {
  const id = useParams().id
  const tallyService = useContext(TallyServiceContext)
  const tally = tallyService.tallies?.find(tally => tally.id == id)

  if (!tally) {
      return <Navigate to='/tallies' />
  }

    return (
        <VStack p='0.4rem' bg='white' borderRadius='lg' direction='column' w='100%' align='begin' position='sticky' top='3.5rem'>
            <Heading size='md'>{tally.name}</Heading>
            <HStack>
                <EditTallyButton tally={tally} />
                <AddEntryButton tally={tally} />
            </HStack>
            <TableContainer>
                <Table>
                    <Thead>
                        <Tr>
                            <Th>Date</Th>
                            <Th isNumeric>Value</Th>
                            <Th></Th>
                        </Tr>
                    </Thead>
                    <Tbody>
                        {tally.entries.entries.map(entry => <EntryRow key={entry.formattedDate} entry={entry} tally={tally} />)}
                    </Tbody>
                </Table>
            </TableContainer>
            <Button colorScheme='red' leftIcon={<DeleteIcon />} onClick={() => tallyService.removeTally(tally) }>Delete Tally</Button>
        </VStack>
    )
}