import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'
import { ClipboardProvider } from './contexts/ClipboardContext.jsx';
import { DragProvider } from './contexts/DragContext.jsx';
import { OperationProvider } from './contexts/OperationContext.jsx';
import { OperationBar } from './components/operations';

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <OperationProvider>
      <DragProvider>
        <ClipboardProvider>
          <App />
          <OperationBar />
        </ClipboardProvider>
      </DragProvider>
    </OperationProvider>
  </StrictMode>,
)
