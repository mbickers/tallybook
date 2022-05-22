import { FirebaseApp, initializeApp } from 'firebase/app';
import React, { ReactNode, useMemo } from 'react';

export const FirebaseContext = React.createContext<FirebaseApp>({} as FirebaseApp);

export function FirebaseProvider({ children }: { children: ReactNode }) {
  const app = useMemo(() => {
    const firebaseConfig = JSON.parse(process.env.REACT_APP_FIREBASE_CONFIG as string);
    return initializeApp(firebaseConfig);
  }, []);

  return (
    <FirebaseContext.Provider value={app}>
      {children}
    </FirebaseContext.Provider>
  );
}
