import React, { useState } from 'react';
import { MoreHorizontal } from 'lucide-react';
import FileIcon from './FileIcon';

/**
 * FileRow Component
 * Traditional list row - optimized for mouse + keyboard + drag/drop
 */

// Helper to format date
const formatDate = (item) => {
    const val = item.date || item.modified || item.created || item.lastModified || item.createdAt;
    if (!val) return '--';

    try {
        const date = new Date(val);
        if (isNaN(date.getTime())) return String(val);

        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');

        return `${day}/${month}/${year} ${hours}:${minutes}`;
    } catch (e) {
        return String(val);
    }
};

const FileRow = ({
    item,
    index,
    selected,
    isCut,
    onSelect,
    onNavigate,
    onContextMenu,
    onDragStart,  // (items: array) => void
    onDrop,       // (targetPath: string, ctrlKey: boolean) => void
    isDragging    // boolean - global drag state
}) => {
    const [isDragOver, setIsDragOver] = useState(false);
    const isFolder = item.type === 'folder';

    // Drag handlers
    const handleDragStart = (e) => {
        e.stopPropagation();
        // Set drag data (for cross-browser compatibility)
        e.dataTransfer.setData('text/plain', item.id);
        e.dataTransfer.effectAllowed = 'copyMove';

        // Notify parent to start drag with this item (or selection if selected)
        if (onDragStart) {
            onDragStart(item, selected);
        }
    };

    const handleDragEnd = (e) => {
        e.stopPropagation();
        setIsDragOver(false);
    };

    // Drop handlers (only for folders)
    const handleDragOver = (e) => {
        if (!isFolder) return;
        e.preventDefault();
        e.stopPropagation();
        e.dataTransfer.dropEffect = e.ctrlKey ? 'copy' : 'move';
        setIsDragOver(true);
    };

    const handleDragLeave = (e) => {
        e.stopPropagation();
        setIsDragOver(false);
    };

    const handleDrop = (e) => {
        if (!isFolder) return;
        e.preventDefault();
        e.stopPropagation();
        setIsDragOver(false);

        // Notify parent to perform drop into this folder
        if (onDrop) {
            onDrop(item.id, e.ctrlKey);
        }
    };

    return (
        <div
            draggable
            onDragStart={handleDragStart}
            onDragEnd={handleDragEnd}
            onDragOver={handleDragOver}
            onDragLeave={handleDragLeave}
            onDrop={handleDrop}
            onClick={(e) => {
                e.stopPropagation();
                onSelect(item.id, e.metaKey || e.ctrlKey, e.shiftKey);
            }}
            onDoubleClick={() => onNavigate(item)}
            onContextMenu={(e) => {
                e.preventDefault();
                e.stopPropagation();
                if (!selected) {
                    onSelect(item.id, false);
                }
                if (onContextMenu) onContextMenu(e, item);
            }}
            className={`
                group flex items-center px-3 py-1.5 cursor-pointer select-none border-b transition-all duration-150
                ${isCut ? 'opacity-50' : ''}
                ${isDragOver && isFolder ? 'ring-2 ring-[var(--accent-primary)] bg-[var(--accent-light)]' : ''}
            `}
            style={{
                backgroundColor: isDragOver && isFolder
                    ? 'var(--accent-light)'
                    : selected
                        ? 'var(--accent-light)'
                        : 'transparent',
                borderBottomColor: 'var(--border-light)',
            }}
            onMouseOver={(e) => {
                if (!selected && !isDragOver) {
                    e.currentTarget.style.backgroundColor = 'var(--bg-hover)';
                }
            }}
            onMouseOut={(e) => {
                if (!selected && !isDragOver) {
                    e.currentTarget.style.backgroundColor = 'transparent';
                }
            }}
        >
            {/* Name */}
            <div className="flex items-center gap-2 min-w-0" style={{ flex: 1, minWidth: 200 }}>
                <FileIcon type={item.type} name={item.name} size={18} variant="simple" />
                <span
                    className="truncate text-sm"
                    style={{ color: 'var(--text-primary)' }}
                >
                    {item.name}
                </span>
            </div>

            {/* Size */}
            <span
                className="text-xs text-right"
                style={{ width: 100, color: 'var(--text-tertiary)' }}
            >
                {item.size || (item.type === 'folder' && item.children ? `${item.children.length} items` : '--')}
            </span>

            {/* Date */}
            <span
                className="text-xs text-right pr-3"
                style={{ width: 150, color: 'var(--text-tertiary)' }}
            >
                {formatDate(item)}
            </span>
        </div>
    );
};

export default FileRow;
