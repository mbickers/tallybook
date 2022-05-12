import { AddIcon, ChevronDownIcon } from '@chakra-ui/icons';
import {
  Box, Button, Flex, HStack, Menu, MenuButton, MenuItem, MenuList, Spacer, useDisclosure,
} from '@chakra-ui/react';
import { FirebaseApp } from 'firebase/app';
import { User, getAuth } from 'firebase/auth';
import { useContext } from 'react';
import { Outlet } from 'react-router-dom';
import EditTallyModal from '../components/EditTallyModal';
import TallybookHeading from '../components/TallybookHeading';
import TallyList from '../components/TallyList';
import { FirebaseContext } from '../providers/FirebaseProvider';
import { TallyServiceContext, TallyServiceProvider } from '../providers/TallyServiceProvider';
import { UserContext, UserProvider } from '../providers/UserProvider';
import { TallyKind } from '../types';

function Header() {
  const firebase = useContext(FirebaseContext) as FirebaseApp;
  const user = useContext(UserContext) as User;
  const auth = getAuth(firebase);

  return (
    <Box as="header" pos="fixed" w="100%" bg="white" zIndex="1">
      <Flex maxW="50rem" m="auto" mt="0.1rem">
        <TallybookHeading />
        <Spacer />
        <Menu>
          <MenuButton as={Button} rightIcon={<ChevronDownIcon />} variant="ghost">
            {user.email}
          </MenuButton>
          <MenuList>
            <MenuItem onClick={() => auth.signOut()}>Sign Out</MenuItem>
          </MenuList>
        </Menu>
      </Flex>
    </Box>
  );
}

export default function Tallies() {
  const tallyService = useContext(TallyServiceContext);
  const { isOpen, onOpen, onClose } = useDisclosure();

  return (
    <UserProvider>
      <TallyServiceProvider>
        <Header />
        <HStack align="baseline" m="auto" maxW="50rem" pt="3.5rem" pb="4.5rem">
          <TallyList />
          <Outlet />
        </HStack>
        <Box position="fixed" bottom="1rem" right="calc(1rem + (100vw - 50rem) / 2)">
          <Button leftIcon={<AddIcon />} colorScheme="accent" onClick={onOpen}>Add a Tally</Button>
          <EditTallyModal
            mode="Add"
            initialValues={{ name: '', kind: TallyKind.Completion }}
            isOpen={isOpen}
            onConfirm={tallyService.addTally}
            onClose={onClose}
          />
        </Box>
      </TallyServiceProvider>
    </UserProvider>
  );
}
