import { useEffect, useState } from 'react';
import { initializeApp } from "firebase/app"
import { getFirestore } from "firebase/firestore"
import { getAuth, signInWithEmailAndPassword, User } from "firebase/auth"
import { Field, Form, Formik } from "formik"
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom"
import { TallyServiceContext, TallyServiceProvider } from './TallyServiceProvider';
import { TallyList } from './TallyList';
import { TallyDetail } from './TallyDetail';

const firebaseConfig = {
  apiKey: process.env.REACT_APP_FIREBASE_API_KEY,
  authDomain: process.env.REACT_APP_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.REACT_APP_FIREBASE_PROJECT_ID,
  storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.REACT_APP_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.REACT_APP_FIREBASE_APP_ID,
};

const app = initializeApp(firebaseConfig);
const firestore = getFirestore(app)
const auth = getAuth(app)

const Login = () => {
  return (
    <Formik
      initialValues={{ email: "", password: "" }}
      onSubmit={({ email, password }) => {
        signInWithEmailAndPassword(auth, email, password)
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


const App = () => {
  const [user, setUser] = useState<User | null>(null)

  useEffect(() => {
    const unsubscribe = auth.onAuthStateChanged(user => {
      setUser(user)
    })

    return unsubscribe
  })

  const userInfo = <p>{user?.email} <button onClick={() => auth.signOut()}>Sign out</button></p>

  return (
    <TallyServiceProvider firestore={firestore} user={user}>
      <BrowserRouter>
        {user ? userInfo : []}
        <Routes>
          <Route path="/" element={<Navigate to="/tallies" />} />
          <Route path="/login" element={user ? <Navigate to="/tallies" /> : <Login />} />
          <Route path="/tallies" element={user ? <TallyList /> : <Navigate to="/login" />} >
            <Route path=":id" element={<TallyDetail />} />
          </Route>
        </Routes>
      </BrowserRouter> 
    </TallyServiceProvider>
  )
}

export default App;
