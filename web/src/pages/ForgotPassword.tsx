import {
  Button, Center, Divider, FormControl, FormLabel, Input, Text, VStack,
} from '@chakra-ui/react';
import { FirebaseApp } from 'firebase/app';
import { AuthError, getAuth, sendPasswordResetEmail } from 'firebase/auth';
import { Formik, Field } from 'formik';
import { useContext, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import TallybookHeading from '../components/TallybookHeading';
import { FirebaseContext } from '../providers/FirebaseProvider';

export default function ForgotPassword() {
  const navigate = useNavigate();
  const firebase = useContext(FirebaseContext) as FirebaseApp;
  const auth = getAuth(firebase);
  const [error, setError] = useState('');

  return (
    <Center bg="gray.100" h="100vh">
      <VStack bg="white" w="xs" borderRadius="lg" p="1rem" align="begin">
        <TallybookHeading />
        <Divider />
        <Text color="red">{error}</Text>
        <Formik
          initialValues={{ email: '' }}
          onSubmit={({ email }) => {
            sendPasswordResetEmail(auth, email)
              .then(() => navigate('/signin'))
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
                <Button type="submit" colorScheme="green" variant="solid" isFullWidth>
                  Send Reset Email
                </Button>
              </VStack>
            </form>
          )}
        </Formik>
      </VStack>
    </Center>
  );
}
