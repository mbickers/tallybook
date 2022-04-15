import { FirebaseApp } from "firebase/app"
import { getAuth, User } from "firebase/auth"
import React, { useContext, useEffect, useState } from "react"
import { Navigate } from "react-router-dom"
import { FirebaseContext } from "./FirebaseProvider"

export const UserContext = React.createContext<User | null>(null)

export const UserProvider: React.FC = ({ children }) => {
  const firebase = useContext(FirebaseContext) as FirebaseApp
  const auth = getAuth(firebase)
  const [user, setUser] = useState<User | null>(null)
  const [hasLoaded, setHasLoaded] = useState(false)

  useEffect(() => {
    const unsubscribe = auth.onAuthStateChanged(user => {
      setUser(user)
      setHasLoaded(true)
    })

    return unsubscribe
  }, [])

  if (hasLoaded && !user) {
    return <Navigate to="/login" />
  }

  if (!user) {
    return <p>Logging in</p>
  }

  return (
    <UserContext.Provider value={user}>
      {children}
    </UserContext.Provider>
  )
}