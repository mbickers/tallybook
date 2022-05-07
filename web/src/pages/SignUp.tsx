import { Button, Center, Divider, FormControl, FormLabel, Heading, Input, Link, Text, VStack } from "@chakra-ui/react"
import { FirebaseApp } from "firebase/app"
import { AuthError, createUserWithEmailAndPassword, getAuth } from "firebase/auth"
import { Formik, Field } from "formik"
import { useContext, useState } from "react"
import { useNavigate, Link as RouterLink } from "react-router-dom"
import { FirebaseContext } from "../providers/FirebaseProvider"

export const SignUp = () => {
  const navigate = useNavigate()
  const firebase = useContext(FirebaseContext) as FirebaseApp
  const auth = getAuth(firebase) 
  const [error, setError] = useState('')

  return (
    <Center bg='gray.100' h='100vh'>
      <VStack bg='white' w='xs' borderRadius='lg' p='1rem' align='begin'>
        <Heading>Tallybook</Heading>
        <Divider />
        <Text color='red'>{error}</Text>
        <Formik
          initialValues={{ email: "", password: "" }}
          onSubmit={({ email, password }) => {
            createUserWithEmailAndPassword(auth, email, password)
              .then(() => navigate("/tallies"))
              .catch((error: AuthError) => {
                setError(error.message)
              })
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
                </FormControl>
                <Button type="submit" colorScheme='green' variant="solid" isFullWidth>
                  Sign Up
                </Button>
              </VStack>
            </form>)}
        </Formik>
        <Text>Already have an account? <Link color='green' as={RouterLink} to='/signin' >Sign in.</Link></Text>
      </VStack>
    </Center>
  )
}
