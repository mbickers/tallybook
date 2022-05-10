import { AddIcon, DeleteIcon, EditIcon } from "@chakra-ui/icons"
import { Button, Heading, HStack, IconButton, Spacer, Table, TableContainer, Tbody, Td, Th, Thead, Tr, useDisclosure, VStack } from "@chakra-ui/react"
import { useContext } from "react"
import { Navigate, useParams } from "react-router-dom"
import { TallyServiceContext } from "../providers/TallyServiceProvider"
import { Tally } from "../types"
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
                <Button isFullWidth leftIcon={<AddIcon />}>Add Entry</Button>
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
                        {tally.entries.entries.map(entry => (
                            <Tr key={entry.formattedDate}>
                                <Td>{entry.formattedDate}</Td>
                                <Td isNumeric>{entry.value}</Td>
                                <Td>
                                    <HStack>
                                        <Spacer />
                                        <Button size='xs'>Edit</Button>
                                        <IconButton size='xs' colorScheme='red' aria-label='delete entry' icon={<DeleteIcon />} />
                                    </HStack>
                                </Td>
                            </Tr>
                        ))}
                    </Tbody>
                </Table>
            </TableContainer>
            <Button colorScheme='red' leftIcon={<DeleteIcon />} onClick={() => tallyService.removeTally(tally) }>Delete Tally</Button>
        </VStack>
    )
}