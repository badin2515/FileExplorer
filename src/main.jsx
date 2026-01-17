import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'
import { ClipboardProvider } from './contexts/ClipboardContext.jsx';

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <ClipboardProvider>
      <App />
    </ClipboardProvider>
  </StrictMode>,
)
