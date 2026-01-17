import React, { createContext, useContext, useState, useCallback } from 'react';

const ClipboardContext = createContext(null);

export const ClipboardProvider = ({ children }) => {
    // clipboardState: { items: [{path, name, type}], mode: 'copy' | 'cut' }
    const [clipboard, setClipboard] = useState(null);

    const copyItems = useCallback((items) => {
        console.log('Copying items:', items);
        setClipboard({
            items,
            mode: 'copy'
        });
    }, []);

    const cutItems = useCallback((items) => {
        console.log('Cutting items:', items);
        setClipboard({
            items,
            mode: 'cut'
        });
    }, []);

    const clearClipboard = useCallback(() => {
        setClipboard(null);
    }, []);

    return (
        <ClipboardContext.Provider value={{ clipboard, copyItems, cutItems, clearClipboard }}>
            {children}
        </ClipboardContext.Provider>
    );
};

export const useClipboard = () => useContext(ClipboardContext);
