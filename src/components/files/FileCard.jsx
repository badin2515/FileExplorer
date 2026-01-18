import React, { useState } from 'react';
import FileIcon from './FileIcon';

/**
 * FileCard Component
 * Compact icon view for grid mode - with drag/drop support
 */
const FileCard = ({
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
        e.dataTransfer.setData('text/plain', item.id);
        e.dataTransfer.effectAllowed = 'copyMove';

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
                flex flex-col items-center p-2 cursor-pointer select-none rounded transition-all duration-150
                ${isCut ? 'opacity-50' : ''}
                ${isDragOver && isFolder ? 'ring-2 ring-[var(--accent-primary)]' : ''}
            `}
            style={{
                backgroundColor: isDragOver && isFolder
                    ? 'var(--accent-light)'
                    : selected
                        ? 'var(--accent-light)'
                        : 'transparent',
                border: selected || (isDragOver && isFolder)
                    ? '1px solid var(--accent-primary)'
                    : '1px solid transparent',
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
            <FileIcon type={item.type} name={item.name} size={32} />
            <span
                className="text-xs truncate w-full text-center mt-1"
                style={{ color: 'var(--text-primary)' }}
            >
                {item.name}
            </span>
        </div>
    );
};

export default FileCard;
