import { AddIcon } from '@chakra-ui/icons';
import {
  Box, Button, HStack, useDisclosure, useMediaQuery, VStack,
} from '@chakra-ui/react';
import { useContext } from 'react';
import { Outlet, useLocation } from 'react-router-dom';
import EditTallyModal from '../components/EditTallyModal';
import Header from '../components/Header';
import TallyRow from '../components/TallyRow';
import { TallyServiceContext, TallyServiceProvider } from '../providers/TallyServiceProvider';
import { UserProvider } from '../providers/UserProvider';
import { TallyKind } from '../types';

function AddTallyButton() {
  const tallyService = useContext(TallyServiceContext);
  const { isOpen, onOpen, onClose } = useDisclosure();

  return (
    <Box position="fixed" bottom="1rem" right="calc(1rem + (100vw - var(--chakra-sizes-max-content-width)) / 2)">
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

function Contents() {
  const tallyService = useContext(TallyServiceContext);
  const location = useLocation().pathname;
  const [useSplitLayout] = useMediaQuery('(min-width: 40rem)');

  if (useSplitLayout) {
    return (
      <>
        <HStack align="baseline" m="auto" maxW="max-content-width">
          <VStack w="18rem">
            {tallyService.tallies?.map((tally) => <TallyRow tally={tally} key={tally.id} />)}
          </VStack>
          <Outlet />
        </HStack>
        <AddTallyButton />
      </>
    );
  }

  if (location === '/tallies') {
    return (
      <>
        <VStack w="100%">
          {tallyService.tallies?.map((tally) => <TallyRow tally={tally} key={tally.id} />)}
        </VStack>
        <AddTallyButton />
      </>
    );
  }

  return <Outlet />;
}

export default function Tallies() {
  return (
    <UserProvider>
      <TallyServiceProvider>
        <Header />
        <Box pt="3.5rem" pb="4.5rem">
          <Contents />
        </Box>
      </TallyServiceProvider>
    </UserProvider>
  );
}
