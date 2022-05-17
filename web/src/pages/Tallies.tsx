import { AddIcon } from '@chakra-ui/icons';
import {
  Box, Button, HStack, useDisclosure,
} from '@chakra-ui/react';
import { useContext } from 'react';
import { Outlet } from 'react-router-dom';
import EditTallyModal from '../components/EditTallyModal';
import Header from '../components/Header';
import TallyList from '../components/TallyList';
import { TallyServiceContext, TallyServiceProvider } from '../providers/TallyServiceProvider';
import { UserProvider } from '../providers/UserProvider';
import { TallyKind } from '../types';

function AddTallyButton() {
  const tallyService = useContext(TallyServiceContext);
  const { isOpen, onOpen, onClose } = useDisclosure();

  return (
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
  );
}

export default function Tallies() {
  return (
    <UserProvider>
      <TallyServiceProvider>
        <Header />
        <HStack align="baseline" m="auto" maxW="50rem" pt="3.5rem" pb="4.5rem">
          <TallyList />
          <Outlet />
        </HStack>
        <AddTallyButton />
      </TallyServiceProvider>
    </UserProvider>
  );
}
