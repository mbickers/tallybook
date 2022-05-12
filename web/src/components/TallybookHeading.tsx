import { HStack, Heading, Image } from '@chakra-ui/react';

export default function TallybookHeading() {
  return (
    <HStack spacing="0.5rem">
      <Image boxSize="2.5rem" src="/logo.png" />
      <Heading>Tallybook</Heading>
    </HStack>
  );
}
