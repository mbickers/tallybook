import { DeleteIcon, EditIcon } from "@chakra-ui/icons"
import { Box, Button, Flex, Heading, HStack, IconButton, Table, TableCaption, TableContainer, Tbody, Td, Text, Th, Thead, Tr, VStack } from "@chakra-ui/react"
import { useContext } from "react"
import { useParams } from "react-router-dom"
import { TallyServiceContext } from "../providers/TallyServiceProvider"

export const TallyDetail = () => {
  const id = useParams().id
  const tallyService = useContext(TallyServiceContext)
  const tally = tallyService.tallies?.find(tally => tally.id == id)

  if (!tally) {
      return <p>Unable to view tally {id}</p>
  }

    return (
        <VStack p='0.4rem' bg='white' borderRadius='lg' direction='column' w='100%' align='begin'>
            <Heading size='md'>{tally.name}</Heading>
            <Button>Edit Tally</Button>
            <Button>Add Entry</Button>
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
                                        <Button size='xs'>Edit</Button>
                                        <IconButton size='xs' colorScheme='red' aria-label='delete entry' icon={<DeleteIcon />} />
                                    </HStack>
                                </Td>
                            </Tr>
                        ))}
                    </Tbody>
                </Table>
            </TableContainer>
            <Button colorScheme='red' leftIcon={<DeleteIcon />}>Delete Tally</Button>
        </VStack>
    )
}