import React, { createContext, useContext, useState, useCallback, useEffect } from 'react';
import { listen } from '@tauri-apps/api/event';

/**
 * OperationContext
 * 
 * Manages global file operations queue with progress tracking
 * Subscribes to Tauri events for real-time progress updates
 */

const OperationContext = createContext(null);

export const useOperations = () => {
    const context = useContext(OperationContext);
    if (!context) {
        throw new Error('useOperations must be used within OperationProvider');
    }
    return context;
};

// Generate unique ID for each operation
let operationIdCounter = 0;
const generateId = () => `op_${++operationIdCounter}_${Date.now()}`;

export const OperationProvider = ({ children }) => {
    // Operations queue: { id, type, source[], target, status, progress?, currentFile?, error? }
    const [operations, setOperations] = useState([]);

    // Add a new operation to the queue
    const addOperation = useCallback((type, sources, target) => {
        const id = generateId();
        const operation = {
            id,
            type, // 'copy' | 'move' | 'delete'
            sources, // array of paths
            target,  // destination path
            status: 'running', // 'running' | 'done' | 'error'
            progress: 0,
            currentFile: null,
            currentIndex: 0,
            totalFiles: sources?.length || 0,
            error: null,
            startTime: Date.now()
        };

        setOperations(prev => [...prev, operation]);
        return id;
    }, []);

    // Update operation status
    const updateOperation = useCallback((id, updates) => {
        setOperations(prev => prev.map(op =>
            op.id === id ? { ...op, ...updates } : op
        ));
    }, []);

    // Mark operation as complete
    const completeOperation = useCallback((id, error = null) => {
        setOperations(prev => prev.map(op =>
            op.id === id ? {
                ...op,
                status: error ? 'error' : 'done',
                progress: error ? op.progress : 100,
                error,
                endTime: Date.now()
            } : op
        ));

        // Auto-remove successful operations after 3 seconds
        if (!error) {
            setTimeout(() => {
                setOperations(prev => prev.filter(op => op.id !== id));
            }, 3000);
        }
    }, []);

    // Remove operation from queue (manual dismiss)
    const removeOperation = useCallback((id) => {
        setOperations(prev => prev.filter(op => op.id !== id));
    }, []);

    // Clear all completed/errored operations
    const clearCompleted = useCallback(() => {
        setOperations(prev => prev.filter(op => op.status === 'running'));
    }, []);

    // Subscribe to Tauri progress events
    useEffect(() => {
        const unlisteners = [];

        // Listen to copy:progress
        listen('copy:progress', (event) => {
            const payload = event.payload;
            if (payload?.operationId) {
                const progress = payload.totalFiles > 0
                    ? Math.round((payload.currentIndex / payload.totalFiles) * 100)
                    : 0;

                setOperations(prev => prev.map(op => {
                    // Match by operation_id
                    if (op.id === payload.operationId) {
                        return {
                            ...op,
                            progress,
                            currentFile: payload.currentFile,
                            currentIndex: payload.currentIndex,
                            totalFiles: payload.totalFiles
                        };
                    }
                    return op;
                }));
            }
        }).then(unlisten => unlisteners.push(unlisten));

        // Listen to move:progress
        listen('move:progress', (event) => {
            const payload = event.payload;
            if (payload?.operationId) {
                const progress = payload.totalFiles > 0
                    ? Math.round((payload.currentIndex / payload.totalFiles) * 100)
                    : 0;

                setOperations(prev => prev.map(op => {
                    if (op.id === payload.operationId) {
                        return {
                            ...op,
                            progress,
                            currentFile: payload.currentFile,
                            currentIndex: payload.currentIndex,
                            totalFiles: payload.totalFiles
                        };
                    }
                    return op;
                }));
            }
        }).then(unlisten => unlisteners.push(unlisten));

        return () => {
            unlisteners.forEach(fn => fn && fn());
        };
    }, []);

    // Check if any operation is running
    const hasRunningOperations = operations.some(op => op.status === 'running');

    return (
        <OperationContext.Provider value={{
            operations,
            hasRunningOperations,
            addOperation,
            updateOperation,
            completeOperation,
            removeOperation,
            clearCompleted
        }}>
            {children}
        </OperationContext.Provider>
    );
};

export default OperationContext;
