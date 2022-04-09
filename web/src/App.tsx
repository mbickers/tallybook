import { useEffect, useState } from 'react';
import { initializeApp } from "firebase/app"
import { getFirestore, collection, where, query, orderBy, onSnapshot } from "firebase/firestore"
import { getAuth, signInWithEmailAndPassword, User } from "firebase/auth"
import { Field, Form, Formik } from "formik"

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

enum TallyKind {
  Completion = "Completion",
  Counter = "Counter",
  Amount = "Amount",
}

type Tally = {
  kind: TallyKind,
  id?: string,
  name: string,
  entries: unknown,
  listPriority: number,
  userId?: string,
}

const TallyBlock = ({ tally }: { tally: Tally }) => {


  return <div>
    <h2>{tally.name}</h2>
    <p>entries</p>
  </div>
}

const TallyList = ({ user }: { user: User }) => {
  const [tallies, setTallies] = useState<Tally[]>([])

  useEffect(() => {
    const talliesRef = collection(firestore, "tallies")
    const talliesQuery = query(talliesRef, where("userId", "==", user.uid), orderBy("listPriority"))
    const unsubscribe = onSnapshot(talliesQuery, snapshot => {
      console.log("In query")
      const tallies = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as Tally))
      setTallies(tallies)
    })
    return unsubscribe
  }, [])

  return <>{tallies.map(tally => <TallyBlock tally={tally} key={tally.id} />)}</>
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
        <TallyList user={user} />
      </> :
      <Login />}
  </>
}

export default App;
