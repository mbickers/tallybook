import {
  BrowserRouter, Routes, Route, Navigate,
} from 'react-router-dom';
import {
  Box, ChakraProvider, extendTheme, Heading,
} from '@chakra-ui/react';
import TallyDetail from './components/TallyDetail';
import { FirebaseProvider } from './providers/FirebaseProvider';
import Tallies from './pages/Tallies';
import SignIn from './pages/SignIn';
import SignUp from './pages/SignUp';
import ForgotPassword from './pages/ForgotPassword';
import ResetPassword from './pages/ResetPassword';

const theme = extendTheme({
  colors: {
    accent: {
      50: '#e2fdea',
      100: '#bdf0cb',
      200: '#98e6ac',
      300: '#70da8b',
      400: '#49cf6b',
      500: '#30b651',
      600: '#238e3e',
      700: '#16652b',
      800: '#083e18',
      900: '#001602',
    },
  },
  fonts: {
    body: 'Nunito, sans-serif',
    heading: 'Nunito, sans-serif',
  },
});

function App() {
  return (
    <ChakraProvider theme={theme}>
      <FirebaseProvider>
        <Box bg="gray.100" minH="100vh">
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
        </Box>
      </FirebaseProvider>
    </ChakraProvider>
  );
}

export default App;
