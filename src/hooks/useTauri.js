/**
 * Tauri API Hooks
 * 
 * React hooks for communicating with Tauri backend
 * 
 * Step A Goal: UI ↔ core ↔ state machine ↔ timeline ต่อครบเป็นวง
 */

import { invoke } from '@tauri-apps/api/core';
import { listen } from '@tauri-apps/api/event';
import { useState, useEffect, useCallback } from 'react';

// ============================================
// Filesystem Hooks
// ============================================

// Helper to parse backend errors
function parseTauriError(err) {
    if (typeof err === 'string') {
        try {
            // Try to parse if it looks like JSON
            if (err.trim().startsWith('{')) {
                const parsed = JSON.parse(err);
                if (parsed.message && parsed.kind) {
                    return parsed;
                }
            }
        } catch (e) {
            // Not JSON, fall through
        }
        return { message: err, code: 'UNKNOWN_ERROR', kind: 'PERMANENT' };
    }

    // Already an object (Tauri 2.0 often returns object directly for serializable errors)
    if (typeof err === 'object' && err !== null) {
        return {
            message: err.message || 'Unknown error',
            code: err.code || 'UNKNOWN_ERROR',
            kind: err.kind || 'PERMANENT'
        };
    }

    return { message: String(err), code: 'UNKNOWN_ERROR', kind: 'PERMANENT' };
}

// ============================================
// Filesystem Hooks
// ============================================

/**
 * Hook to list directory contents
 */
export function useListDirectory(path) {
    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    const refresh = useCallback(async () => {
        setLoading(true);
        setError(null);
        try {
            const result = await invoke('list_directory', {
                request: { path }
            });
            setData(result);
        } catch (e) {
            console.warn('List directory error:', e);
            setError(parseTauriError(e));
        } finally {
            setLoading(false);
        }
    }, [path]);

    useEffect(() => {
        refresh();
    }, [refresh]);

    return { data, loading, error, refresh };
}

/**
 * Hook to get file info
 */
export function useFileInfo(path) {
    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        async function fetch() {
            setLoading(true);
            try {
                const result = await invoke('get_file_info', { path });
                setData(result);
            } catch (e) {
                setError(parseTauriError(e));
            } finally {
                setLoading(false);
            }
        }
        fetch();
    }, [path]);

    return { data, loading, error };
}

/**
 * Hook to get storage volumes
 */
export function useStorageVolumes() {
    const [volumes, setVolumes] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    const refresh = useCallback(async () => {
        setLoading(true);
        try {
            const result = await invoke('get_storage_volumes');
            setVolumes(result);
        } catch (e) {
            setError(parseTauriError(e));
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        refresh();
    }, [refresh]);

    return { volumes, loading, error, refresh };
}

// ============================================
// Filesystem Actions
// ============================================

export async function createFolder(path, name) {
    try {
        return await invoke('create_folder', { path, name });
    } catch (e) {
        throw parseTauriError(e);
    }
}

export async function deleteItems(paths) {
    try {
        return await invoke('delete_items', { paths });
    } catch (e) {
        throw parseTauriError(e);
    }
}

export async function renameItem(path, newName) {
    try {
        return await invoke('rename_item', { path, newName });
    } catch (e) {
        throw parseTauriError(e);
    }
}

// ============================================
// Device Discovery Hooks
// ============================================

/**
 * Hook for device discovery
 */
export function useDeviceDiscovery() {
    const [devices, setDevices] = useState([]);
    const [isScanning, setIsScanning] = useState(false);
    const [error, setError] = useState(null);

    const startDiscovery = useCallback(async () => {
        setIsScanning(true);
        setError(null);
        try {
            await invoke('start_discovery');
        } catch (e) {
            setError(String(e));
            setIsScanning(false);
        }
    }, []);

    const stopDiscovery = useCallback(async () => {
        try {
            await invoke('stop_discovery');
        } catch (e) {
            setError(String(e));
        } finally {
            setIsScanning(false);
        }
    }, []);

    const refreshDevices = useCallback(async () => {
        try {
            const result = await invoke('get_discovered_devices');
            setDevices(result);
        } catch (e) {
            setError(String(e));
        }
    }, []);

    // Subscribe to device events
    useEffect(() => {
        const unlistenDiscovered = listen('device_discovered', (event) => {
            setDevices(prev => {
                const exists = prev.some(d => d.identity.id === event.payload.identity.id);
                if (exists) {
                    return prev.map(d =>
                        d.identity.id === event.payload.identity.id ? event.payload : d
                    );
                }
                return [...prev, event.payload];
            });
        });

        const unlistenLost = listen('device_lost', (event) => {
            setDevices(prev => prev.filter(d => d.identity.id !== event.payload.deviceId));
        });

        return () => {
            unlistenDiscovered.then(fn => fn());
            unlistenLost.then(fn => fn());
        };
    }, []);

    return {
        devices,
        isScanning,
        error,
        startDiscovery,
        stopDiscovery,
        refreshDevices
    };
}

// ============================================
// Connection Hooks
// ============================================

/**
 * Hook for connection state
 */
export function useConnection() {
    const [state, setState] = useState({
        status: 'disconnected',
        deviceId: null,
        deviceName: null,
    });
    const [error, setError] = useState(null);

    const connect = useCallback(async (device) => {
        setState(prev => ({ ...prev, status: 'connecting' }));
        try {
            await invoke('connect', { device, sessionToken: '' });
            setState({
                status: 'connected',
                deviceId: device.id,
                deviceName: device.name,
            });
        } catch (e) {
            setError(String(e));
            setState(prev => ({ ...prev, status: 'failed' }));
        }
    }, []);

    const disconnect = useCallback(async () => {
        try {
            await invoke('disconnect');
            setState({
                status: 'disconnected',
                deviceId: null,
                deviceName: null,
            });
        } catch (e) {
            setError(String(e));
        }
    }, []);

    // Subscribe to connection events
    useEffect(() => {
        const unlistenStateChange = listen('connection_state_changed', (event) => {
            setState(event.payload);
        });

        return () => {
            unlistenStateChange.then(fn => fn());
        };
    }, []);

    return { state, error, connect, disconnect };
}

// ============================================
// Transfer Hooks
// ============================================

/**
 * Hook for transfer progress
 */
export function useTransferProgress() {
    const [transfers, setTransfers] = useState(new Map());

    useEffect(() => {
        const unlisten = listen('transfer_progress', (event) => {
            setTransfers(prev => {
                const next = new Map(prev);
                next.set(event.payload.transferId, event.payload);
                return next;
            });
        });

        const unlistenComplete = listen('transfer_completed', (event) => {
            setTransfers(prev => {
                const next = new Map(prev);
                next.delete(event.payload.transferId);
                return next;
            });
        });

        const unlistenFailed = listen('transfer_failed', (event) => {
            console.error(`Transfer ${event.payload.transferId} failed: ${event.payload.error}`);
        });

        return () => {
            unlisten.then(fn => fn());
            unlistenComplete.then(fn => fn());
            unlistenFailed.then(fn => fn());
        };
    }, []);

    return { transfers: Array.from(transfers.values()) };
}

/**
 * Start a download
 */
export async function startDownload(transferId, url, destination) {
    await invoke('start_download_stream', {
        request: {
            streamUrl: url,
            streamOffset: 0,
            expectedSize: null,
            operationId: transferId,
        },
        destination: {
            localPath: destination,
            canResume: false,
            existingBytes: 0,
        }
    });
}

/**
 * Pause a transfer
 */
export async function pauseTransfer(transferId) {
    await invoke('pause_stream', { transferId });
}

/**
 * Resume a transfer
 */
export async function resumeTransfer(transferId) {
    await invoke('resume_stream', { transferId, fromOffset: 0 });
}

/**
 * Cancel a transfer
 */
export async function cancelTransfer(transferId) {
    await invoke('cancel_stream', { transferId });
}

// ============================================
// Event Subscription Utility
// ============================================

/**
 * Generic hook for subscribing to Tauri events
 */
export function useTauriEvent(eventName, handler) {
    useEffect(() => {
        const unlisten = listen(eventName, (event) => {
            handler(event.payload);
        });

        return () => {
            unlisten.then(fn => fn());
        };
    }, [eventName, handler]);
}

// ============================================
// UI Event Hook (from State Machine Actions)
// ============================================

/**
 * Hook to receive UI events from state machine
 */
export function useUiEvents(onEvent) {
    const [lastEvent, setLastEvent] = useState(null);

    useEffect(() => {
        const unlisten = listen('emit_ui_event', (event) => {
            setLastEvent(event.payload);
            if (onEvent) {
                onEvent(event.payload);
            }
        });

        return () => {
            unlisten.then(fn => fn());
        };
    }, [onEvent]);

    return { lastEvent };
}
