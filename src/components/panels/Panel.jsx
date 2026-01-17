import React, { useState, useMemo, useEffect } from 'react';
import { motion } from 'framer-motion';
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
    sourcePath = null // ถ้าเป็น null = local, ถ้าไม่ = remote device
}) => {
    // Panel-specific state
    const [currentPath, setCurrentPath] = useState(
        sourcePath || (typeof window !== 'undefined' && window.__TAURI__
            ? 'C:\\Users'
            : 'root')
    );
    const [selectedIds, setSelectedIds] = useState(new Set());
    const [searchQuery, setSearchQuery] = useState('');
    const [viewMode, setViewMode] = useState('list');
    const [breadcrumbs, setBreadcrumbs] = useState([]);

    // Use Tauri hook to list directory
    const { data, loading, error, refresh } = useListDirectory(currentPath);

    // Check if running in Tauri
    const isTauri = typeof window !== 'undefined' && window.__TAURI__;

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
        <motion.div
            layout
            initial={{ opacity: 0, scale: 0.95, x: panelId === 'right' ? 50 : 0 }}
            animate={{ opacity: 1, scale: 1, x: 0 }}
            exit={{ opacity: 0, scale: 0.95, x: 50 }}
            transition={{
                type: "spring",
                stiffness: 300,
                damping: 30,
                opacity: { duration: 0.2 }
            }}
            className={`
                flex-1 flex flex-col min-w-0 overflow-hidden bg-white
                ${showBorder ? 'border-l border-[#eae6e0]' : ''}
                ${isActive ? 'ring-2 ring-[#d97352]/30 ring-inset' : ''}
            `}
            onClick={onActivate}
        >
            {/* Panel Header */}
            <header className="h-14 px-4 bg-white border-b border-[#eae6e0] flex items-center justify-between">
                {/* Breadcrumbs */}
                <nav className="flex items-center min-w-0 flex-1 overflow-x-auto">
                    {breadcrumbs.map((item, index) => (
                        <div key={item.id} className="flex items-center min-w-0 flex-shrink-0">
                            {index > 0 && (
                                <ChevronRight size={14} className="mx-1 text-[#c4bfb6] flex-shrink-0" />
                            )}
                            <button
                                onClick={(e) => {
                                    e.stopPropagation();
                                    handleNavigate(item.id);
                                }}
                                className={`px-2 py-1 rounded-lg transition-all duration-200 text-xs truncate max-w-[120px]
                                    ${index === breadcrumbs.length - 1
                                        ? 'text-[#2d2a26] font-semibold bg-[#f5f3f0]'
                                        : 'text-[#7a756e] hover:text-[#2d2a26] hover:bg-[#f5f3f0]'
                                    }
                                `}
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
                        className="p-1.5 rounded-md text-[#9a958e] hover:text-[#d97352] hover:bg-[#f5f3f0] transition-all"
                        disabled={loading}
                    >
                        <RefreshCw size={14} className={loading ? 'animate-spin' : ''} />
                    </button>

                    {/* View Toggle */}
                    <div className="flex bg-[#f5f3f0] rounded-lg p-0.5">
                        <button
                            onClick={(e) => { e.stopPropagation(); setViewMode('list'); }}
                            className={`p-1.5 rounded-md transition-all ${viewMode === 'list' ? 'bg-white shadow-sm text-[#d97352]' : 'text-[#9a958e]'}`}
                        >
                            <List size={14} />
                        </button>
                        <button
                            onClick={(e) => { e.stopPropagation(); setViewMode('grid'); }}
                            className={`p-1.5 rounded-md transition-all ${viewMode === 'grid' ? 'bg-white shadow-sm text-[#d97352]' : 'text-[#9a958e]'}`}
                        >
                            <Grid size={14} />
                        </button>
                    </div>
                </div>
            </header>

            {/* Panel Toolbar */}
            <div className="px-4 py-2 bg-[#faf8f5] border-b border-[#eae6e0] flex items-center justify-between">
                <div className="flex items-center gap-3">
                    <h3 className="text-sm font-bold text-[#2d2a26]">
                        {breadcrumbs[breadcrumbs.length - 1]?.name || 'Files'}
                    </h3>
                    <span className="px-2 py-0.5 bg-[#eae6e0] rounded-full text-[10px] font-medium text-[#7a756e]">
                        {loading ? '...' : `${folderCount + fileCount} items`}
                    </span>
                    {sourcePath && (
                        <span className="px-2 py-0.5 bg-[#d97352]/10 text-[#d97352] rounded-full text-[10px] font-medium">
                            Remote
                        </span>
                    )}
                </div>

                {/* Search */}
                <div className="relative">
                    <Search size={12} className="absolute left-2 top-1/2 -translate-y-1/2 text-[#b5b0a8]" />
                    <input
                        type="text"
                        placeholder="Search..."
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                        onClick={(e) => e.stopPropagation()}
                        className="pl-7 pr-3 py-1.5 bg-white border border-[#eae6e0] rounded-lg text-xs w-36
                            focus:outline-none focus:border-[#d97352]
                            transition-all duration-200 placeholder:text-[#b5b0a8]"
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
        </motion.div>
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
