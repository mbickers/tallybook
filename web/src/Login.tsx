import { FirebaseApp } from "firebase/app"
import { getAuth, signInWithEmailAndPassword } from "firebase/auth"
import { Formik, Form, Field } from "formik"
import { useContext } from "react"
import { useNavigate } from "react-router-dom"
import { FirebaseContext } from "./FirebaseProvider"

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
      <Form>
        <Field type="text" name="email" />
        <Field type="text" name="password" />
        <button type="submit" >Submit</button>
      </Form>
    </Formik>
  )
}
