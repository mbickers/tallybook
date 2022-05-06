import { ChevronDownIcon } from "@chakra-ui/icons"
import { Box, Button, Center, Container, Flex, Heading, HStack, IconButton, Image, Menu, MenuButton, MenuItem, MenuList, Spacer, Text } from "@chakra-ui/react"
import { FirebaseApp } from "firebase/app"
import { User, getAuth } from "firebase/auth"
import { useContext } from "react"
import { Outlet } from "react-router-dom"
import { TallyList } from "../components/TallyList"
import { FirebaseContext } from "../providers/FirebaseProvider"
import { TallyServiceProvider } from "../providers/TallyServiceProvider"
import { UserContext, UserProvider } from "../providers/UserProvider"

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

export const Tallies = () => {
    return (
        <UserProvider>
            <TallyServiceProvider>
                <Box bg='gray.100' h='100vh'>
                    <Header />
                    <HStack m='auto' align='baseline' maxW='50rem' pt='3.5rem'>
                        <TallyList />
                        <Outlet />
                    </HStack>
                </Box>
            </TallyServiceProvider>
        </UserProvider>
    )
}