import React from 'react'; // Added React import even if Vite handles it, for safety
import { MoreHorizontal } from 'lucide-react';
import FileIcon from './FileIcon';

/**
 * FileRow Component
 * Traditional list row - optimized for mouse + keyboard
 */
// Helper to format date
const formatDate = (item) => {
    // Try possible date fields
    const val = item.date || item.modified || item.created || item.lastModified || item.createdAt;

    if (!val) return '--';

    try {
        const date = new Date(val);
        // If invalid date
        if (isNaN(date.getTime())) return String(val);

        // Format: DD/MM/YYYY HH:mm
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

const FileRow = ({ item, index, selected, isCut, onSelect, onNavigate, onContextMenu }) => (
    <div
        onClick={(e) => {
            e.stopPropagation();
            onSelect(e.metaKey || e.ctrlKey, e.shiftKey);
        }}
        onDoubleClick={onNavigate}
        onContextMenu={(e) => {
            e.preventDefault();
            e.stopPropagation();
            // Select item if not already selected
            if (!selected) {
                onSelect(false);
            }
            if (onContextMenu) onContextMenu(e, item);
        }}
        className={`group flex items-center px-3 py-1.5 cursor-pointer select-none border-b transition-colors duration-150 ${isCut ? 'opacity-50' : ''}`}
        style={{
            backgroundColor: selected ? 'var(--accent-light)' : 'transparent',
            borderBottomColor: 'var(--border-light)',
        }}
        onMouseOver={(e) => {
            if (!selected) {
                e.currentTarget.style.backgroundColor = 'var(--bg-hover)';
            }
        }}
        onMouseOut={(e) => {
            if (!selected) {
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

export default FileRow;
