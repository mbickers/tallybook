import { ChevronDownIcon } from '@chakra-ui/icons';
import {
  Box, Flex, Spacer, Menu, MenuButton, Button, MenuList, MenuItem,
} from '@chakra-ui/react';
import { FirebaseApp } from 'firebase/app';
import { getAuth, User } from 'firebase/auth';
import { useContext, useEffect, useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { FirebaseContext } from '../providers/FirebaseProvider';
import TallybookHeading from './TallybookHeading';

function UserBox() {
  const firebase = useContext(FirebaseContext) as FirebaseApp;
  const auth = getAuth(firebase);
  const [user, setUser] = useState<User | null>(auth.currentUser);
  const location = useLocation();

  useEffect(() => {
    const unsubscribe = auth.onAuthStateChanged((newUser) => {
      setUser(newUser);
    });

    return unsubscribe;
  }, []);

  if (!user) {
    return <Button as={Link} size="sm" colorScheme="accent" to="/signin">Sign In</Button>;
  }

  if (location.pathname.startsWith('/tallies')) {
    return (
      <Menu>
        <MenuButton as={Button} rightIcon={<ChevronDownIcon />} variant="ghost" h="2rem">
          {user.email}
        </MenuButton>
        <MenuList>
          <MenuItem onClick={() => auth.signOut()}>Sign Out</MenuItem>
        </MenuList>
      </Menu>
    );
  }

  return <Button as={Link} size="sm" colorScheme="accent" to="/tallies">Go to Tallies</Button>;
}

export default function Header() {
  return (
    <Box as="header" pos="fixed" w="100%" bg="white" zIndex="1">
      <Flex maxW="50rem" m="auto" alignItems="center">
        <TallybookHeading />
        <Spacer />
        <UserBox />
      </Flex>
    </Box>
  );
}
