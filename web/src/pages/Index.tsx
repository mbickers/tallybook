import {
  Button, Center, Heading, HStack, Text, VStack, Link, Flex, Spacer,
} from '@chakra-ui/react';
import { Link as RouterLink } from 'react-router-dom';
import Header from '../components/Header';

function Footer() {
  return (
    <Center pb="1rem">
      <Text color="gray">
        Made by
        {' '}
        <Link href="https://bickers.dev">Max Bickers</Link>
        {' '}
        on
        {' '}
        <Link href="https://github.com/mbickers/tallybook">Github</Link>
        .
      </Text>
    </Center>
  );
}

export default function Index() {
  return (
    <>
      <Header />
      <Flex m="auto" maxW="max-content-width" pt="3.5rem" direction="column" minH="inherit">
        <Spacer />
        <VStack w={['inherit', 'md']} align="leading" spacing="0.8rem">
          <Heading>Keep track of things you do every day.</Heading>
          <Text>Tallybook is a web and iOS app that allows you to log the things you do frequently.</Text>
          <HStack>
            <Button colorScheme="accent" as={RouterLink} to="/signup">Get Started</Button>
          </HStack>
        </VStack>
        <Spacer />
        <Footer />
      </Flex>
    </>
  );
}
