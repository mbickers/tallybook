import { AddIcon, ChevronDownIcon } from "@chakra-ui/icons"
import { Box, Button, Flex, FormControl, FormLabel, Heading, HStack, Input, Menu, MenuButton, MenuItem, MenuList, Modal, ModalBody, ModalCloseButton, ModalContent, ModalFooter, ModalHeader, ModalOverlay, Radio, RadioGroup, Spacer, Stack, Text, useDisclosure, VStack } from "@chakra-ui/react"
import { FirebaseApp } from "firebase/app"
import { User, getAuth } from "firebase/auth"
import { Field, FieldProps, Formik } from "formik"
import { useContext } from "react"
import { Outlet } from "react-router-dom"
import { TallyList } from "../components/TallyList"
import { FirebaseContext } from "../providers/FirebaseProvider"
import { TallyServiceContext, TallyServiceProvider } from "../providers/TallyServiceProvider"
import { UserContext, UserProvider } from "../providers/UserProvider"
import { TallyKind } from "../types"

const Header = () => {
  const firebase = useContext(FirebaseContext) as FirebaseApp
  const user = useContext(UserContext) as User
  const auth = getAuth(firebase)

    return <Box as='header' pos='fixed' w='100%' bg='white' zIndex='1'>
        <Flex maxW='50rem' m='auto' mt='0.1rem'>
            <Heading>Tallybook</Heading>
            <Spacer />
            <Menu>
                <MenuButton as={Button} rightIcon={<ChevronDownIcon />} variant='ghost'>
                    {user.email}
                </MenuButton>
                <MenuList>
                    <MenuItem onClick={() => auth.signOut()}>Sign Out</MenuItem>
                </MenuList>
            </Menu>
        </Flex>
    </Box>
}

const AddTallyButton = () => {
    const tallyService = useContext(TallyServiceContext)
    const { isOpen, onOpen, onClose } = useDisclosure()

    return (
        <>
            <Button leftIcon={<AddIcon />} colorScheme='green' onClick={onOpen} >Add a Tally</Button>

            <Modal isOpen={isOpen} onClose={onClose}>
                <ModalOverlay />
                <ModalContent>
                    <ModalHeader>Add a Tally</ModalHeader>
                    <Formik
                        initialValues={{ name: "", kind: TallyKind.Completion }}
                        onSubmit={({ name, kind }) => {
                            tallyService.addTally(kind, name)
                            onClose()
                        }}
                    >
                        {({ handleSubmit }) => (
                            <form onSubmit={handleSubmit} autoComplete='off'>
                                <ModalBody>
                                    <VStack spacing={4} align="begin">
                                        <FormControl>
                                            <FormLabel>Name</FormLabel>
                                            <Field
                                                as={Input}
                                                id="name"
                                                name="name"
                                                variant="filled"
                                            />
                                        </FormControl>
                                        <Field name='kind'>
                                            {({ field }: FieldProps) => (
                                                <FormControl>
                                                    <RadioGroup {...field} id='kind'>
                                                        <HStack spacing='1rem'>
                                                            {Object.keys(TallyKind).map(value => (
                                                                <Radio key={value} {...field} value={value}>
                                                                    {value}
                                                                </Radio>
                                                            ))}
                                                        </HStack>
                                                    </RadioGroup>
                                                </FormControl>
                                            )}
                                        </Field>
                                    </VStack>
                                </ModalBody>
                                <ModalFooter>
                                    <HStack>
                                        <Button variant='ghost' mr='1rem' onClick={onClose}>Cancel</Button>
                                        <Button colorScheme='green' type='submit'>
                                            Add Tally
                                        </Button>
                                    </HStack>
                                </ModalFooter>
                            </form>)}
                    </Formik>
                </ModalContent>
            </Modal>
        </>
    )
}

export const Tallies = () => {
    return (
        <UserProvider>
            <TallyServiceProvider>
                <Box bg='gray.100' minH='100vh'>
                    <Header />
                    <HStack align='baseline' m='auto' maxW='50rem' py='3.5rem'>
                        <TallyList />
                        <Outlet />
                    </HStack>
                    <Box position='fixed' bottom='1rem' right='calc(1rem + (100vw - 50rem) / 2)'>
                        <AddTallyButton />
                    </Box>
                </Box>
            </TallyServiceProvider>
        </UserProvider>
    )
}