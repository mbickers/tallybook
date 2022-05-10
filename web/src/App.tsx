import {
  BrowserRouter, Routes, Route, Navigate,
} from 'react-router-dom';
import { ChakraProvider, Heading } from '@chakra-ui/react';
import TallyDetail from './components/TallyDetail';
import { FirebaseProvider } from './providers/FirebaseProvider';
import Tallies from './pages/Tallies';
import SignIn from './pages/SignIn';
import SignUp from './pages/SignUp';
import ForgotPassword from './pages/ForgotPassword';
import ResetPassword from './pages/ResetPassword';

function App() {
  return (
    <ChakraProvider>
      <FirebaseProvider>
        <BrowserRouter>
          <Routes>
            <Route path="/" element={<Heading>Homepage</Heading>} />
            <Route path="/signin" element={<SignIn />} />
            <Route path="/signup" element={<SignUp />} />
            <Route path="/reset-password" element={<ResetPassword />} />
            <Route path="/forgot-password" element={<ForgotPassword />} />
            <Route path="/tallies" element={<Tallies />}>
              <Route path=":id" element={<TallyDetail />} />
            </Route>
            <Route path="/*" element={<Navigate to="/" />} />
          </Routes>
        </BrowserRouter>
      </FirebaseProvider>
    </ChakraProvider>
  );
}

export default App;
