import { Center, Spinner } from '@chakra-ui/react';
import { FirebaseApp } from 'firebase/app';
import { getAuth, User } from 'firebase/auth';
import React, {
  ReactNode, useContext, useEffect, useState,
} from 'react';
import { Navigate } from 'react-router-dom';
import { FirebaseContext } from './FirebaseProvider';

export const UserContext = React.createContext<User>({} as User);

export function UserProvider({ children }: { children: ReactNode }) {
  const firebase = useContext(FirebaseContext) as FirebaseApp;
  const auth = getAuth(firebase);
  const [user, setUser] = useState<User | null>(null);
  const [hasLoaded, setHasLoaded] = useState(false);

  useEffect(() => {
    const unsubscribe = auth.onAuthStateChanged((newUser) => {
      setUser(newUser);
      setHasLoaded(true);
    });

    return unsubscribe;
  }, []);

  if (hasLoaded && !user) {
    return <Navigate to="/signin" />;
  }

  if (!user) {
    return <Center h="100vh"><Spinner /></Center>;
  }

  return (
    <UserContext.Provider value={user}>
      {children}
    </UserContext.Provider>
  );
}
