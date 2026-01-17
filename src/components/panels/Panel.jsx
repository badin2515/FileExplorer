import React, { useState, useMemo, useEffect } from 'react';
import { ChevronRight, Search, Grid, List, RefreshCw, Loader2, Copy, Trash2, Edit, Scissors, Play, Folder } from 'lucide-react';
import { FileArea } from '../files';
import { useListDirectory, createFolder, deleteItems, renameItem } from '../../hooks/useTauri';
import { useClipboard } from '../../contexts/ClipboardContext';
import ContextMenu from '../menus/ContextMenu';
import { DialogModal } from '../modals';
import { invoke } from '@tauri-apps/api/core';

/**
 * Panel Component (Tauri Integrated)
 * 
 * Step A: UI ↔ core ↔ state machine ↔ timeline ต่อครบเป็นวง
 * 
 * - ใช้ invoke("list_directory") แทน mock data
 * - Subscribe events จาก Tauri
 */
const Panel = ({
    panelId,
    isActive,
    onActivate,
    showBorder = false,
    sourcePath = null,
    onPathChange = null // Callback เมื่อ path เปลี่ยน
}) => {
    // Panel-specific state
    const [currentPath, setCurrentPath] = useState(sourcePath || 'C:\\Users');
    const [selectedIds, setSelectedIds] = useState(new Set());
    const [searchQuery, setSearchQuery] = useState('');
    const [viewMode, setViewMode] = useState('list');
    const [breadcrumbs, setBreadcrumbs] = useState([]);

    // Sync with parent's sourcePath
    useEffect(() => {
        if (sourcePath && sourcePath !== currentPath) {
            setCurrentPath(sourcePath);
            setSelectedIds(new Set());
        }
    }, [sourcePath]);

    // Use Tauri hook to list directory
    const { data, loading, error, refresh } = useListDirectory(currentPath);

    // Convert Tauri FileInfo to UI format
    const items = useMemo(() => {
        if (!data?.items) return [];
        return data.items.map(item => ({
            id: item.path,
            name: item.name,
            type: item.type === 'folder' ? 'folder' : 'file',
            size: item.type === 'folder' ? null : formatSize(item.size),
            modified: item.modified,
            extension: item.extension
        }));
    }, [data]);

    // Filter by search
    const filteredItems = useMemo(() => {
        if (!searchQuery.trim()) return items;
        return items.filter(item =>
            item.name.toLowerCase().includes(searchQuery.toLowerCase())
        );
    }, [items, searchQuery]);

    // Update breadcrumbs when path changes
    useEffect(() => {
        if (!currentPath) return;

        // Parse path to breadcrumbs
        const parts = currentPath.split(/[\\\/]/).filter(Boolean);
        const crumbs = [];
        let buildPath = '';

        for (const part of parts) {
            buildPath += (buildPath ? '\\' : '') + part;
            crumbs.push({
                id: buildPath,
                name: part
            });
        }

        setBreadcrumbs(crumbs);
    }, [currentPath]);

    const folderCount = filteredItems.filter(i => i.type === 'folder').length;
    const fileCount = filteredItems.filter(i => i.type === 'file').length;

    const [lastSelectedId, setLastSelectedId] = useState(null);

    // Handlers
    const handleNavigate = (path) => {
        if (path === currentPath) return;
        setCurrentPath(path);
        setSelectedIds(new Set());
        setLastSelectedId(null);
        // Notify parent of path change
        if (onPathChange) {
            onPathChange(path);
        }
    };

    const handleSelect = (id, multi, range) => {
        let newSet;

        if (range && lastSelectedId) {
            // Range Selection (Shift + Click)
            const lastIndex = filteredItems.findIndex(i => i.id === lastSelectedId);
            const currentIndex = filteredItems.findIndex(i => i.id === id);

            if (lastIndex !== -1 && currentIndex !== -1) {
                const start = Math.min(lastIndex, currentIndex);
                const end = Math.max(lastIndex, currentIndex);

                // Create selection from range
                // Note: Standard Shift+Click usually replaces selection with the range
                // unless Ctrl is also held. Here for simplicity, we'll replace selection with the range.
                // If you want "Add to selection", use: newSet = new Set(selectedIds);
                newSet = new Set();

                for (let i = start; i <= end; i++) {
                    newSet.add(filteredItems[i].id);
                }
            } else {
                newSet = new Set([id]);
                setLastSelectedId(id);
            }
        } else if (multi) {
            // Multi Selection (Ctrl/Cmd + Click)
            newSet = new Set(selectedIds);
            if (newSet.has(id)) {
                newSet.delete(id);
                // If we deselect the anchor, we should probably update anchor to null or keep it?
                // Often we keep it until a new active selection is made.
            } else {
                newSet.add(id);
                setLastSelectedId(id);
            }
        } else {
            // Single Selection
            newSet = new Set([id]);
            setLastSelectedId(id);
        }

        setSelectedIds(newSet);
    };

    const handleItemClick = (item) => {
        if (item.type === 'folder') {
            handleNavigate(item.id);
        }
    };

    // Clipboard & Context Menu
    const [contextMenu, setContextMenu] = useState(null);
    const { clipboard, copyItems, cutItems } = useClipboard();

    const handleContextMenu = (e, targetItem) => {
        // If clicking on an empty area, targetItem is null
        // If clicking on an item that is NOT selected, select it exclusively
        if (targetItem && !selectedIds.has(targetItem.id)) {
            setSelectedIds(new Set([targetItem.id]));
        }
        setContextMenu({
            position: { x: e.clientX, y: e.clientY },
            item: targetItem
        });
    };

    // Dialog State
    const [dialog, setDialog] = useState({ isOpen: false });
    const [isOperating, setIsOperating] = useState(false);

    // Helper to wrap async operations with loading state
    const runOperation = async (fn) => {
        setIsOperating(true);
        try {
            await fn();
        } finally {
            setIsOperating(false);
        }
    };

    // Actions
    const getActionTargets = () => {
        // If context menu triggered on an item
        if (contextMenu?.item) {
            // If the item is in the selection, act on the entire selection
            if (selectedIds.has(contextMenu.item.id)) {
                return items.filter(i => selectedIds.has(i.id));
            }
            // Otherwise act only on that item
            return [contextMenu.item];
        }
        // Otherwise use selection
        return items.filter(i => selectedIds.has(i.id));
    };

    const performCopy = () => {
        const targets = getActionTargets();
        if (targets.length > 0) copyItems(targets);
    };

    const performCut = () => {
        const targets = getActionTargets();
        if (targets.length > 0) cutItems(targets);
    };

    const performDelete = () => {
        const targets = getActionTargets().map(i => i.id);

        if (targets.length > 0) {
            setDialog({
                isOpen: true,
                type: 'confirm',
                title: 'Delete Items',
                message: `Are you sure you want to delete ${targets.length} item(s)? This action cannot be undone.`,
                confirmLabel: 'Delete',
                danger: true,
                onConfirm: () => runOperation(async () => {
                    try {
                        await deleteItems(targets);
                        refresh();
                        setSelectedIds(new Set());
                    } catch (e) {
                        setDialog({
                            isOpen: true,
                            type: 'info',
                            title: 'Error',
                            message: `Failed to delete: ${e.message}`,
                            confirmLabel: 'OK',
                            onConfirm: () => { }
                        });
                    }
                })
            });
        }
    };

    const performRename = () => {
        const target = contextMenu?.item || (selectedIds.size === 1 ? items.find(i => i.id === Array.from(selectedIds)[0]) : null);
        if (!target) return;

        setDialog({
            isOpen: true,
            type: 'input',
            title: 'Rename Item',
            message: `Enter new name for "${target.name}":`,
            initialValue: target.name,
            confirmLabel: 'Rename',
            onConfirm: (newName) => runOperation(async () => {
                if (newName && newName !== target.name) {
                    try {
                        await renameItem(target.id, newName);
                        refresh();
                    } catch (e) {
                        setDialog({
                            isOpen: true,
                            type: 'info',
                            title: 'Error',
                            message: `Rename failed: ${e.message}`,
                            confirmLabel: 'Close',
                            onConfirm: () => { }
                        });
                    }
                }
            })
        });
    };

    const performNewFolder = () => {
        setDialog({
            isOpen: true,
            type: 'input',
            title: 'New Folder',
            message: 'Enter folder name:',
            initialValue: 'New Folder',
            confirmLabel: 'Create',
            onConfirm: (name) => runOperation(async () => {
                if (name) {
                    try {
                        await createFolder(currentPath, name);
                        refresh();
                    } catch (e) {
                        setDialog({
                            isOpen: true,
                            type: 'info',
                            title: 'Error',
                            message: `Create folder failed: ${e.message}`,
                            confirmLabel: 'Close',
                            onConfirm: () => { }
                        });
                    }
                }
            })
        });
    };

    const performPaste = async () => {
        if (!clipboard || !clipboard.items.length) return;

        runOperation(async () => {
            try {
                const sourcePaths = clipboard.items.map(i => i.id);
                if (clipboard.mode === 'copy') {
                    await invoke('copy_items', { sourcePaths, targetFolder: currentPath });
                } else {
                    await invoke('move_items', { sourcePaths, targetFolder: currentPath });
                    if (clipboard.mode === 'cut') {
                        // Ideally clear clipboard or update UI
                    }
                }
                refresh();
            } catch (e) {
                setDialog({
                    isOpen: true,
                    type: 'info',
                    title: 'Paste Failed',
                    message: e.message || String(e),
                    confirmLabel: 'OK',
                    onConfirm: () => { }
                });
            }
        });
    };

    // Keyboard Shortcuts
    useEffect(() => {
        if (!isActive || dialog.isOpen || isOperating) return; // Disable shortcuts while operating

        const handleKeyDown = (e) => {
            // Shortcuts usually involve Ctrl/Cmd
            if (e.ctrlKey || e.metaKey) {
                switch (e.key.toLowerCase()) {
                    case 'c':
                        e.preventDefault();
                        performCopy();
                        break;
                    case 'x':
                        e.preventDefault();
                        performCut();
                        break;
                    case 'v':
                        e.preventDefault();
                        performPaste();
                        break;
                    case 'a':
                        e.preventDefault();
                        // Select all logic
                        if (items.length) {
                            setSelectedIds(new Set(items.map(i => i.id)));
                        }
                        break;
                }
            } else {
                // Navigation / Actions
                if (e.key === 'Delete') {
                    performDelete();
                } else if (e.key === 'F2') {
                    performRename();
                } else if (e.key === 'Backspace') {
                    handleGoUp();
                } else if (e.key === 'Enter') {
                    // Open selected item
                    const selected = items.find(i => selectedIds.has(i.id));
                    if (selected) handleItemClick(selected);
                }
                // Arrow keys are handled natively by focus, but for custom selection 
                // we might need more logic. For now let's rely on click.
            }
        };

        window.addEventListener('keydown', handleKeyDown);
        return () => window.removeEventListener('keydown', handleKeyDown);
    }, [isActive, dialog.isOpen, isOperating, selectedIds, items, clipboard, currentPath]);

    const menuItems = useMemo(() => {
        const hasSelection = contextMenu?.item || selectedIds.size > 0;
        const canPaste = clipboard && clipboard.items.length > 0;

        // Background Menu
        if (!hasSelection && !contextMenu?.item) {
            return [
                { label: 'Refresh', icon: RefreshCw, onClick: refresh },
                { separator: true },
                { label: 'Paste', icon: Scissors, disabled: !canPaste, onClick: performPaste },
                { separator: true },
                { label: 'New Folder', icon: Folder, onClick: performNewFolder },
            ];
        }

        // Item Menu
        return [
            { label: 'Open', icon: Play, onClick: () => contextMenu?.item && handleItemClick(contextMenu.item), disabled: !contextMenu?.item }, // TODO: Open Logic
            { separator: true },
            { label: 'Copy', icon: Copy, shortcut: 'Ctrl+C', onClick: performCopy },
            { label: 'Cut', icon: Scissors, shortcut: 'Ctrl+X', onClick: performCut },
            { label: 'Paste', icon: Scissors, disabled: !canPaste, onClick: performPaste }, // Paste into folder if folder selected? usually paste in current dir
            { separator: true },
            { label: 'Rename', icon: Edit, onClick: performRename },
            { label: 'Delete', icon: Trash2, shortcut: 'Del', onClick: performDelete, danger: true },
        ];
    }, [contextMenu, selectedIds, clipboard, refresh, currentPath]); // Dependencies

    const handleGoUp = () => {
        const parts = currentPath.split(/[\\\/]/).filter(Boolean);
        if (parts.length > 1) {
            parts.pop();
            handleNavigate(parts.join('\\'));
        }
    };

    return (
        <div
            className="flex-1 flex flex-col min-w-0 overflow-hidden relative" // Added relative for overlay
            style={{
                backgroundColor: 'var(--bg-secondary)',
                borderLeft: showBorder ? '1px solid var(--border-color)' : 'none',
                boxShadow: isActive ? 'inset 0 0 0 2px var(--accent-light)' : 'none',
            }}
            onClick={onActivate}
        >
            {/* Panel Header */}
            <header
                className="h-14 px-4 flex items-center justify-between"
                style={{
                    backgroundColor: 'var(--bg-secondary)',
                    borderBottom: '1px solid var(--border-color)'
                }}
            >
                {/* Breadcrumbs */}
                <nav className="flex items-center min-w-0 flex-1 overflow-x-auto">
                    {breadcrumbs.map((item, index) => (
                        <div key={item.id} className="flex items-center min-w-0 flex-shrink-0">
                            {index > 0 && (
                                <ChevronRight size={14} className="mx-1 flex-shrink-0" style={{ color: 'var(--text-faint)' }} />
                            )}
                            <button
                                onClick={(e) => {
                                    e.stopPropagation();
                                    handleNavigate(item.id);
                                }}
                                className="px-2 py-1 rounded-lg transition-all duration-200 text-xs truncate max-w-[120px]"
                                style={{
                                    backgroundColor: index === breadcrumbs.length - 1 ? 'var(--bg-tertiary)' : 'transparent',
                                    color: index === breadcrumbs.length - 1 ? 'var(--text-primary)' : 'var(--text-tertiary)',
                                    fontWeight: index === breadcrumbs.length - 1 ? 600 : 400,
                                }}
                                onMouseOver={(e) => {
                                    if (index !== breadcrumbs.length - 1) {
                                        e.currentTarget.style.backgroundColor = 'var(--bg-hover)';
                                        e.currentTarget.style.color = 'var(--text-primary)';
                                    }
                                }}
                                onMouseOut={(e) => {
                                    if (index !== breadcrumbs.length - 1) {
                                        e.currentTarget.style.backgroundColor = 'transparent';
                                        e.currentTarget.style.color = 'var(--text-tertiary)';
                                    }
                                }}
                                title={item.id}
                            >
                                {item.name}
                            </button>
                        </div>
                    ))}
                </nav>

                {/* Actions */}
                <div className="flex items-center gap-1 ml-2">
                    {/* Refresh Button */}
                    <button
                        onClick={(e) => { e.stopPropagation(); refresh(); }}
                        className="p-1.5 rounded-md transition-all"
                        style={{ color: 'var(--text-muted)' }}
                        disabled={loading || isOperating}
                    >
                        <RefreshCw size={14} className={loading || isOperating ? 'animate-spin' : ''} />
                    </button>

                    {/* View Toggle */}
                    <div className="flex rounded-lg p-0.5" style={{ backgroundColor: 'var(--bg-tertiary)' }}>
                        <button
                            onClick={(e) => { e.stopPropagation(); setViewMode('list'); }}
                            className="p-1.5 rounded-md transition-all"
                            style={{
                                backgroundColor: viewMode === 'list' ? 'var(--bg-secondary)' : 'transparent',
                                color: viewMode === 'list' ? 'var(--accent-primary)' : 'var(--text-muted)',
                                boxShadow: viewMode === 'list' ? '0 1px 2px var(--shadow-color)' : 'none',
                            }}
                        >
                            <List size={14} />
                        </button>
                        <button
                            onClick={(e) => { e.stopPropagation(); setViewMode('grid'); }}
                            className="p-1.5 rounded-md transition-all"
                            style={{
                                backgroundColor: viewMode === 'grid' ? 'var(--bg-secondary)' : 'transparent',
                                color: viewMode === 'grid' ? 'var(--accent-primary)' : 'var(--text-muted)',
                                boxShadow: viewMode === 'grid' ? '0 1px 2px var(--shadow-color)' : 'none',
                            }}
                        >
                            <Grid size={14} />
                        </button>
                    </div>
                </div>
            </header>

            {/* Panel Toolbar */}
            <div
                className="px-4 py-2 flex items-center justify-between gap-4"
                style={{
                    backgroundColor: 'var(--bg-tertiary)',
                    borderBottom: '1px solid var(--border-color)'
                }}
            >
                <div className="flex items-center gap-3 min-w-0 flex-1">
                    <h3
                        className="text-sm font-bold truncate"
                        style={{ color: 'var(--text-primary)' }}
                        title={breadcrumbs[breadcrumbs.length - 1]?.name || 'Files'}
                    >
                        {breadcrumbs[breadcrumbs.length - 1]?.name || 'Files'}
                    </h3>
                    <span
                        className="px-2 py-0.5 rounded-full text-[10px] font-medium flex-shrink-0 whitespace-nowrap"
                        style={{ backgroundColor: 'var(--bg-hover)', color: 'var(--text-tertiary)' }}
                    >
                        {loading || isOperating ? 'Working...' : `${folderCount + fileCount} items`}
                    </span>
                </div>

                {/* Search */}
                <div className="relative">
                    <Search size={12} className="absolute left-2 top-1/2 -translate-y-1/2" style={{ color: 'var(--text-faint)' }} />
                    <input
                        type="text"
                        placeholder="Search..."
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                        onClick={(e) => e.stopPropagation()}
                        className="pl-7 pr-3 py-1.5 rounded-lg text-xs w-36 focus:outline-none transition-all duration-200"
                        style={{
                            backgroundColor: 'var(--bg-secondary)',
                            border: '1px solid var(--border-color)',
                            color: 'var(--text-primary)',
                        }}
                    />
                </div>
            </div>

            {/* Content Area */}
            {loading ? (
                <div className="flex-1 flex items-center justify-center">
                    <div className="flex flex-col items-center gap-3 text-[#9a958e]">
                        <Loader2 size={32} className="animate-spin text-[#d97352]" />
                        <span className="text-sm">Loading...</span>
                    </div>
                </div>
            ) : error ? (
                <div className="flex-1 flex items-center justify-center">
                    <div className="flex flex-col items-center gap-4 text-center px-6 py-8 rounded-xl bg-opacity-50" style={{ backgroundColor: 'var(--bg-tertiary)' }}>
                        <div
                            className="w-16 h-16 rounded-full flex items-center justify-center mb-2"
                            style={{
                                backgroundColor: error.kind === 'PERMISSION' ? '#fff7ed' :
                                    error.kind === 'NOT_FOUND' ? '#f3f4f6' : '#fee2e2',
                                color: error.kind === 'PERMISSION' ? '#c2410c' :
                                    error.kind === 'NOT_FOUND' ? '#4b5563' : '#dc2626'
                            }}
                        >
                            {error.kind === 'PERMISSION' ? (
                                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                            ) : error.kind === 'NOT_FOUND' ? (
                                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                            ) : (
                                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                            )}
                        </div>
                        <div>
                            <h3 className="text-base font-semibold mb-1" style={{ color: 'var(--text-primary)' }}>
                                {error.code === 'PERMISSION_DENIED' ? 'Access Denied' :
                                    error.code === 'NOT_FOUND' ? 'Folder Not Found' :
                                        'Something went wrong'}
                            </h3>
                            <p className="text-sm opacity-80 max-w-xs mx-auto break-words" style={{ color: 'var(--text-secondary)' }}>
                                {error.message || String(error)}
                            </p>
                        </div>
                        <button
                            onClick={refresh}
                            className="px-4 py-2 rounded-lg text-sm font-medium transition-colors mt-2"
                            style={{ backgroundColor: 'var(--accent-primary)', color: '#ffffff' }}
                        >
                            {error.kind === 'TRANSIENT' ? 'Retry Now' : 'Refresh'}
                        </button>
                    </div>
                </div>
            ) : (
                <FileArea
                    items={filteredItems}
                    viewMode={viewMode}
                    selectedIds={selectedIds}
                    searchQuery={searchQuery}
                    currentPath={currentPath}
                    onSelect={handleSelect}
                    onNavigate={handleItemClick}
                    onClearSelection={() => setSelectedIds(new Set())}
                    onContextMenu={handleContextMenu}
                />
            )}
            {/* Context Menu */}
            {contextMenu && (
                <ContextMenu
                    position={contextMenu.position}
                    items={menuItems}
                    onClose={() => setContextMenu(null)}
                />
            )}
            {/* Dialog Modal */}
            <DialogModal
                isOpen={dialog.isOpen}
                onClose={() => setDialog({ ...dialog, isOpen: false })}
                {...dialog}
            />

            {/* Operation Overlay */}
            {isOperating && (
                <div className="absolute inset-0 z-40 bg-white/50 dark:bg-black/50 backdrop-blur-[1px] flex flex-col items-center justify-center pointer-events-none">
                    <div className="bg-white dark:bg-gray-800 p-4 rounded-xl shadow-2xl flex flex-col items-center gap-3">
                        <Loader2 size={32} className="animate-spin text-[var(--accent-primary)]" />
                        <span className="text-sm font-medium">Processing...</span>
                    </div>
                </div>
            )}
        </div>
    );
};

// Helper function
function formatSize(bytes) {
    if (bytes === 0 || bytes === null) return '-';
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    const i = Math.floor(Math.log(bytes) / Math.log(1024));
    return `${(bytes / Math.pow(1024, i)).toFixed(1)} ${units[i]}`;
}

export default Panel;
