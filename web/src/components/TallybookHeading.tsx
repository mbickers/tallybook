import {
  HStack, Heading, Image, Link,
} from '@chakra-ui/react';
import { Link as RouterLink } from 'react-router-dom';

export default function TallybookHeading() {
  return (
    <Link as={RouterLink} to="/" variant="no-underline">
      <HStack spacing="0.5rem">
        <Image boxSize="2.5rem" src="/logo.png" />
        <Heading>Tallybook</Heading>
      </HStack>
    </Link>
  );
}
