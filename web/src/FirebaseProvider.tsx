import { FirebaseApp, initializeApp } from "firebase/app"
import React, { useMemo } from "react"

export const FirebaseContext = React.createContext<FirebaseApp | null>(null)

export const FirebaseProvider: React.FC = ({ children }) => {
  const app = useMemo(() => {
    const firebaseConfig = {
      apiKey: process.env.REACT_APP_FIREBASE_API_KEY,
      authDomain: process.env.REACT_APP_FIREBASE_AUTH_DOMAIN,
      projectId: process.env.REACT_APP_FIREBASE_PROJECT_ID,
      storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET,
      messagingSenderId: process.env.REACT_APP_FIREBASE_MESSAGING_SENDER_ID,
      appId: process.env.REACT_APP_FIREBASE_APP_ID,
    };

    return initializeApp(firebaseConfig)
  }, [])

  return (
    <FirebaseContext.Provider value={app}>
      {children}
    </FirebaseContext.Provider>
  )
}