import {
  Button, Center, Divider, Flex, FormControl, FormLabel, Input, Link, Spacer, Text, VStack,
} from '@chakra-ui/react';
import { FirebaseApp } from 'firebase/app';
import { AuthError, getAuth, signInWithEmailAndPassword } from 'firebase/auth';
import { Formik, Field } from 'formik';
import { useContext, useState } from 'react';
import { useNavigate, Link as RouterLink } from 'react-router-dom';
import TallybookHeading from '../components/TallybookHeading';
import { FirebaseContext } from '../providers/FirebaseProvider';

export default function SignIn() {
  const navigate = useNavigate();
  const firebase = useContext(FirebaseContext) as FirebaseApp;
  const auth = getAuth(firebase);
  const [error, setError] = useState('');

  return (
    <Center h="100vh">
      <VStack bg="white" w="xs" borderRadius="lg" p="1rem" align="begin">
        <TallybookHeading />
        <Divider />
        <Text color="red">{error}</Text>
        <Formik
          initialValues={{ email: '', password: '' }}
          onSubmit={({ email, password }) => {
            signInWithEmailAndPassword(auth, email, password)
              .then(() => navigate('/tallies'))
              .catch((authError: AuthError) => {
                setError(authError.message);
              });
          }}
        >
          {({ handleSubmit }) => (
            <form onSubmit={handleSubmit}>
              <VStack spacing={4} align="begin">
                <FormControl>
                  <FormLabel htmlFor="email">Email</FormLabel>
                  <Field
                    as={Input}
                    id="email"
                    name="email"
                    type="email"
                    variant="filled"
                  />
                </FormControl>
                <FormControl>
                  <FormLabel htmlFor="password">Password</FormLabel>
                  <Field
                    as={Input}
                    id="password"
                    name="password"
                    type="password"
                    variant="filled"
                  />
                  <Flex direction="row">
                    <Spacer />
                    <Link as={RouterLink} to="/forgot-password">Forgot password?</Link>
                  </Flex>
                </FormControl>
                <Button type="submit" colorScheme="accent" variant="solid" w="auto">
                  Sign In
                </Button>
              </VStack>
            </form>
          )}
        </Formik>
        <Text>
          Need an account?
          {' '}
          <Link as={RouterLink} to="/signup">Sign up.</Link>
        </Text>
      </VStack>
    </Center>
  );
}
