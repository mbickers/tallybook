import {
  Button, Center, Divider, FormControl, FormLabel, Input, Text, VStack,
} from '@chakra-ui/react';
import { FirebaseApp } from 'firebase/app';
import { AuthError, confirmPasswordReset, getAuth } from 'firebase/auth';
import { Formik, Field } from 'formik';
import { useContext, useState } from 'react';
import { useNavigate, useLocation, Navigate } from 'react-router-dom';
import TallybookHeading from '../components/TallybookHeading';
import { FirebaseContext } from '../providers/FirebaseProvider';

export default function ResetPassword() {
  const navigate = useNavigate();
  const firebase = useContext(FirebaseContext) as FirebaseApp;
  const auth = getAuth(firebase);
  const [error, setError] = useState('');

  const oobCode = new URLSearchParams(useLocation().search).get('oobCode');

  if (!oobCode) {
    return <Navigate to="/signin" />;
  }

  return (
    <Center h="100vh">
      <VStack bg="white" w="xs" borderRadius="lg" p="1rem" align="begin">
        <TallybookHeading />
        <Divider />
        <Text color="red">{error}</Text>
        <Formik
          initialValues={{ password: '' }}
          onSubmit={({ password }) => {
            confirmPasswordReset(auth, oobCode, password)
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
                  <FormLabel htmlFor="password">New Password</FormLabel>
                  <Field
                    as={Input}
                    id="password"
                    name="password"
                    type="password"
                    variant="filled"
                  />
                </FormControl>
                <Button type="submit" colorScheme="green" variant="solid" isFullWidth>
                  Change Password
                </Button>
              </VStack>
            </form>
          )}
        </Formik>
      </VStack>
    </Center>
  );
}
