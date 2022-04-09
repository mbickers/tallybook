import { useContext, useEffect, useState } from 'react';
import { initializeApp } from "firebase/app"
import { getFirestore } from "firebase/firestore"
import { getAuth, signInWithEmailAndPassword, User } from "firebase/auth"
import { Field, Form, Formik } from "formik"
import { Tally } from './types';
import { TallyServiceContext, TallyServiceProvider } from './TallyServiceProvider';
import { formattedDate } from './FormattedDate';

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

const TallyRow = ({ tally }: { tally: Tally }) => {
  const entries = tally.entries.entries
  const todayValue = (entries.length > 0 && entries[0].formattedDate == formattedDate(new Date())) ? entries[0].value : 0
  return <div>
    <h2>{tally.name}</h2>
    <p>{todayValue}</p>
  </div>
}

const TallyList = () => {
  const tallyService = useContext(TallyServiceContext)

  return <>{tallyService.tallies?.map(tally => <TallyRow tally={tally} key={tally.id} />)}</>
}

const App = () => {
  const [user, setUser] = useState<User | null>(null)

  useEffect(() => {
    const unsubscribe = auth.onAuthStateChanged(user => {
      setUser(user)
    })

    return unsubscribe
  })

  return <>
    <h1>Tallybook</h1>
    {user ?
      <>
        <p>{user.email} <button onClick={() => auth.signOut()}>Sign out</button></p>
        <TallyServiceProvider firestore={firestore} user={user}>
          <TallyList />
        </TallyServiceProvider>
      </> :
      <Login />}
  </>
}

export default App;
