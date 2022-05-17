import { ChevronDownIcon } from '@chakra-ui/icons';
import {
  Box, Flex, Spacer, Menu, MenuButton, Button, MenuList, MenuItem,
} from '@chakra-ui/react';
import { FirebaseApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { useContext } from 'react';
import { useNavigate } from 'react-router-dom';
import { FirebaseContext } from '../providers/FirebaseProvider';
import TallybookHeading from './TallybookHeading';

export default function Header() {
  const firebase = useContext(FirebaseContext) as FirebaseApp;
  const auth = getAuth(firebase);
  const navigate = useNavigate();

  return (
    <Box as="header" pos="fixed" w="100%" bg="white" zIndex="1">
      <Flex maxW="50rem" m="auto" alignItems="center">
        <TallybookHeading />
        <Spacer />
        {auth.currentUser
          ? (
            <Menu>
              <MenuButton as={Button} rightIcon={<ChevronDownIcon />} variant="ghost">
                {auth.currentUser.email}
              </MenuButton>
              <MenuList>
                <MenuItem onClick={() => auth.signOut()}>Sign Out</MenuItem>
              </MenuList>
            </Menu>
          )
          : <Button size="sm" colorScheme="accent" onClick={() => navigate('/signin')}>Sign In</Button> }
      </Flex>
    </Box>
  );
}
