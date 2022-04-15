import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom"
import { TallyDetail } from './components/TallyDetail';
import { FirebaseProvider } from './providers/FirebaseProvider';
import { Tallies } from './pages/Tallies';
import { Login } from './pages/Login';
import { ChakraProvider, Heading } from "@chakra-ui/react";

const App = () => {
  return (
    <ChakraProvider>
      <FirebaseProvider>
        <BrowserRouter>
          <Routes>
            <Route path="/" element={<Heading>Homepage</Heading>} />
            <Route path="/login" element={<Login />} />
            <Route path="/signup" element={<Heading>Signup</Heading>} />
            <Route path="/reset-password" element={<Heading>Reset Password</Heading>} />
            <Route path="/tallies" element={<Tallies />} >
              <Route path=":id" element={<TallyDetail />} />
            </Route>
            <Route path="/*" element={<Navigate to="/" />} />
          </Routes>
        </BrowserRouter>
      </FirebaseProvider>
    </ChakraProvider>
  )
}

export default App;
