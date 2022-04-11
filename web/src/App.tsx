import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom"
import { TallyDetail } from './TallyDetail';
import { FirebaseProvider } from './FirebaseProvider';
import { Tallies } from './Tallies';
import { Login } from './Login';

const App = () => {
  return (
    <FirebaseProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<h1>Homepage</h1>} />
          <Route path="/login" element={<Login />} />
          <Route path="/signup" element={<h1>Signup</h1>} />
          <Route path="/reset-password" element={<h1>Reset Password</h1>} />
          <Route path="/tallies" element={<Tallies />} >
            <Route path=":id" element={<TallyDetail />} />
          </Route>
          <Route path="/*" element={<Navigate to="/" />} />
        </Routes>
      </BrowserRouter> 
    </FirebaseProvider>
  )
}

export default App;
