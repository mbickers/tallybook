import { Button, FormControl, FormErrorMessage, FormLabel, Input, VStack } from "@chakra-ui/react"
import { FirebaseApp } from "firebase/app"
import { getAuth, signInWithEmailAndPassword } from "firebase/auth"
import { Formik, Form, Field } from "formik"
import { useContext } from "react"
import { useNavigate } from "react-router-dom"
import { FirebaseContext } from "../providers/FirebaseProvider"

export const Login = () => {
  const navigate = useNavigate()
  const firebase = useContext(FirebaseContext) as FirebaseApp
  const auth = getAuth(firebase) 

  return (
    <Formik
      initialValues={{ email: "", password: "" }}
      onSubmit={({ email, password }) => {
        signInWithEmailAndPassword(auth, email, password)
        .then(() => navigate("/tallies"))
      }}
    >
      {({ handleSubmit, errors, touched }) => (
        <form onSubmit={handleSubmit}>
          <VStack spacing={4} align="flex-start">
            <FormControl>
              <FormLabel htmlFor="email">Email Address</FormLabel>
              <Field
                as={Input}
                id="email"
                name="email"
                type="email"
                variant="filled"
              />
            </FormControl>
            <FormControl isInvalid={!!errors.password && touched.password}>
              <FormLabel htmlFor="password">Password</FormLabel>
              <Field
                as={Input}
                id="password"
                name="password"
                type="password"
                variant="filled"
              />
            </FormControl>
            <Button type="submit" variant="solid" isFullWidth>
              Login
            </Button>
          </VStack>
        </form>)}
    </Formik>
  )
}
