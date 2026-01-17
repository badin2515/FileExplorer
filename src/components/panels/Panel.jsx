import React, { useState, useMemo, useEffect } from 'react';
import { ChevronRight, Search, Grid, List, RefreshCw, Loader2 } from 'lucide-react';
import { FileArea } from '../files';
import { useListDirectory } from '../../hooks/useTauri';

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

    // Handlers
    const handleNavigate = (path) => {
        if (path === currentPath) return;
        setCurrentPath(path);
        setSelectedIds(new Set());
        // Notify parent of path change
        if (onPathChange) {
            onPathChange(path);
        }
    };

    const handleSelect = (id, multi) => {
        const newSet = new Set(multi ? selectedIds : []);
        if (newSet.has(id)) newSet.delete(id);
        else newSet.add(id);
        setSelectedIds(newSet);
    };

    const handleItemClick = (item) => {
        if (item.type === 'folder') {
            handleNavigate(item.id);
        }
    };

    const handleGoUp = () => {
        const parts = currentPath.split(/[\\\/]/).filter(Boolean);
        if (parts.length > 1) {
            parts.pop();
            handleNavigate(parts.join('\\'));
        }
    };

    return (
        <div
            className="flex-1 flex flex-col min-w-0 overflow-hidden"
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
                        disabled={loading}
                    >
                        <RefreshCw size={14} className={loading ? 'animate-spin' : ''} />
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
                        {loading ? '...' : `${folderCount + fileCount} items`}
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
                    <div className="flex flex-col items-center gap-3 text-center px-4">
                        <div className="w-12 h-12 rounded-full bg-red-100 flex items-center justify-center">
                            <span className="text-red-500 text-xl">!</span>
                        </div>
                        <div>
                            <p className="text-sm font-medium text-[#2d2a26]">Error loading directory</p>
                            <p className="text-xs text-[#7a756e] mt-1 max-w-xs">{error}</p>
                        </div>
                        <button
                            onClick={refresh}
                            className="px-3 py-1.5 bg-[#d97352] text-white rounded-lg text-xs hover:bg-[#c66447] transition-colors"
                        >
                            Try Again
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
                />
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
