import { useContext } from 'react';
import { Link as RouterLink, useLocation } from 'react-router-dom';
import {
  Button, Flex, Heading, HStack, IconButton, NumberInput, NumberInputField, Spacer, VStack,
} from '@chakra-ui/react';
import { CheckIcon, ChevronRightIcon } from '@chakra-ui/icons';
import formattedDate from '../utils';
import { TallyServiceContext } from '../providers/TallyServiceProvider';
import { Tally, TallyKind } from '../types';

function TallyInput({ kind, value, updateValue }: { kind: TallyKind, value: number, updateValue: (newValue: number) => void }) {
  switch (kind) {
    case TallyKind.Completion:
      if (value === 1) {
        return <IconButton w="1rem" icon={<CheckIcon />} aria-label="complete tally" colorScheme="accent" onClick={() => updateValue(0)} />;
      }
      return <IconButton w="1rem" icon={<CheckIcon />} aria-label="complete tally" variant="outline" onClick={() => updateValue(1)} />;

    case TallyKind.Amount:
      return (
        <NumberInput value={value} onChange={(_, newValue) => updateValue(newValue)}>
          <NumberInputField />
        </NumberInput>
      );
    case TallyKind.Counter:
      return (
        <HStack>
          <Button onClick={() => updateValue(1 + value)}>+</Button>
          <NumberInput value={value} onChange={(_, newValue) => updateValue(newValue)}>
            <NumberInputField />
          </NumberInput>
        </HStack>
      );
  }
}

export default function TallyRow({ tally }: { tally: Tally }) {
  const tallyService = useContext(TallyServiceContext);
  const { entries } = tally.entries;
  const todayFormatted = formattedDate(new Date());
  const entriesIncludesToday = entries.length > 0 && entries[0].formattedDate === todayFormatted;
  const todayValue = entriesIncludesToday ? entries[0].value : 0;

  const detailLocation = `/tallies/${tally.id}`;
  const showingDetail = useLocation().pathname === detailLocation;
  const linkProps = showingDetail ? { colorScheme: 'accent', variant: 'solid', to: '/tallies' } : { to: detailLocation };

  const updateTodayValue = (value: number) => {
    const otherEntries = entriesIncludesToday ? entries.slice(1) : entries;
    const newEntries = value === 0
      ? otherEntries : [{ value, formattedDate: formattedDate(new Date()) }, ...otherEntries];
    if (tallyService.updateTally) {
      tallyService.updateTally({ ...tally, entries: { entries: newEntries } });
    }
  };

  return (
    <Flex w="inherit" p="0.4rem" bg="white" borderRadius="lg" direction="row" gap="0.2rem">
      <VStack align="begin">
        <Heading size="md">{tally.name}</Heading>
        <TallyInput kind={tally.kind} value={todayValue} updateValue={updateTodayValue} />
      </VStack>
      <Spacer />
      <IconButton size="lg" h="inherit" as={RouterLink} icon={<ChevronRightIcon />} aria-label="see detail" variant="ghost" {...linkProps} />
    </Flex>
  );
}
